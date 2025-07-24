# Apache DevLake Deployments

This repository contains manifests to deploy [Apache DevLake](https://devlake.apache.org/) in Konflux CI OpenShift clusters.

## Overview

This deployment includes OpenShift-specific configurations for [Apache DevLake](https://devlake.apache.org/), including:

- Security context fixes for OpenShift compatibility
- Remote plugin disabling to avoid Openshift permission issues
- OpenShift Routes for external access

## Files

- `openshift-values.yaml` - OpenShift-specific Helm values
- `hack/deploy-devlake-openshift.sh` - Deployment script

## Deployment

### Using the Deployment Script (Recommended)

```bash
# Deploy DevLake on OpenShift with default version (1.0.2)
./hack/deploy-devlake-openshift.sh

# Deploy with a specific version
./hack/deploy-devlake-openshift.sh 1.0.2
```

The script will:

- Generate an encryption secret if not already set
- Deploy DevLake with OpenShift-specific configurations
- Display access URLs after deployment

### Manual Deployment

If you prefer to run the helm command manually:

```bash
# Set encryption secret (if not already set)
export ENCRYPTION_SECRET=$(openssl rand -base64 2000 | tr -dc 'A-Z' | fold -w 128 | head -n 1)

# Deploy DevLake on OpenShift
helm upgrade --install devlake devlake/devlake \
  --namespace devlake \
  --create-namespace \
  --version 1.0.2 \
  -f openshift-values.yaml \
  --set lake.encryptionSecret.secret=$ENCRYPTION_SECRET
```

## Configuration

### OpenShift Compatibility Fixes

- **Security Contexts**: Empty security contexts to let OpenShift handle defaults
- **Lake**: Remote plugins disabled to avoid permission issues

### Routes

The deployment creates OpenShift Routes for:

- `devlake` - DevLake UI

## Other Kubernetes Distributions

For deployments on other Kubernetes distributions (like vanilla Kubernetes, EKS, GKE, AKS, etc.), please refer to the official [Apache DevLake Helm Chart](https://github.com/apache/incubator-devlake-helm-chart) repository.

## Resources

- [Apache DevLake Official Website](https://devlake.apache.org/)
- [Apache DevLake Documentation](https://devlake.apache.org/docs/)
- [Apache DevLake GitHub Repository](https://github.com/apache/incubator-devlake)
- [Apache DevLake Helm Chart Repository](https://github.com/apache/incubator-devlake-helm-chart)
