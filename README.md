# <img align="left" width="45" height="45" src="https://github.com/osinfra-io/pt-arche-google-kubernetes-engine/assets/1610100/38c94ec5-3cef-4716-9744-791d4df598ba"> Google Cloud Platform - Kubernetes Engine OpenTofu Module

[![OpenTofu Tests](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-google-kubernetes-engine/test.yml?style=for-the-badge&logo=opentofu&color=FEDA15&label=OpenTofu%20Tests)](https://github.com/osinfra-io/pt-arche-google-kubernetes-engine/actions/workflows/test.yml) [![Dependabot](https://img.shields.io/github/actions/workflow/status/osinfra-io/pt-arche-google-kubernetes-engine/dependabot.yml?style=for-the-badge&logo=github&color=2088FF&label=Dependabot)](https://github.com/osinfra-io/pt-arche-google-kubernetes-engine/actions/workflows/dependabot.yml) [![Datadog Security Enabled](https://img.shields.io/badge/Datadog%20Security-Enabled-632CA6?style=for-the-badge&logo=datadog)](https://app.datadoghq.com/security/code-security/repositories?repository_id=pt-arche-google-kubernetes-engine)

## Repository Description

OpenTofu **example** module that provisions a GKE cluster with Workload Identity, KMS encryption for cluster databases and node boot disks, and CIS GKE Benchmark hardening. It supports GKE Fleet host and member project configurations with multi-cluster service discovery and multi-cluster ingress hub features. Namespace-scoped workload identity service accounts are created per namespace, enabling fine-grained IAM bindings for workloads running in the cluster.

## 🔩 Usage

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

## <img align="left" width="35" height="35" src="https://github.com/user-attachments/assets/eb98a3be-2ffe-4c05-91a4-072fe795a167"> Development

Our focus is on the core fundamental practice of platform engineering, Infrastructure as Code.

>Open Source Infrastructure (as Code) is a development model for infrastructure that focuses on open collaboration and applying relative lessons learned from software development practices that organizations can use internally at scale. - [Open Source Infrastructure (as Code)](https://www.osinfra.io)

To avoid slowing down stream-aligned teams, we want to open up the possibility for contributions. The Open Source Infrastructure (as Code) model allows team members external to the platform team to contribute with only a slight increase in cognitive load. This section is for developers who want to contribute to this repository, describing the tools used, the skills, and the knowledge required, along with OpenTofu documentation.

See the [documentation](https://docs.osinfra.io/fundamentals/development-setup) for setting up a local development environment.

### 🛠️ Tools

- [osinfra-pre-commit-hooks](https://github.com/osinfra-io/pt-techne-pre-commit-hooks)
- [pre-commit](https://github.com/pre-commit/pre-commit)

### 📋 Skills and Knowledge

Links to documentation and other resources required to develop and iterate in this repository successfully.

- [kubernetes engine](https://cloud.google.com/kubernetes-engine/docs)
  - [multi cluster ingress](https://cloud.google.com/kubernetes-engine/docs/concepts/multi-cluster-ingress)
  - [node pools](https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools)
  - [RBAC](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control)
  - [workload identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
- [shared vpc](https://cloud.google.com/vpc/docs/shared-vpc)
  - [cluster creation](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc)

### 🔍 Tests

All tests are [mocked](https://opentofu.org/docs/cli/commands/test/#the-mock_provider-blocks) allowing us to test the module without creating infrastructure or requiring credentials. The trade-offs are acceptable in favor of speed and simplicity. In an OpenTofu test, a mocked provider or resource will generate fake data for all computed attributes that would normally be provided by the underlying provider APIs.

```none
tofu init
```

```none
tofu test
```

### 📦 Release

To release a new version, simply push a new tag to the repository. The tag should be in the format `vX.Y.Z` where `X`, `Y`, and `Z` are integers.

```none
git tag vX.Y.Z
git push origin vX.Y.Z
```
