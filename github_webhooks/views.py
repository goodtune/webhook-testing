import json

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST

from github_webhooks.models import Event


@csrf_exempt
@require_POST
def handler(request):
    payload = json.loads(request.body)
    event = Event.objects.create(
        id=request.headers["X-Github-Delivery"],
        event=request.headers["X-Github-Event"],
        hook_id=request.headers["X-Github-Hook-Id"],
        installation_id=request.headers["X-Github-Hook-Installation-Target-Id"],
        installation_type=request.headers["X-Github-Hook-Installation-Target-Type"],
        payload=payload,
    )
    return JsonResponse({"event": event.pk})
