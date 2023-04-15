# Pull Quote Extractor
#
# This script uses the OpenAI API to identify a good pull quote in an article.
# Provide this script with a URL and it will download the HTML.
# It then ask the OpenAI LLM to extrac the article body and  identify a compelling
# and representative pull quote in the article to entice reders.
#
# Swap out the URL with whatever URL you want to summarize. Change the
# number_of_desired_pull_quotes variable to change the number of categories returned.

require "dotenv/load"
require "openai"
require "json"
require "open-uri"
require "nokogiri"

# Prepare the input HTML
target_url = "https://www.dbreunig.com/2022/06/06/why-media-metrics-matter.html"
html_doc = Nokogiri::HTML(URI.open(target_url))
target_text = html_doc.css("body").inner_text.gsub(/\s+/, " ").strip
number_of_desired_pull_quotes = 2

# Set up the OpenAI client, define the prompt, and send the request
client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      # {role: "system", content: "You are a helpful API that a."},
      {role: "user", content: "Analyze the following article and identify #{number_of_desired_pull_quotes} pull quotes from the article. The pull quotes should be brief, interesting, compelling, and representative of the article. Each pull quote should represent different concepts, ideas, or questions in the article. Return these pull quotes as individual strings contained within an JSON array:\n#{target_text}}"}
    ],
    temperature: 0.7
  }
)

# Parse the JSON response into an array
response_string = response.dig("choices", 0, "message", "content")
pull_quotes = JSON.parse(response_string)

# Print the identified strings
p pull_quotes
