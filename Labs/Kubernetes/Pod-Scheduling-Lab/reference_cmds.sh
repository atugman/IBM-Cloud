#add to guide.md where appropriate, then delete
k get nodes -l label1
k get nodes -l label2
k get nodes -l label3
kubectl get pods -o wide # shows node pod is on
k apply -f ./specs/.
k delete -f ./specs/.
#
k get nodes

# taint nodes
kubectl taint nodes <node2/> taint1=taint_value_1:NoSchedule

kubectl taint nodes <node3/> taint2=taint_value_2:NoSchedule


# remove taints
kubectl taint nodes <node2/> taint1=taint_value_1:NoSchedule-

kubectl taint nodes <node3/> taint2=taint_value_2:NoSchedule-
