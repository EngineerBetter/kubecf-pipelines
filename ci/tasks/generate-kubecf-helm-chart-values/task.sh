#!/usr/bin/env bash

set -euo pipefail

jq -ner \
  --argjson terraform "$(cat "outputs/terraform.json")" \
  --arg system_domain "${SYSTEM_DOMAIN}" \
  '{
    "system_domain": $system_domain,
    "high_availability": true,
    "services": {
      "router":  {
        "loadBalancerIP": $terraform.gorouter_static_ip
      },
      "ssh-proxy": {
        "loadBalancerIP": $terraform.ssh_proxy_static_ip
      }
    },
    "settings": {
      "router": {
        "tls": {
          "crt": $terraform.wildcard_cert.chain,
          "key": $terraform.wildcard_cert.private_key
        }
      }
    },
    "sizing": {
      "nats": {
        "instances": 1
      }
    },
    "kube": {
      "storage_class": "pd-ssd"
    },
    "features": {
      "embedded_database": {
        "enabled": false
      },
      "external_database": {
        "enabled": true,
        "ca_cert": $terraform.db_ca_cert_pem,
        "type": "mysql",
        "host": $terraform.db_host,
        "port": $terraform.db_port,
        "databases": {
          "uaa": {
            "name": $terraform.db_uaa_name,
            "password": $terraform.db_uaa_password,
            "username": $terraform.db_uaa_username
          },
          "cc": {
            "name": $terraform.db_cloud_controller_name,
            "password": $terraform.db_cloud_controller_password,
            "username": $terraform.db_cloud_controller_username
          },
          "bbs": {
            "name": $terraform.db_diego_name,
            "password": $terraform.db_diego_password,
            "username": $terraform.db_diego_username
          },
          "routing_api": {
            "name": $terraform.db_routing_api_name,
            "password": $terraform.db_routing_api_password,
            "username": $terraform.db_routing_api_username
          },
          "policy_server": {
            "name": $terraform.db_network_policy_name,
            "password": $terraform.db_network_policy_password,
            "username": $terraform.db_network_policy_username
          },
          "silk_controller": {
            "name": $terraform.db_network_connectivity_name,
            "password": $terraform.db_network_connectivity_password,
            "username": $terraform.db_network_connectivity_username
          },
          "locket": {
            "name": $terraform.db_locket_name,
            "password": $terraform.db_locket_password,
            "username": $terraform.db_locket_username
          },
          "credhub": {
            "name": $terraform.db_credhub_name,
            "password": $terraform.db_credhub_password,
            "username": $terraform.db_credhub_username
          }
        }
      }
    }
  }' >values/values.json
