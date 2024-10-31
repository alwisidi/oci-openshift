#!/bin/bash
COMPARTMENT_ID=$1
CLUSTER_NAME=$2

INSTANCE_DATA=$(oci compute instance list \
  --compartment-id "$COMPARTMENT_ID" \
  --query "data[?\"defined-tags\".\"openshift-$CLUSTER_NAME\".\"instance-role\" == 'storage' && \"lifecycle-state\" == 'RUNNING'].{instance_name: \"display-name\", id: id}" \
  --raw-output | tr -d '[:space:]' | tr -d '"' | sed 's/\[//g' | sed 's/\]//g' | sed 's/},{/ - /g' | sed 's/{//g' | sed 's/}//g')

echo "{\"instance_data\": \"$INSTANCE_DATA\"}"