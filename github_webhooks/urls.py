from django.urls import include, path

from github_webhooks.views import handler, EventViewSet
from rest_framework import routers

router = routers.DefaultRouter()
router.register(r"events", EventViewSet, basename="event")

urlpatterns = [
    path("", handler, name="github-webhook-handler"),
    path("api/", include(router.urls)),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
]
