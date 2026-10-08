# Google Cloud Platform - Kubernetes Engine OpenTofu Module

[![OpenTofu Tests](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-google-kubernetes-engine/test.yml?style=for-the-badge&logo=opentofu&color=FEDA15&label=OpenTofu%20Tests)](https://github.com/osinfra-io/pt-arche-google-kubernetes-engine/actions/workflows/test.yml) [![Dependabot](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-google-kubernetes-engine/dependabot.yml?style=for-the-badge&logo=github&color=2088FF&label=Dependabot)](https://github.com/osinfra-io/pt-arche-google-kubernetes-engine/actions/workflows/dependabot.yml) [![Datadog Security Enabled](https://img.shields.io/badge/Datadog%20Security-Enabled-632CA6?style=for-the-badge&logo=datadog)](https://app.datadoghq.com/security/code-security/repositories?repository_id=pt-arche-google-kubernetes-engine)

## Repository Description

Reusable OpenTofu child module that provisions a GKE cluster with Workload Identity, KMS encryption for cluster databases and node boot disks, and CIS GKE Benchmark hardening. It supports GKE Fleet host and member project configurations with multi-cluster service discovery and multi-cluster ingress hub features. Namespace-scoped workload identity service accounts are created per namespace, enabling fine-grained IAM bindings for workloads running in the cluster.

## 🔩 Usage

### Module interfaces

| Source path | Purpose | Interface |
| --- | --- | --- |
| Repository root | Creates fleet-level IAM, workload identity service accounts, and multi-cluster service discovery configuration. | [`variables.tofu`](variables.tofu) · [`outputs.tofu`](outputs.tofu) |
| `//regional` | Creates the private GKE cluster, node pools, KMS keys, node service account, and optional fleet-host resources. | [`regional/variables.tofu`](regional/variables.tofu) · [`regional/outputs.tofu`](regional/outputs.tofu) |
| `//regional/onboarding` | Creates namespaces, namespace-admin RBAC, workload identity Kubernetes service accounts, and optional ambient-mesh labels. | [`regional/onboarding/variables.tofu`](regional/onboarding/variables.tofu) |

Regional clusters default to the `REGULAR` release channel with deletion protection, private nodes, Workload Identity, Shielded Nodes, Advanced Datapath, GKE cost allocation, and CMEK for cluster databases and node boot disks. Gateway API, fleet-host behavior, node pools, and node auto-provisioning are opt-in. KMS keys can make cluster data unrecoverable if their key versions are destroyed, and the child module cannot enforce consumer-side lifecycle protection. GKE clusters, nodes, control-plane features, logging/monitoring, and KMS usage incur GCP costs.

> [!TIP]
> You can check the [tests/fixtures](tests/fixtures) directory for example configurations. These fixtures set up the system for testing by providing all the necessary initial code, thus creating good examples on which to base your configurations.

Google project services must be enabled before using this module. As a best practice, these should be defined in the [pt-arche-google-project](https://github.com/osinfra-io/pt-arche-google-project) module. The following services are required:

- `certificatemanager.googleapis.com`
- `container.googleapis.com`
- `cloudkms.googleapis.com`
- `cloudresourcemanager.googleapis.com`
- `gkehub.googleapis.com` (Only needed if the project is a GKE Fleet host project)
- `multiclusteringress.googleapis.com` (Only needed if the project is a GKE Fleet host project)
- `multiclusterservicediscovery.googleapis.com`
- `trafficdirector.googleapis.com`

## 🛠️ Tools

- [osinfra-pre-commit-hooks](https://github.com/osinfra-io/pt-techne-pre-commit-hooks)
- [pre-commit](https://github.com/pre-commit/pre-commit)

## 📋 Skills and Knowledge

Links to documentation and other resources required to develop and iterate in this repository successfully.

- [kubernetes engine](https://cloud.google.com/kubernetes-engine/docs)
  - [multi cluster ingress](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress)
  - [multi cluster service discovery](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-services)
  - [node pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools)
  - [RBAC](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control)
  - [workload identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [shared vpc](https://cloud.google.com/vpc/docs/shared-vpc)
  - [cluster creation](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc)

## 🔍 Tests

All tests are [mocked](https://opentofu.org/docs/cli/commands/test/#the-mock_provider-blocks) allowing us to test the module without creating infrastructure or requiring credentials. The trade-offs are acceptable in favor of speed and simplicity. In an OpenTofu test, a mocked provider or resource will generate fake data for all computed attributes that would normally be provided by the underlying provider APIs.

```none
tofu init
```

```none
tofu test
```

## 📦 Release

To release a new version, simply push a new tag to the repository. The tag should be in the format `vX.Y.Z` where `X`, `Y`, and `Z` are integers.

```none
git tag vX.Y.Z
git push origin vX.Y.Z
```
