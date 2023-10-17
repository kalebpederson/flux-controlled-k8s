# Initial Setup

WARNING: The below doesn't attempt to be a perfect example of a secure implementation!

1. Install software desired for deployment mechanism:
  * An up-to-date az cli 
  * az aks install-cli
  * az extension add --name k8s-configuration
  * az extension add --name k8s-extension
1. Install Azure AKS with flux extension.
1. Create Git repo for Kubernetes configuration (in my case, flux-controlled-k8s on GitHub).
1. Create personal access token (PAT) with read access to the repo created in step 2.
1. Create an image pull secret or attach an AKS ACR to your cluster:
  * Attach:
    * az aks update -n cai-policy-poc-aks -g cai-policy-poc-rg --attach-acr kppmetadatatesting
  * Image Pull Secrets:
    * kc create secret docker-registry acr-registry --namespace default --docker-server=kppmetadatatesting.azurecr.io '--docker-username=<SP_USERNAME>' '--docker-password=<SP_PASSWORD>'
    * kc patch serviceaccount default -p '{"imagePullSecrets": [{"name": "acr-registry"}]}'
1. Create your flux configuration:
  * az k8s-configuration flux create --name flux-controlled-k8s --cluster-name cai-policy-poc-aks --namespace flux-system --resource-group cai-policy-poc-rg -u https://github.com/kalebpederson/flux-controlled-k8s.git --kind git --https-user 'kalebpederson' --https-key 'github_pat_<SECRET_HERE>' --scope cluster --cluster-type managedClusters --branch main --kustomization name=flux-controlled-k8s prune=true path=manifests

# Resources

* https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-gitops-flux2-ci-cd

