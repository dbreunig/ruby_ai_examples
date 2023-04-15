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

## Examples

- **Faker GPT:** Similar to the [faker](https://github.com/faker-ruby/faker) gem, but generates seed data that is similar to input expamples you provide.
