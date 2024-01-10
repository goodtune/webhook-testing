from django.contrib import admin

from github_webhooks.models import Event


@admin.register(Event)
class EventAdmin(admin.ModelAdmin):
    list_display = ("pk", "event", "received")
    list_filter = (
        "event",
        "received",
        "hook_id",
        "installation_id",
        "installation_type",
    )
    readonly_fields = ("received", "event", "payload")
