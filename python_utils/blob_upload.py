#!/usr/bin/env python
"""
A simple script to upload data to azure as a blob.

"""

import os
import argparse

from azure.storage.blob import BlockBlobService, PublicAccess

_container_name = "detectorcheckercontainer"

block_blob_service = BlockBlobService(
  account_name=os.environ['AZURE_STORAGE_ACCOUNT'],
  account_key=os.environ['AZURE_STORAGE_ACCESS_KEY'])

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

if __name__ == "__main__":

  parser = argparse.ArgumentParser(description="Uploads blobs to Azure")
  
  parser.add_argument("--source", default=None)
  parser.add_argument("--target", default=None)
  args = parser.parse_args()
  
  if not args.source or not args.target:
    raise RuntimeError("Source file and/or target file were not specified.")
  
  file_path = (args.source).strip()
  blob_name = (args.target).strip()

  blob_exists = check_blob_exists(blob_name)

  if not blob_exists:
    try:
      block_blob_service.create_blob_from_path(_container_name, blob_name, file_path)
      
    except ValueError as e:
      raise RuntimeError(e)
      
  else:
    raise RuntimeError("A blob with the filename of %s already exists!" % (blob_name))
