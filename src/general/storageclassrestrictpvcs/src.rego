package k8sstorageclassrestrictpvcs

is_pvc(obj) {
  obj.apiVersion == "v1"
  obj.kind == "PersistentVolumeClaim"
}

violation[{"msg": msg}] {
  input.review.operation != "DELETE"
  is_pvc(input.review.object)
  pvc := input.review.object

  pvc.spec.storageClassName == input.parameters.storageClasses[_]
  regex := input.parameters.disallowedPVCRegex[_]
  re_match(regex, pvc.metadata.name)

  custom_msg := object.get(input.parameters, "customViolationMessage", "")
  msg := trim(sprintf("PVC <%v> is restricted from using storageclass <%v>. %v", [pvc.metadata.name, pvc.spec.storageClassName, custom_msg]), " ")
}
