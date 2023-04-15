# Auto Localizer
#
# Given an input en.yml file, this script will translate each value string
# into the languages specified in the `languages` array. It will then output
# a new YAML file with the translated strings for each language provided.
# OpenAI's GPT-3 API is used to perform the translations.

require "dotenv/load"
require "openai"
require "yaml"

def translate(value, translation_dict, languages)
  # If we've already translated this string, return the translation
  if translation_dict.has_key?(value)
    return translation_dict[value]
  end

  # Otherwise, translate the string and add it to the translation dict
  client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [
        {role: "system", content: "You are an API that returns a JSON object with a key for each language you want to translate to."},
        {role: "user", content: "Translate the following string into the following languages: #{languages.join(", ")}. Return only a JSON dictionary with each respective language abbreviation as a key and the corresponding translation of the following text as the value. Here is the text to translate into each language:\n#{value}"}
      ],
      temperature: 0.7
    }
  )
  response_string = response.dig("choices", 0, "message", "content")
  # Occasionally GPT will return a JSON string with context around it. Clear that out.
  response_string = response_string.slice(response_string.index("{")..response_string.rindex("}"))
  puts response_string
  translation_dict[value] = JSON.parse(response_string)
  return translation_dict[value]
end

def translate_values(hash, translation_dict, languages)
  hash.each do |key, value|
    if value.is_a?(Hash)
      translate_values(value, translation_dict, languages)
    else
      translate(value, translation_dict, languages)
    end
  end
end

# Prepare the input yml file
input = YAML.load_file("./example_data/small.en.yml") # Change this to your input file
languages = ["es", "fr", "de", "it", "ru", "ja"] # Add or remove languages

# We're going to have a key that maps each string to a dict of translations
# Example: translation_dict["Hello"] = {es: "Hola", fr: "Bonjour"}
translation_dict = {}
translate_values(input, translation_dict, languages)


# Replicate the input yml file, but with the translations
languages.each do |language|
  yaml_string = input.to_yaml
  translation_dict.each do |key, value|
    yaml_string.gsub!(key, value[language])
  end
  File.write("./example_data/output/small.#{language}.yml", yaml_string)
end
