# shows all nodes
kubectl get nodes

# shows nodes that have a specific label
kubectl get nodes -l label1
kubectl get nodes -l label2
kubectl get nodes -l label3

# shows pods, incl. node pod is on
kubectl get pods -o wide
kubectl apply -f ./specs/.
kubectl delete -f ./specs/.

# taint nodes
kubectl taint nodes $node2 taint1=taint_value_1:NoExecute
kubectl taint nodes $node3 taint2=taint_value_2:NoSchedule

# remove taints
kubectl taint nodes $node2 taint1=taint_value_1:NoExecute-
kubectl taint nodes $node3 taint2=taint_value_2:NoSchedule-