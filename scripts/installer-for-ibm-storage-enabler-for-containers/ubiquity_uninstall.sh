#!/bin/bash

#*******************************************************************************
#  Copyright 2017 IBM Corp.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#*******************************************************************************

# -------------------------------------------------------------------------
# IBM Storage Enabler for Containers uninstall script
# The script uninstalls following IBM Storage Enabler for Containers (Ubiquity) components from the Kubernetes cluster:
#       IBM Storage Enabler for Containers
#       IBM Storage Dynamic Provisioner for Kubernetes
#       IBM Storage FlexVolume for Kubernetes
# In addition, it uninstalls the Ubiquity data stored in PV ibm-ubiquity-db.
#
# Delete the following components in the given order:
#   1. ubiquity-db deployment. Wait until the deletion is complete.
#   2. PVC for the ibm-ubiquity-db. Wait until the deletion  of PVC and PV is complete.
#   3. Storage class that match for the UbiquityDB PVC
#   4. ubiquity-k8s-provisioner deployment
#   6. ubiquity-k8s-flex daemonset
#   7. ubiquity deployment
#   8. ubiquity service
#      ServiceAccount, ClusterRoles and ClusterRolesBinding
#   9. ubiquity-db service
#
# Note: The script deletes the ubiquity-k8s-flex daemonset, but it does not delete the Flex driver from the nodes.
#        It is not mandatory to delete the Flex driver.
#        To delete the Flex driver manually, use the following procedure for each node:
#           1. Remove the Flex directory: /usr/libexec/kubernetes/kubelet-plugins/volume/exec/ibm~ubiquity-k8s-flex
#           2. Restart the kubelet service
#
# -------------------------------------------------------------------------


function usage()
{
  cmd=`basename $0`
  echo "USAGE   $cmd [-n <namespace>] [-k] [-h]"
  echo "  Options:"
  echo "    -n [<namespace>] : By default, it is \"ubiquity\" namespace"
  echo "    -k : Keep the Ubiquity data stored in PV ibm-ubiquity-db"
  echo "    -h : Display this usage"
  exit 1
}

# Variables
scripts=$(dirname $0)
YML_DIR="./yamls"
UBIQUITY_DB_PVC_NAME=ibm-ubiquity-db
UTILS=$scripts/ubiquity_lib.sh
FLEX_K8S_DIR=/usr/libexec/kubernetes/kubelet-plugins/volume/exec/ibm~ubiquity-k8s-flex

# Handle flags
NS="ubiquity" # default namespace
KEEP_UBIQUITY_DB_PVC=false
while getopts ":n:k" opt; do
  case $opt in
    n)
      NS=$OPTARG
      ;;
    k)
      KEEP_UBIQUITY_DB_PVC=true
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done
nsf="--namespace ${NS}" # namespace flag for kubectl command

kubectl_delete="kubectl delete $nsf --ignore-not-found=true"

# Validations
[ ! -d "$YML_DIR" ] && { echo "Error: YML directory [$YML_DIR] does not exist."; exit 1; }
[ ! -f $UTILS ] && { echo "Error: $UTILS file is not found"; exit 3; }
kubectl get namespace $NS >/dev/null 2>&1 || { echo "Error: [$NS] namespace does not exist. Stop the uninstall process."; exit 3; }

. $UTILS # include utils for wait function and status

if [ "$KEEP_UBIQUITY_DB_PVC" = false ] ; then
    echo "Attention: Uninstall \"$PRODUCT_NAME\" will delete all Ubiquity components, including ubiquity-db, credentials and namespace."
else
    echo "Attention: Uninstall \"$PRODUCT_NAME\" will delete all Ubiquity components except the ubiquity-db PVC."
fi
read -p "Are you sure (y/n): " yn
if [ "$yn" != "y" ]; then
   echo "Skip uninstall."
   exit 0
fi
echo "Start to uninstall \"$PRODUCT_NAME\" from namespace [$NS]..."

# First phase : delete the ubiquity-db deployment and ubiquity-db-pvc before deleting ubiquity and provisioner.
if kubectl get $nsf deployment ubiquity-db >/dev/null 2>&1; then
    $kubectl_delete -f $YML_DIR/${UBIQUITY_DB_DEPLOY_YML}
    echo "Wait for ubiquity-db deployment deletion..."
    wait_for_item_to_delete deployment ubiquity-db 10 4 "" $NS
    wait_for_item_to_delete pod "ubiquity-db-" 10 4 regex $NS # to match the prefix of the pod
fi

if [ "$KEEP_UBIQUITY_DB_PVC" = false ] ; then
    $kubectl_delete -f ${YML_DIR}/ubiquity-db-pvc.yml
    echo "Waiting for PVC ${UBIQUITY_DB_PVC_NAME} to be deleted, before deleting Ubiquity and Provisioner."
    wait_for_item_to_delete pvc ${UBIQUITY_DB_PVC_NAME} 10 3 "" $NS
    pvname=`kubectl get -n ubiquity cm/ubiquity-configmap -o jsonpath="{.data['IBM-UBIQUITY-DB-PV-NAME']}"`
    echo "Waiting for PV $pvname to be deleted, before deleting Ubiquity and Provisioner."
    [ -n "$pvname" ] && wait_for_item_to_delete pv $pvname 10 3 "" $NS
fi

# Second phase: Delete all the stateless components
$kubectl_delete -f ${YML_DIR}/storage-class.yml
$kubectl_delete -f $YML_DIR/${UBIQUITY_PROVISIONER_DEPLOY_YML}

$kubectl_delete -f $YML_DIR/${UBIQUITY_FLEX_DAEMONSET_YML}

$kubectl_delete -f $YML_DIR/${UBIQUITY_DEPLOY_YML}
$kubectl_delete -f ${YML_DIR}/../ubiquity-configmap.yml
$kubectl_delete -f ${YML_DIR}/../${SCBE_CRED_YML}
$kubectl_delete -f ${YML_DIR}/../${SPECTRUMSCALE_CRED_YML}
$kubectl_delete -f ${YML_DIR}/../${UBIQUITY_DB_CRED_YML}
$kubectl_delete -f $YML_DIR/ubiquity-service.yml
$kubectl_delete -f $YML_DIR/ubiquity-db-service.yml

if kubectl get $nsf clusterroles  ${ICP_CLUSTERROLES_FOR_PSP} >/dev/null 2>&1; then
   $kubectl_delete -f $YML_DIR/ubiquity-icp-rolebinding.yml
fi

$kubectl_delete -f $YML_DIR/ubiquity-k8s-provisioner-clusterrolebindings.yml
$kubectl_delete -f $YML_DIR/ubiquity-k8s-provisioner-clusterroles.yml
$kubectl_delete -f $YML_DIR/ubiquity-k8s-provisioner-serviceaccount.yml

if [ "$KEEP_UBIQUITY_DB_PVC" = false ] ; then
    $kubectl_delete -f $YML_DIR/ubiquity-namespace.yml
fi

echo ""
echo "\"$PRODUCT_NAME\" uninstall finished."

