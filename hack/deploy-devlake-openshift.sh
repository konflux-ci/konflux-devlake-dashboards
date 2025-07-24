#!/bin/bash

# Default version
VERSION=${1:-1.0.2}

echo "[INFO] Deploying DevLake on OpenShift (version: $VERSION)"

# Set encryption secret if not already set
if [ -z "$ENCRYPTION_SECRET" ]; then
    echo "[INFO] Generating encryption secret..."
    ENCRYPTION_SECRET=$(openssl rand -base64 2000 | tr -dc 'A-Z' | fold -w 128 | head -n 1)
    export ENCRYPTION_SECRET
fi

echo "[INFO] Deploying DevLake with OpenShift-specific configurations..."
helm upgrade --install devlake devlake/devlake \
  --namespace devlake \
  --create-namespace \
  --version $VERSION \
  -f openshift-values.yaml \
  --set lake.encryptionSecret.secret=$ENCRYPTION_SECRET

echo ""
echo "Deployment complete!"
echo ""

echo ""
echo "Access URLs:"
oc get routes -n devlake -o custom-columns=NAME:.metadata.name,HOST:.spec.host
