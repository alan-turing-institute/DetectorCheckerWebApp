#!/bin/bash


export AZURE_STORAGE_ACCOUNT="detectorcheckerstorage"
export AZURE_STORAGE_ACCESS_KEY="aSMDADXSZEdGfBiuIUMlmvBIZEWhY+40NvQ5JLZKADsBZ5ZCYTxin7HvhSL5/cu15vOIYXIEHaaKsYcEKdufdA=="
export AZURE_CONTAINER="detectorcheckercontainer"

Rscript run.R
