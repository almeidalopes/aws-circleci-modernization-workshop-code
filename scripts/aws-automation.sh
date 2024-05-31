#!/bin/bash

# LOG=./logfile.log


# Run the first command and capture the output
output=$(aws codeguru-security create-upload-url --scan-name cci-workshop-cli-scan-4)


# Extract the values of requestHeaders and s3Url using jq
request_headers=$(echo "$output" | jq -r '.requestHeaders')
s3_url=$(echo "$output" | jq -r '.s3Url')

# Upload the file using curl
curl -X PUT -T aws-circleci-modernization-workshop-code-main.zip -k --header "x-amz-server-side-encryption: aws:kms" --header "x-amz-server-side-encryption-aws-kms-key-id: arn:aws:kms:us-east-1:782306986901:key/1122a919-25c2-4805-be67-0c23e6a8e751" "$s3_url"

# Extract the codeArtifactId from the first command output

code_artifact_id=$(echo "$output" | jq -r '.codeArtifactId')

# Run the second command with the codeArtifactId
aws codeguru-security create-scan --scan-name cci-workshop-cli-scan-4 --resource-id "{\"codeArtifactId\":\"$code_artifact_id\"}"

aws codeguru-security get-findings --scan-name cci-workshop-cli-scan-4
