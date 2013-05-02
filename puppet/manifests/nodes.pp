node default {
  include nodejs

  exec { "update-packages":
    command => '/usr/bin/apt-get update'
  }

  package { ["vim", "curl", "git-core"]:
    ensure => present
  }

  rails::app { "jeffersoncarley":
    sitedomain => "jeffersoncarley.com",
  }

  class { 'mongodb':
    init         => 'sysv',
    enable_10gen => true,
  }

  Exec["update-packages"] -> Package <| |>
}
