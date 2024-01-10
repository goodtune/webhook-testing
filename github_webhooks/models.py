import uuid

from django.db import models
from django.db.models.functions import Now


class Event(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    received = models.DateTimeField(db_default=Now(), editable=False)
    event = models.CharField(max_length=64, editable=False)
    hook_id = models.PositiveIntegerField(db_index=True, editable=False)
    installation_id = models.PositiveIntegerField(db_index=True, editable=False)
    installation_type = models.CharField(max_length=64, db_index=True, editable=False)
    payload = models.JSONField(editable=False)
