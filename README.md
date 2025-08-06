# Apache DevLake OpenShift Deployment

This repository contains OpenShift manifests to deploy [Apache DevLake](https://devlake.apache.org/) based on the official [Apache DevLake Helm Chart](https://github.com/apache/incubator-devlake-helm-chart/tree/main/charts/devlake).

## Overview

This deployment includes OpenShift-specific configurations for [Apache DevLake](https://devlake.apache.org/), including:

- **Exact Helm Chart Structure**: All manifests are based on the official Helm chart templates
- **OpenShift Routes**: For external access to UI and Grafana
- **Security Contexts**: Compatible with OpenShift security requirements
- **Production Resources**: CPU and memory requests/limits for all components

## Quick Deploy

Deploy DevLake on OpenShift using the provided hack script:

```bash
# Make the script executable
chmod +x hack/deploy-devlake-openshift.sh

# Deploy with default version (1.0.2)
./hack/deploy-devlake-openshift.sh

# Or specify a custom version
./hack/deploy-devlake-openshift.sh 1.0.1

# Check deployment status
oc get pods -n devlake

# Get access URLs
oc get routes -n devlake
```

## Components

### **Namespace**
- `devlake` - Isolated namespace for all DevLake components

### **Secrets**
- `devlake-mysql-auth` - MySQL credentials (root password: `admin`, user password: `merico`)
- `devlake-encryption-secret` - Encryption key for DevLake
- `devlake-grafana` - Grafana admin credentials (admin/admin)

### **ConfigMaps**
- `devlake-config` - Database connection configuration
- `devlake-grafana` - Grafana INI configuration

### **Storage**
- `devlake-mysql-data` - 50Gi PVC for MySQL data
- `devlake-grafana` - 4Gi PVC for Grafana data

### **Services**
- `devlake-mysql` - MySQL database (port 3306)
- `devlake-lake` - DevLake API (port 8080)
- `devlake-grafana` - Grafana dashboard (port 80)
- `devlake-ui` - Configuration UI (port 4000)

### **Routes**
- `devlake-ui` - Access to DevLake UI
- `devlake-grafana` - Direct access to Grafana

## Access URLs

After deployment, access the applications at:

- **DevLake UI**: `https://devlake-ui-devlake.apps.<cluster-domain>/`
- **Grafana**: `https://devlake-grafana-devlake.apps.<cluster-domain>/`

## Default Credentials

- **Grafana**: `admin` / `admin`
- **MySQL Root**: `admin`
- **MySQL User**: `merico` / `merico`

## Key Features

### **Production Resources**
All deployments include proper resource requests and limits:

- **MySQL**: 2Gi/1C requests, 4Gi/2C limits
- **Lake**: 2Gi/1C requests, 4Gi/2C limits  
- **Grafana**: 1Gi/500m requests, 2Gi/1C limits
- **UI**: 512Mi/250m requests, 1Gi/500m limits

### **Authentication**
- **Google OAuth**: Currently commented out in `openshift-values.yaml`. To enable:
  1. Uncomment the `auth.google` section in `openshift-values.yaml`
  2. Add your Google OAuth client ID and secret
  3. Update the `redirect_uri` to match your cluster domain
  4. Redeploy using the hack script or manual deployment

### **Health Checks**
- All components include liveness and readiness probes
- Database wait init container ensures proper startup order

### **Security**
- Non-root containers where possible
- Proper security contexts for OpenShift
- Secrets for sensitive data

## Troubleshooting

### **Check Pod Status**
```bash
oc get pods -n devlake
oc describe pod <pod-name> -n devlake
```

### **View Logs**
```bash
# Lake logs
oc logs deployment/devlake-lake -n devlake

# Grafana logs  
oc logs deployment/devlake-grafana -n devlake

# MySQL logs
oc logs statefulset/devlake-mysql -n devlake
```

### **Database Connection Issues**
If Grafana can't connect to MySQL:
```bash
# Check MySQL is running
oc get pods -n devlake -l devlakeComponent=mysql

# Test MySQL connection
oc exec deployment/devlake-grafana -n devlake -- nc -z devlake-mysql 3306
```

## Cleanup

To remove all DevLake resources:

```bash
oc delete namespace devlake
```

## Resources

- [Apache DevLake Official Website](https://devlake.apache.org/)
- [Apache DevLake Helm Chart](https://github.com/apache/incubator-devlake-helm-chart)
- [Apache DevLake Documentation](https://devlake.apache.org/docs/)
