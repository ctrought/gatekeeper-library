# StorageClassRestrictPVCs

The `StorageClassRestrictPVCs` constraint blocks the creation of PVCs if its name 
matches at least one of the regex strings & is using one of the storage classes 
configured in the constraint. 

This policy helps prevent workloads matching the provided criteria from being run 
on persistent volumes that are not preferred for that type of workload. For example,
a cluster may have a storageclass that does not support or is not preferred for 
certain database workloads. By blocking the PVC from being created, the user could 
be steered towards the recommended storageclass in the cluster for this type of 
workload.
