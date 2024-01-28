import os
import logging
from hashlib import sha256
from hmac import HMAC, compare_digest
from json import dumps, loads

import boto3
import botocore

LOG = logging.getLogger()
LOG.setLevel("INFO")


def handler(event, context):
    LOG.info("## ENVIRONMENT VARIABLES")
    LOG.info(os.getenv("AWS_LAMBDA_LOG_GROUP_NAME"))
    LOG.info(os.getenv("AWS_LAMBDA_LOG_STREAM_NAME"))
    LOG.info("## EVENT")
    LOG.info(event)
    if verify_signature(event["headers"], event["body"]):
        if publish_sns({"headers": event["headers"], "body": loads(event["body"])}):
            return respond("Success")
        else:
            return respond("Failed", 500)
    return respond("Forbidden", 403)


def respond(message, code=200):
    return {"statusCode": code, "body": dumps({"message": message})}


def publish_sns(message):
    try:
        arn = os.environ.get("TOPIC_ARN")
        client = boto3.client("sns")
        response = client.publish(
            TargetArn=arn,
            Message=dumps({"default": dumps(message)}),
            MessageStructure="json",
        )
    except botocore.exceptions.ClientError as e:
        print(f"ClientError: {e}")
        response = {"error": e.response["Error"]["Message"]}
    return response


def verify_signature(headers, body):
    try:
        secret = os.environ.get("GITHUB_SECRET").encode("utf-8")
        received = headers["X-Hub-Signature-256"].split("sha256=")[-1].strip()
        expected = HMAC(secret, body.encode("utf-8"), sha256).hexdigest()
    except (KeyError, TypeError):
        return False
    else:
        return compare_digest(received, expected)
