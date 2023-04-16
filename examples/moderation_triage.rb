# Moderation Triage
#
# This script evaluates a `target_text` against a small summary of a content policy,
# inspired by Facebook's community standards: https://transparency.fb.com/policies/community-standards/
#
# If the text violates any of the rules, the script will return a list of the rules violated. If GPT is
# not able to make a determination, it will return "unknown", flagging the content for human triage.
#
# Swap out the `target_text` with whatever text you want to evaluate.

require "dotenv/load"
require "openai"
require "json"
require "open-uri"
require "nokogiri"

def list_violations(text)
  # Set up the OpenAI client, define the prompt, and send the request
  client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [
        {role: "user", content: "Our site's content policy contains the following rules: \nContent should not incite violence\nContent should not coordinate harm or promote crime\nContent should not promote or sell restricted goods\nContent should not involve suicide or self injury\nContent should not sexually exploit others\nContent should not bully or harrass others\nContent should not violate an individual's privacy\nContent should not contain hate speech or racism\nContent should not contains queerphobic or transphobic speech\nContent should not contain violent or graphic content\nContent should not contain nudity or sexual activity\nContent should not solicit sex\nContent should not promote conspiracy theories\nContent should not promote scams.\n\n\nGiven the rules in our content policy, list the rules violated by the following text. Return each rule violated as individual strings, matching exactly the text of the rule stated above, contained in a JSON array:\n#{text}"}
      ],
      temperature: 0.7
    }
  )
  response_string = response.dig("choices", 0, "message", "content")
  JSON.parse(response_string)
end

# Example content violation
target_text = "Nobody died at Sandy Hook."

# Example passing content
# target_text = "I went to a school named Sandy Hook Elementary. I'm very sad what happened there."

# Set up the OpenAI client, define the prompt, and send the request
client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      {role: "user", content: "Our site's content policy is: 'Content should not incite violence, not coordinate harm or promote crime, not promote or sell restricted goods, not involve suicide or self injury, not sexually exploit others, not bully or harrass others, not violate an individual's privacy, not contain hate speech or racism, not contains queerphobic or transphobic speech, not contain violent or graphic content, not contain nudity or sexual activity, not solicit sex, not promote conspiracy theories, and not promote scams.'\nDoes the following text violate our content policy? Respond only with 'true' if the text violates the content policy, 'false' if it does not violate the content policy, or 'unknown' if you're unsure or can't tell:\n#{target_text}"}
    ],
    temperature: 0.7
  }
)

# Parse the response into a cleaned string.
# GPT-3 annoyingly adds periods and capitals.
response_string = response.dig("choices", 0, "message", "content").downcase.gsub(/\W+/, "")

# Print the identified strings
case response_string
when "true"
  puts "Violates content policy"
  p list_violations(target_text)
when "false"
  puts "Does not violate content policy"
else
  puts "Have a human approve or deny"
end

