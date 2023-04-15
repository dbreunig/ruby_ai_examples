# RSS to Bio
#
# Given an RSS feed URL, this script will generate a bio paragraph for the 
# authors in the feed.

require "dotenv/load"
require "openai"
require "json"
require "open-uri"
require "feedjira"

# Grab the RSS feed and prepare the input data
target_feed = "http://feeds.feedburner.com/seriouseatsfeaturesvideos"
feed = Feedjira.parse(URI.open(target_feed).read)
authors = {}
feed.entries.each do |entry|
  summary = entry.summary
  # Fallback to the first 1000 characters of the content if no summary is available
  summary = entry.content[0..300] if summary.nil? || summary.length == 0
  # Remove HTML tags
  summary = summary.gsub(/<\/?[^>]*>/, "").split("\n").find { |line| line.length > 0 }
  author = entry.author
  title = entry.title
  title ||= entry.raw_title
  authors[author] = [] unless authors[author]
  authors[author] << {
    title: title,
    summary: summary
  }
end

bios = {}
# Only grab the first 3 authors. This can be a big list if the RSS goes back a ways.
authors.first(3).each do |author, articles|
  # Only submit the first 10 articles for each author
  summaries = articles.first(10).map { |article| (article[:summary].length > 0) ? "Title: #{article[:title]}\nSummary: #{article[:summary]}" : "Title: #{article[:title]}" }.join("\n\n")
  # Set up the OpenAI client, define the prompt, and send the request
  client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [
        {role: "user", content: "Analyze the following article titles and summaries written by #{author} and provide a short paragraph describing the subjects touched on by the writing of #{author}, appropriate for use in a short biography about the author:\n#{summaries}"}
      ],
      temperature: 0.7
    }
  )
  # Parse the JSON response into an array
  response_string = response.dig("choices", 0, "message", "content")
  bios[author] = response_string
end

# Print the bios
pp bios
