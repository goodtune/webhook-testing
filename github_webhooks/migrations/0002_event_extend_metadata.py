# Generated by Django 5.0.1 on 2024-01-10 19:43

from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [
        ("github_webhooks", "0001_initial"),
    ]

    operations = [
        migrations.AddField(
            model_name="event",
            name="hook_id",
            field=models.PositiveIntegerField(db_index=True, editable=False),
        ),
        migrations.AddField(
            model_name="event",
            name="installation_id",
            field=models.PositiveIntegerField(db_index=True, editable=False),
        ),
        migrations.AddField(
            model_name="event",
            name="installation_type",
            field=models.CharField(db_index=True, editable=False, max_length=64),
        ),
    ]
