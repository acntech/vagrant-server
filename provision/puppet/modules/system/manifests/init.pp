class system (
  $packages = [
  ]
  ) {

  exec { "system-apt-update":
    command => "apt update",
  }

  exec { "system-apt-upgrade":
    command => "apt --yes upgrade",
    require => Exec["system-apt-update"],
  }

  package { $packages:
    ensure => "installed",
    require => Exec["system-apt-update"],
  }
}
