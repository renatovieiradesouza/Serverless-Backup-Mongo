import requests
from requests.auth import HTTPDigestAuth
import urllib3
import json
import datetime
import time
import logging
from dotenv import load_dotenv
import os
import boto3

#Setup
urllib3.disable_warnings()
logger = logging.getLogger()
logger.setLevel(logging.INFO)
load_dotenv()

def generateBackup(event,context):

  USERNAME            = os.getenv('USERNAME')
  PASSWORD            = os.getenv('PASSWORD')
  SQS_QUEUE_URL       = os.getenv('SQS_QUEUE_URL')
  dateNow             = datetime.datetime.now()
  descriptionSnapshot = ("QueuedByAWSLambda-{}")
  url                 = f"https://cloud.mongodb.com/api/atlas/v1.0/groups/6126d382372961609c82001a/clusters/production/backup/snapshots?pretty=true"

  payload = json.dumps({
    "description": descriptionSnapshot.format(dateNow),
    "retentionInDays": 1
  })

  headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }

  response = requests.request("POST", url, headers=headers, data=payload,auth=HTTPDigestAuth(USERNAME, PASSWORD))
  dataResponse  = json.loads(response.text)

  logger.info(response.text)
  logger.info(f"Status code: {response.status_code}")
  logger.info(dataResponse["id"])

  send_message(SQS_QUEUE_URL,"snapshot",dataResponse["id"])

  return response.status_code

def send_message(queue,keyMessage,bodyMessage):
    sqs_client = boto3.client("sqs", region_name="sa-east-1")
    message    = {keyMessage: bodyMessage}

    response = sqs_client.send_message(
        QueueUrl=queue,
        MessageBody=json.dumps(message)
    )
    logger.info(response)
