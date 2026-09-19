#!/bin/sh
set -eu

runtime_kubeconfig=/tmp/jenkins-kubeconfig
cp /root/.kube/config "$runtime_kubeconfig"

cluster_name=$(kubectl --kubeconfig "$runtime_kubeconfig" config view --minify -o 'jsonpath={.contexts[0].context.cluster}')
kubectl --kubeconfig "$runtime_kubeconfig" config set-cluster "$cluster_name" \
    --server=https://k8s-observability-cluster-control-plane:6443 >/dev/null

export KUBECONFIG="$runtime_kubeconfig"
exec /usr/bin/tini -- /usr/local/bin/jenkins.sh "$@"
