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

urllib3.disable_warnings()
logger = logging.getLogger()
logger.setLevel(logging.INFO)
load_dotenv()

def generateExport(event,context):
  USERNAME = os.getenv('USERNAME')
  PASSWORD = os.getenv('PASSWORD')
  SQS_QUEUE_URL = os.getenv('SQS_QUEUE_URL')

  dateNow = datetime.datetime.now()
  descriptionSnapshot=("QueuedByAWSLambda-{}")
  logger.info(SQS_QUEUE_URL)

  snapshotID = receive_message(SQS_QUEUE_URL)
  logger.info(f"ID FOR TRIGGER API {snapshotID}")

  #Queued export to AWS S3

  logger.info("Starting export to AWS S3 in 5 minutes seconds")
  
  urlT = f"https://cloud.mongodb.com/api/atlas/v1.0/groups/6126d382372961609c82001a/clusters/production/backup/exports/"

  payloadT = json.dumps({
    "snapshotId": snapshotID,
    "exportBucketId": "6318dbf4f5f674698e029f48",
    "customData": [
      {
        "key": "exported by lambda",
        "value": "lambda-prod-sa-east-1"
      }
    ]
  })

  headersT = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  }

  if snapshotID != "":
    responseT = requests.request("POST", urlT, headers=headersT, data=payloadT, auth=HTTPDigestAuth("tkqiaxhf", "d539c5e3-415f-4195-8012-6fc94d5a17b3"))
    logger.info(f"Status code from request move AWS S3 Atlas Mongo: {responseT.status_code}")
    return responseT.status_code
  else:
    return 404

def receive_message(queue):
  sqs_client = boto3.client("sqs", region_name="sa-east-1")
  response = sqs_client.receive_message(
      QueueUrl=queue,
      MaxNumberOfMessages=1,
      WaitTimeSeconds=20,
  )

  logger.info(f"Number of messages received: {len(response.get('Messages', []))}")

  for message in response.get("Messages", []):
      message_body = message["Body"]
      messageOk = json.loads(message_body)
      id = messageOk["snapshot"]
      handle = message['ReceiptHandle']
      # print(f"Message body: {json.loads(message_body)}")
      # print(f"Receipt Handle: {message['ReceiptHandle']}")
      logger.info(f"ID Snapshot: {id}")
      delete_message(handle,queue)
      return id
  
def delete_message(receipt_handle,queue):
  sqs_client = boto3.client("sqs", region_name="sa-east-1")
  response = sqs_client.delete_message(
      QueueUrl=queue,
      ReceiptHandle=receipt_handle,
  )
  logger.info(f"Delete response: {response}")