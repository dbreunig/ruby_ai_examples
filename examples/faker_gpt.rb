# Faker-GPT
#
# This script uses the OpenAI API to generate fake data, similar to the Faker gem.
# Provide a few example strings, and the script will generate more strings in a similar genre.
# Adjust the additional_examples variable to generate more or less strings.

require "dotenv/load"
require "openai"
require "json"

# Prepare the example strings
examples = [
  "Steps for brewing a cup of Aeropress coffee",
  "Warm up routine for climbing",
  "Securing a Debian server",
  "Packing a backpack for a 3-day hike",
  "Preparing for a difficult conversation",
  "Pregame routine for a basketball game",
  "Preflight tasks before sending a newsletter",
  "Weekly household cleaning routine"
]
additional_examples = 10
concatonated_examples = examples.join("\n")

# Set up the OpenAI client, define the prompt, and send the request
client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [
      {role: "system", content: "You are an API that returns a JSON array of strings."},
      {role: "user", content: "Write #{additional_examples} more strings like the following strings, formatted in a JSON array with a separate element for each new string:\n#{concatonated_examples}"}
    ],
    temperature: 0.7
  }
)

# Parse the JSON response into an array
response_string = response.dig("choices", 0, "message", "content")
generated_examples = JSON.parse(response_string)

# Print the generated strings
p generated_examples
