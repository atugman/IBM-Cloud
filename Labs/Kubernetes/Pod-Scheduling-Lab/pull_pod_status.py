from kubernetes import client, config

def get_pending_pods():
    try:
        config.load_kube_config()

        v1 = client.CoreV1Api()
        response = v1.list_namespaced_pod(namespace="default", watch=False)
        
        for pod in response.items:
            if pod.status.phase == "Pending":

                print("\nPod:",pod.metadata.name,"\n",
                      "- Namespace:",pod.metadata.namespace,"\n",
                      "- Status:",pod.status.phase,"\n",
                      "- Reason:",pod.status.conditions[0].reason,"\n",
                      "- Message:",pod.status.conditions[0].message)

    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    get_pending_pods()