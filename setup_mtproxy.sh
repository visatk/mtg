#!/bin/bash
# setup_mtproxy.sh

set -e

# AppSec: Define a highly resilient cover domain for FakeTLS (SNI bypass).
COVER_DOMAIN="cloudflare.com"

# Generate 16-byte cryptographic random hex secret
CORE_SECRET=$(head -c 16 /dev/urandom | xxd -p | tr -d '\n')

# Convert cover domain to hex for the SNI payload
DOMAIN_HEX=$(echo -n "$COVER_DOMAIN" | xxd -p | tr -d '\n')

# Construct the 'ee' Fake-TLS secret required by the official proxy
export PROXY_SECRET="ee${CORE_SECRET}${DOMAIN_HEX}"

echo "=================================================================="
echo "APPSEC WARNING: Keep this secret secure."
echo "FAKE-TLS SECRET: $PROXY_SECRET"
echo "=================================================================="

# Prompt for the Ad Tag obtained from @MTProxybot
read -p "Enter your 32-character AD_TAG from @MTProxybot: " AD_TAG
export AD_TAG

# Deploy infrastructure
docker-compose up -d

SERVER_IP=$(curl -s https://ifconfig.me)

echo "=================================================================="
echo "Deployment Complete. Infrastructure active."
echo "Your Shareable Proxy URL (Fake-TLS + Sponsor Channel):"
echo "https://t.me/proxy?server=${SERVER_IP}&port=443&secret=${PROXY_SECRET}"
echo "=================================================================="
