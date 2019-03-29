#!/bin/bash

# getting secrets
source .secrets/azure_auth.sh
source .secrets/gmail.sh

cd webapp

Rscript run.R
