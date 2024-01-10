# webhook-testing

In order to relay webhooks from GitHub into my work environment, I am running
experiments with how I might achieve this with simple technologies that can
pieced together easily.

The key design principle is that the webhook will be received by something on
the public internet, will publish the payload somewhere, and we will then run a
consumer service within our network that collects the payloads and processes
them.
