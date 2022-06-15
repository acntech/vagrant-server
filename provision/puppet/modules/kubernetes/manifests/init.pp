class kubernetes (
  ) {

  exec { "download-minikube":
    command => "curl -fsSL \"https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb\" -o /tmp/minikube.deb",
    unless => ["dpkg -l minikube > /dev/null 2>&1"],
  }

  exec { "install-minikube":
    command => "dpkg -i /tmp/minikube.deb",
    subscribe => Exec["download-minikube"],
    refreshonly => true,
  }

  exec { "cleanup-minikube":
    command => "rm /tmp/minikube.deb",
    subscribe => Exec["install-minikube"],
    refreshonly => true,
  }
}
