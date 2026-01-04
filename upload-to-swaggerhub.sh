#!/bin/bash

# Upload OpenAPI spec to SwaggerHub via API
# Usage: ./upload-to-swaggerhub.sh

echo "🚀 SwaggerHub Upload Script"
echo "=============================="
echo ""

# Check if API key is provided as argument or prompt for it
if [ -z "$1" ]; then
  echo "Enter your SwaggerHub API Key:"
  read -s SWAGGERHUB_API_KEY
  echo ""
else
  SWAGGERHUB_API_KEY=$1
fi

# Configuration
OWNER="play2sell-ecd"
API_NAME="salesos-eventservice-api"
VERSION="3.0.0"
SPEC_FILE="openapi/salesos-api-v3.0.yaml"

echo "📋 Configuration:"
echo "   Owner: $OWNER"
echo "   API: $API_NAME"
echo "   Version: $VERSION"
echo "   File: $SPEC_FILE"
echo ""

# Check if file exists
if [ ! -f "$SPEC_FILE" ]; then
  echo "❌ Error: Spec file not found: $SPEC_FILE"
  exit 1
fi

echo "📤 Uploading to SwaggerHub..."
echo ""

# Upload to SwaggerHub
response=$(curl -X POST \
  "https://api.swaggerhub.com/apis/${OWNER}/${API_NAME}" \
  -H "Authorization: ${SWAGGERHUB_API_KEY}" \
  -H "Content-Type: application/yaml" \
  -H "Accept: application/json" \
  --data-binary "@${SPEC_FILE}" \
  -w "\n%{http_code}" \
  -s)

# Extract HTTP status code (last line)
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')

echo "📊 Response Code: $http_code"
echo ""

if [ "$http_code" -eq 201 ] || [ "$http_code" -eq 200 ]; then
  echo "✅ SUCCESS! API v${VERSION} uploaded to SwaggerHub!"
  echo ""
  echo "🔗 View at:"
  echo "   https://app.swaggerhub.com/apis/${OWNER}/${API_NAME}/${VERSION}"
  echo ""

  # Set as default and publish
  echo "📌 Setting as default version and publishing..."
  curl -X PUT \
    "https://api.swaggerhub.com/apis/${OWNER}/${API_NAME}/settings/default" \
    -H "Authorization: ${SWAGGERHUB_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"version\": \"${VERSION}\"}" \
    -s > /dev/null

  curl -X PUT \
    "https://api.swaggerhub.com/apis/${OWNER}/${API_NAME}/${VERSION}/settings/lifecycle" \
    -H "Authorization: ${SWAGGERHUB_API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{"published": true}' \
    -s > /dev/null

  echo "✅ Version set as default and published!"
  echo ""
  echo "🎉 All done!"

else
  echo "❌ FAILED! HTTP $http_code"
  echo ""
  echo "Response:"
  echo "$body"
  echo ""
  echo "Common issues:"
  echo "  - 401: Invalid API key"
  echo "  - 409: Version already exists (delete it first in SwaggerHub)"
  echo "  - 403: Insufficient permissions"
fi
