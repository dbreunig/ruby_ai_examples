# Article Categorizer
#
# This script uses the OpenAI API to categorize a given article.
# Provide this script with a URL and it will down the HTML.
# It then ask the OpenAI LLM to extrac the article body and  assign it a set number of
# topical categories, which can be then used to group texts and help users navigate
# content.
#
# Swap out the URL with whatever URL you want to summarize. Change the
# number_of_desired_categories variable to change the number of categories returned.

require "dotenv/load"
require "openai"
require "json"
require "net/http"

# Prepare the example strings
target_url = URI.parse("https://www.dbreunig.com/2020/09/21/the-gauntlet-growing-social-networks-face-just-got-harder.html")
response = Net::HTTP.get_response(target_url)
target_html = response.body
number_of_desired_categories = 5

# Set up the OpenAI client, define the prompt, and send the request
client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      # {role: "system", content: "You are a helpful API that a."},
      {role: "user", content: "Given the following HTML, extract the article text. Analyze the article text and provide #{number_of_desired_categories} concise topics to help a user understand the subject being discussed. Return these categories as individual strings contained within an JSON array:\n#{target_html}"}
    ],
    temperature: 0.7
  }
)

# Parse the JSON response into an array
response_string = response.dig("choices", 0, "message", "content")
identified_categories = JSON.parse(response_string)

# Print the identified strings
p identified_categories
