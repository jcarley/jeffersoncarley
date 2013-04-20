
node default {
  exec { "update-packages":
    command => '/usr/bin/apt-get update'
  }

  package { ["nodejs", "vim", "curl", "git-core"]:
    ensure => present
  }

  rails::app { "jeffersoncarley":
    sitedomain => "jeffersoncarley.com",
  }

  Exec["update-packages"] -> Package <| |>
}
