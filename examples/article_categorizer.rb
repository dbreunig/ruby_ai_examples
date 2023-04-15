# Article Categorizer
#
# This script uses the OpenAI API to categorize a given article.
# Provide this script with a URL and it will download the HTML.
# It then ask the OpenAI LLM to extrac the article body and  assign it a set number of
# topical categories, which can be then used to group texts and help users navigate
# content.
#
# Swap out the URL with whatever URL you want to summarize. Change the
# number_of_desired_categories variable to change the number of categories returned.

require "dotenv/load"
require "openai"
require "json"
require "open-uri"
require "nokogiri"

# Prepare the input HTML
target_url = "https://www.dbreunig.com/2016/06/23/the-business-implications-of-machine-learning.html"
html_doc = Nokogiri::HTML(URI.open(target_url))
target_text = html_doc.css("body").inner_text.gsub(/\s+/, " ").strip
number_of_desired_categories = 5

# Set up the OpenAI client, define the prompt, and send the request
client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      # {role: "system", content: "You are a helpful API that a."},
      {role: "user", content: "Analyze the following article text and provide #{number_of_desired_categories} 1 to 3 word topics to help a user understand the subject being discussed. Return these categories as individual strings contained within an JSON array:\n#{target_text}"}
    ],
    temperature: 0.7
  }
)

# Parse the JSON response into an array
response_string = response.dig("choices", 0, "message", "content")
identified_categories = JSON.parse(response_string)

# Print the identified strings
p identified_categories
