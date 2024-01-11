import uuid

from django.db import models
from django.db.models.functions import Now

from rest_framework import serializers


class Event(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    received = models.DateTimeField(db_default=Now(), editable=False)
    event = models.CharField(max_length=64, editable=False)
    hook_id = models.PositiveIntegerField(db_index=True, editable=False)
    installation_id = models.PositiveIntegerField(db_index=True, editable=False)
    installation_type = models.CharField(max_length=64, db_index=True, editable=False)
    payload = models.JSONField(editable=False)


class EventListSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Event
        fields = ("id", "received", "event", "url")


class EventSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Event
        fields = (
            "url",
            "id",
            "event",
            "hook_id",
            "installation_id",
            "installation_type",
            "payload",
        )
