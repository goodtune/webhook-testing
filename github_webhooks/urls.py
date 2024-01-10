from django.urls import path

from github_webhooks.views import handler

urlpatterns = [
    path("", handler, name="github-webhook-handler"),
]
