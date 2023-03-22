package k8sstorageclassrestrictpvcs

test_input_denied_pvc_name_1 {
    input := { "review": input_review_pvc_name("pvc-postgres-0", "slow"), "parameters": { "storageClasses": ["slow", "old"], "disallowedPVCRegex": [".*postgres.*", ".*mariadb.*"] } }
    results := violation with input as input
    count(results) == 1
}
test_input_denied_pvc_name_2 {
    input := { "review": input_review_pvc_name("mariadb-pvc", "old"), "parameters": { "storageClasses": ["old"], "disallowedPVCRegex": [".*postgres.*", ".*mariadb.*", "other"] } }
    results := violation with input as input
    count(results) == 1
}
test_input_allowed_pvc_name {
    input := { "review": input_review_pvc_name("dump", "slow"), "parameters": { "storageClasses": ["slow", "old"], "disallowedPVCRegex": [".*mariadb.*"] } }
    results := violation with input as input
    count(results) == 0
}
test_input_allowed_pvc_sc {
    input := { "review": input_review_pvc_name("mariadb-pvc", "fast"), "parameters": { "storageClasses": ["old"], "disallowedPVCRegex": [".*postgres.*", ".*mariadb.*", "other"] } }
    results := violation with input as input
    count(results) == 0
}

input_review_pvc_name(name, storageclass) = output {
  output = {
    "object": {
      "apiVersion": "v1",
      "kind": "PersistentVolumeClaim",
      "metadata": {
        "name": name
      },
      "spec": {
        "accessModes": ["ReadWriteOnce"],
        "volumeMode": "Filesystem",
        "resources": {
          "requests": {
            "storage": "8Gi"
          }
        },
        "storageClassName": storageclass
      }
    }
  }
}
