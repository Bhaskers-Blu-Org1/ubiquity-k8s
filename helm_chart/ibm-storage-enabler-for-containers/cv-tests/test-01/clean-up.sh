#!/bin/bash
#
###############################################################################
# Licensed Materials - Property of IBM
# 5737-E67
# (C) Copyright IBM Corporation 2016, 2018 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
###############################################################################

# Clean-up script REQUIRED ONLY IF 'helm delete <releasename> --purge' for
# this test path will result in orphaned components.
#
# For example, if PersistantVolumes (PVs) are created as pre-requisite to chart installation
# they will need to be deleted post helm delete.
#
# Parameters :
#   -c <chartReleaseName>, the name of the release used to install the helm chart
#
# Pre-req environment: authenticated to cluster & kubectl cli install / setup complete

# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail

[[ `dirname $0 | cut -c1` = '/' ]] && preinstallDir=`dirname $0`/ || preinstallDir=`pwd`/`dirname $0`/

# Process parameters notify of any unexpected
while test $# -gt 0; do
        [[ $1 =~ ^-c|--chartrelease$ ]] && { chartRelease="$2"; shift 2; continue; };
    echo "Parameter not recognized: $1, ignored"
    shift
done
: "${chartRelease:="default"}"

# Verify pre-req environment of kubectl exists
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }

#delete the secret
echo "Delete secret for sc and ubiquity db"
kubectl delete -f $preinstallDir/pre-install/scbe-secret.yaml
kubectl delete -f $preinstallDir/pre-install/ubiquity-db-secret.yaml
echo "Delete local pv"
kubectl delete -f $preinstallDir/pre-install/local-pvc.yaml > /dev/null 2>&1 || echo "local-pvc has been deleted."
kubectl delete -f $preinstallDir/pre-install/local-pv.yaml > /dev/null 2>&1 || echo "local-pv has been deleted."
echo "Get clusterimagepolicies"
my_yml=$preinstallDir/clusterimagepolicies.yaml
echo "my yaml file is ${my_yml}"
kubectl get clusterimagepolicies ibmcloud-default-cluster-image-policy -o yaml >> ${my_yml}
echo "remove private repo for clusterimagepolicies"
sed -i "/  - name: stg-artifactory.haifa.ibm.com:5030/d" ${my_yml}
kubectl replace -f ${my_yml}
echo "Remove ${my_yml}"
if [[ -a ${my_yml} ]];then
echo "remove it"
rm -f ${my_yml}
fi