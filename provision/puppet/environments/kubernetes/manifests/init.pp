Exec {
    path => [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ]
}

include system
include docker
include kubernetes
include proxy
