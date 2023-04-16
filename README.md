# AI Examples in Ruby

In this repository I'll be collecting simple scripts to illustrate LLM use cases. We'll be using Ruby and (usually) OpenAI's APIs. These scripts are proof-of-concepts: they work, but their prompts haven't been rigorously tested for reliability or security. (If you're curious about how you might go about doing that, check out [this post](https://huyenchip.com/2023/04/11/llm-engineering.html) by Chip Huyen.)

To try these scripts out on your own, install the following:

```bash
$ gem install ruby-openai dotenv
```

Then, create a `.env` file in this project's root and add this line:

```
OPENAI_API_KEY=[your key here]
```

Except with your key after the `=`. Get a key [here](https://platform.openai.com/account/api-keys).

Occasionally scripts will have dependencies not mentioned here. Check their `require` statements and `gem install` as necessary.

## Examples

- **Article Categorizer:** Provide a URL and the script will roughly extract the body text then send it to OpenAI to analyze and provide a specified number of categories given the topics contained within the article.
- **Auto Localizer:** This script takes in a `yml` string file, in English, and generates translated `yml` files in whatever languages you specify. (Examples are in the 'example_data' folder.)
- **Faker GPT:** Similar to the [faker](https://github.com/faker-ruby/faker) gem, but generates seed data that is similar to input expamples you provide.
- **Moderation Triage:** Given a text, evaluate whether the text violates a content policy. If it does, list how the text violates the content policy. If the LLM is unable to determine, it will flag the content for a human to evaluate.
- **Pull Quote Extractor:** Provide a URL and the script will roughly extract the body text then send it to OpenAI to analyze and provide a specified number of compelling and representative pull quotes contained within the article.
- **RSS to Bio:** Provide an RSS URL and the script will download the posts and prepare them. It will then provide summaries and titles for each author in the feed and ask OpenAI to write a short biography on their writing.

## Known Issues

- Often, the text contained in given URLs will exceed the token limits for the endpoint. Try another link, truncate the article, or chunk up the the text and make multiple requests.
- The `auto_localizer.rb` doesn't deal well with long strings that are quoted and given new lines by the Ruby `YAML.to_yaml` function. I got lazy and didn't write a proper *dictionary* translator. Instead I dumped the dictionary into a YAML string, then did find and replace using the translation dictionary. If you want to write a proper function which copies a Ruby dictionary and translates all strings, submit a PR! Otherwise, I may get to it someday.
- If you actually use these, you'd be wise to 'clean' the responses returned. Sometimes GPT will return fluff or needless punctuation around a response. For example, it often returned translations as JSON wrapped in a Markdown context, which was hacked away with: `response_string.slice(response_string.index("{")..response_string.rindex("}"))`. But this is a hack. If you're putting stuff in production, be smarter than me.

Let me know if you have any ideas. Or, feel free to add your own and submit a pull request.
