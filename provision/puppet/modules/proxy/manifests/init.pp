class proxy (
  ) {

  file { '/opt/proxy':
    ensure => 'directory',
  }

  file { "add-docker-compose":
    path => "/opt/proxy/docker-compose.yml",
    source => "puppet:///modules/proxy/docker-compose.yml",
    replace => false,
  }

  file { "add-haproxy-config":
    path => "/opt/proxy/haproxy.cfg",
    source => "puppet:///modules/proxy/haproxy.cfg",
    replace => false,
  }

  exec { "start-haproxy-container":
    command => "cd /opt/proxy && docker compose up -d",
    unless => ["docker inspect proxy > /dev/null 2>&1"],
  }
}
