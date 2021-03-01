#!/usr/bin/env bash

# This script waits untils the KubeCF deployment is ready
green() { printf "\e[32m%s\e[m\n" "$1"; }
yellow() { printf "\e[33m%s\e[m\n" "$1"; }
red() { printf "\e[31m%s\e[m\n" "$1"; }

retry_counter=1
yellow "Waiting for QuarksJob/ig to complete (attempt $retry_counter)..."
until [ "$(kubectl get quarksjob/ig -n $KUBECF_NS -o 'jsonpath={.status.completed}')" == "true" ]; do
  if [ $retry_counter -ge 60 ]; then
    red "QuarksJob/ig did not complete in time"
    exit 1
  fi
  sleep 10
  retry_counter="$(( retry_counter + 1 ))"
  yellow "Waiting for QuarksJob/ig to complete (attempt $retry_counter)..."
done
green "QuarksJob/ig completed"

yellow "Waiting for all Pods to be ready..."
if kubectl wait --for=condition=Ready --timeout=20m pods -n $KUBECF_NS --all -l '!job-name'; then
  green "All Pods ready"
  exit 0
fi

red "Not all Pods ready in time"
exit 1
