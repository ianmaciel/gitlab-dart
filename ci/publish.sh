#!/usr/bin/env bash

mkdir -p .pub-cache

echo "Writing the credentials file..."

cat <<EOF > ~/.pub-cache/credentials.json
{
  "accessToken":"$ACCESS_TOKEN",
  "refreshToken":"$REFRESH_TOKEN",
  "tokenEndpoint":"$TOKEN_ENDPOINT",
  "scopes":["$SCOPES"],
  "expiration":$EXPIRATION
}
EOF

pub publish -f