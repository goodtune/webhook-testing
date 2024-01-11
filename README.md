# webhook-testing

In order to relay webhooks from GitHub into my work environment, I am running
experiments with how I might achieve this with simple technologies that can
pieced together easily.

The key design principle is that the webhook will be received by something on
the public internet, will publish the payload somewhere, and we will then run a
consumer service within our network that collects the payloads and processes
them.

## `ngrok` for development

This isn't yet ready for the real-world, but we can make it availble for
testing with a publicly available HTTPS endpoint for GitHub to send `POST`
requests to.

As usual, run `python manage.py runserver` to get a locally running service.
This will bind to the `localhost` interface on  port `8000`.

In another shell, run `ngrok http 8000 --region au` (or some other region) if
you aren't in Australia. This will provide you with a listening service on the
internet, securely tunnelling traffic back to your local development server.

```
ngrok by @inconshreveable                                               (Ctrl+C to quit)

Session Status     online
Account            Touch Technology (Plan: Free)
Version            2.3.41
Region             Australia (au)
Web Interface      http://127.0.0.1:4040
Forwarding         http://f412-120-17-214-230.ngrok-free.app -> http://localhost:8000
Forwarding         https://f412-120-17-214-230.ngrok-free.app -> http://localhost:8000

Connections        ttl     opn     rt1     rt5     p50     p90
                   1       0       0.00    0.00    90.26   90.26
```
