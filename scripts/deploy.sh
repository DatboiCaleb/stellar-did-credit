#!/bin/bash
set -e

NETWORK=${NETWORK:-testnet}
SOURCE="deployer"
FORCE_MAINNET=0

# Allow opt-in for mainnet deployments.
if [[ "$1" == "--force-mainnet" ]]; then
  FORCE_MAINNET=1
  shift
fi

if [[ "$NETWORK" != "testnet" && "$NETWORK" != "mainnet" ]]; then
  echo "Error: NETWORK must be 'testnet' or 'mainnet' (got: '$NETWORK')" >&2
  exit 1
fi

# Guard against accidental mainnet deployments.
if [[ "$NETWORK" == "mainnet" && "$FORCE_MAINNET" -ne 1 ]]; then
  echo "Error: refusing to deploy to mainnet. Pass --force-mainnet to override." >&2
  exit 1
fi

# Warn if stellar-cli default network differs from target NETWORK.
DEFAULT_NETWORK=""
if command -v stellar >/dev/null 2>&1; then
  DEFAULT_NETWORK=$(stellar network default 2>/dev/null | tr -d '\r' | awk '{print $1}') || true
fi
if [[ -n "$DEFAULT_NETWORK" && "$DEFAULT_NETWORK" != "$NETWORK" ]]; then
  echo "Warning: stellar-cli default network is '$DEFAULT_NETWORK', but script target is '$NETWORK'." >&2
fi

echo "Building contracts..."
stellar contract build

echo "Deploying identity-oracle to $NETWORK..."
IDENTITY_ID=$(stellar contract deploy \
  --wasm target/wasm32-unknown-unknown/release/identity_oracle.wasm \
  --source $SOURCE \
  --network $NETWORK)
echo "identity-oracle: $IDENTITY_ID"

echo "Deploying credit-oracle to $NETWORK..."
CREDIT_ID=$(stellar contract deploy \
  --wasm target/wasm32-unknown-unknown/release/credit_oracle.wasm \
  --source $SOURCE \
  --network $NETWORK)
echo "credit-oracle: $CREDIT_ID"

echo "Deploying revocation-registry to $NETWORK..."
REVOCATION_ID=$(stellar contract deploy \
  --wasm target/wasm32-unknown-unknown/release/revocation_registry.wasm \
  --source $SOURCE \
  --network $NETWORK)
echo "revocation-registry: $REVOCATION_ID"

OUT_FILE="deployments.${NETWORK}.json"
echo "Saving to $OUT_FILE..."
cat > "$OUT_FILE" << EOF
{
  "network": "$NETWORK",
  "deployed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "contracts": {
    "identity-oracle": "$IDENTITY_ID",
    "credit-oracle": "$CREDIT_ID",
    "revocation-registry": "$REVOCATION_ID"
  }
}
EOF

echo "Done." 

