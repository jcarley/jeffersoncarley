node default {
  include stdlib

  $run_as_user = "vagrant"
  $ruby_version = '1.9.3-p392'
  $app_name = 'jeffersoncarley'
  $ruby_home = "/home/${run_as_user}/.rbenv/versions/${ruby_version}"
  $app_root_path = "/home/${run_as_user}/apps/${app_name}"

  class { 'roles::setup': }

  package { ['vim', 'openjdk-7-jdk']:
    ensure => present,
  }

  class { "mongodb":
    init         => 'upstart',
    enable_10gen => true,
  }

  # =========== User
  class { 'roles::user':
    run_as_user => $run_as_user,
    ssh_pub_key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAx/t0A139x5hD/k/mrAvcsEstchQ6NiEce4Jt5ZvyUBXEjgMUB2A9BJxwlbORLbRp+PBk37n0lEIt3hYIDbrMRQzB6mFYtlEFptmGBxlCyfgzNawwG9TotJKYro8t7w9C1nH7l2ZVDS7NwfJly+gwDoUg/6A/yE38mOhQkDY8RweFeaVE8UaOe0VP3ilyCcdMdcBW//j+6juuRhbZXkD1sDUN866I9q5ovJBDf9sBTvmWD35irb4svW9kYmVdcXj3a8XHOGN8L+bWgzkyxG3x3kqonq6sBF8q0/awVVE2c8Or9oBmeBzcw3pwwSk3ZX/ms3zlGpnBMWplFOnBrz8bdw==",
  }

  # =========== Ruby runtime
  class { 'roles::ruby':
    run_as_user => $run_as_user,
    version     => $ruby_version,
  }

  # =========== Infrastructure
  class { 'roles::infrastructure': }

  # =========== Application
  class { 'roles::www::puma':
    run_as_user => $run_as_user,
  }

  class { 'roles::www::node': }

  file {[ "/home/${run_as_user}/tmp/",
          "/home/${run_as_user}/tmp/puma" ]:
    ensure => directory,
    owner  => $run_as_user,
    group  => $run_as_user,
    before => Puma::App["${app_name}"],
  }

  puma::app { "${app_name}":
    app_path => $app_root_path,
    user     => $run_as_user,
    puma_tmp => "/home/$run_as_user/tmp/puma",
  }

  Class['roles::setup'] -> Package['openjdk-7-jdk'] -> Class['mongodb'] -> Class['roles::user'] ->
    Class['roles::ruby'] -> Class['roles::infrastructure'] -> Class['roles::www::puma'] -> Class['roles::www::node'] ->
    Puma::App["${app_name}"]
}

