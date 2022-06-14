set -x 
# https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.2/tap/GUID-install-intro.html

export TAP_VERSION=1.2.0-build.12
imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${INSTALL_REGISTRY_HOSTNAME}/tap-packages
kubectl create ns tap-install
export INSTALL_REGISTRY_USERNAME=bmoussaud@vmware.com
export INSTALL_REGISTRY_PASSWORD="j[YjNv2T@"
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install
tanzu package repository add tanzu-tap-repository --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} -n tap-install


export INSTALL_REGISTRY_HOSTNAME=bmoussaudregistry.azurecr.io
export INSTALL_REGISTRY_USERNAME=bec9f366-9c73-4e4d-be5c-5bd9a8c4f89c
export INSTALL_REGISTRY_PASSWORD=kiM8Q~q7783dnfvCOy9QYUmN4nKfuiMwrFV0Fda8
tanzu secret registry add tap-registry \
  --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
  --server ${INSTALL_REGISTRY_HOSTNAME} \
  --export-to-all-namespaces --yes --namespace tap-install
tanzu package repository add tanzu-tap-repository \
  --url ${INSTALL_REGISTRY_HOSTNAME}/tap-packages:$TAP_VERSION \
  --namespace tap-install

tanzu secret registry list -n tap-install
tanzu package repository get tanzu-tap-repository  --namespace tap-install
tanzu package available list --namespace tap-install


#tanzu package repository add tanzu-tap-repository-$TAP_VERSION --url ${INSTALL_REGISTRY_HOSTNAME}/tap-packages:$TAP_VERSION --namespace tap-install

#tanzu package repository update tanzu-tap-repository-${TAP_VERSION} -n tap-install --url bmoussaudregistry.azurecr.io/tanzu-application-platform/tap-packages:${TAP_VERSION}

#tanzu package repository get tanzu-tap-repository-${TAP_VERSION}  --namespace tap-install


ytt -f local > tap-values.yaml
tanzu package install tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install

tanzu package installed update tap --package-name tap.tanzu.vmware.com  --install --version ${TAP_VERSION} --values-file tap-values.yaml -n tap-install

tanzu package repository update  tanzu-tap-repository-$TAP_VERSION -n tap-install --url bmoussaudregistry.azurecr.io/tanzu-application-platform/tap-packages:${TAP_VERSION} --create

tanzu package installed get tap -n tap-install
tanzu package installed delete  tap -n tap-install




