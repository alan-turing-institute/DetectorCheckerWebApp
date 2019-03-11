#!/usr/bin/env python
"""
A simple script to upload data to azure as a blob.

"""

import os
import argparse
import smtplib

from azure.storage.blob import BlockBlobService, PublicAccess

_container_name = os.environ['AZURE_CONTAINER']

block_blob_service = BlockBlobService(
  account_name=os.environ['AZURE_STORAGE_ACCOUNT'],
  connection_string=os.environ['AZURE_CONNECTION_STRING'])

def check_blob_exists(blob_name):
  """
  Checks if blob exists

  """

  exist = False

  generator = block_blob_service.list_blobs(_container_name)

  for blob in generator:
    if (blob.name == blob_name):
      exist = True
      break

  return exist

def email_confirmation(blob_name, email_to):
  """
  Sends email confirmation of upload is successful.

  """

  gmail_user = os.environ['DC_EMAIL_ACC']
  gmail_password = os.environ['DC_EMAIL_PWD']

  sent_from = gmail_user
  subject = 'Data upload notification'

  email_text = """\
From: %s
To: %s
Subject: %s


Dear DetectorChecker user,

File %s has been uploaded successfuly.

- DetectorChecker Team
  """ % (sent_from, email_to, subject, blob_name)

  try:
    server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
    server.ehlo()
    server.login(gmail_user, gmail_password)
    server.sendmail(sent_from, email_to, email_text)
    server.close()

  except:
    raise RuntimeError("Problem sending email confirmation.")

  return

if __name__ == "__main__":

  parser = argparse.ArgumentParser(description="Uploads blobs to Azure")

  parser.add_argument("--source", default=None)
  parser.add_argument("--target", default=None)
  parser.add_argument("--email", default=None)
  args = parser.parse_args()

  if not args.source or not args.target:
    raise RuntimeError("Source file and/or target file were not specified.")

  file_path = (args.source).strip()
  blob_name = (args.target).strip()

  if args.email is not None:
    email = (args.email).strip()
  else:
    email = None

  blob_exists = check_blob_exists(blob_name)

  if not blob_exists:
    try:
      block_blob_service.create_blob_from_path(_container_name, blob_name, file_path)

    except ValueError as e:
      raise RuntimeError(e)

  else:
    raise RuntimeError("A blob with the filename of %s already exists!" % (blob_name))

  # upload was successful let's send a email notification
  if email is not None:
    email_confirmation(blob_name, email)
