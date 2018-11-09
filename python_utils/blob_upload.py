#!/usr/bin/env python
"""
"""

import os

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

  file_path = "/Users/tlazauskas/Desktop/user-defined.dc"
  blob_name = "new-user-defined.dc"

  blob_exists = check_blob_exists(blob_name)

  if not blob_exists:

    block_blob_service.create_blob_from_path(_container_name, blob_name, file_path)


  else:
    print("Need new name")

  print("Finished.")
