from django.contrib import admin
from github_webhooks.models import Event


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ("pk", "event", "received")
    list_filter = ("event", "received")
    readonly_fields = ("received", "event", "payload")
