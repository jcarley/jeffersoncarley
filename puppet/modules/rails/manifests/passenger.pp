class rails::passenger {

  $as_vagrant = 'sudo -u vagrant -H bash -l -c'
  $home = '/home/vagrant'
  $passenger_version = "3.0.19"

  $passenger_dependencies = [ "build-essential",
                              "libcurl4-openssl-dev",
                              "libssl-dev"]
  package { $passenger_dependencies: ensure => installed }

  exec { "install-passenger":
    command => "${home}/.rbenv/versions/1.9.3-p392/bin/gem install passenger --version=${passenger_version} --no-ri --no-rdoc",
    unless  => "${home}/.rbenv/versions/1.9.3-p392/bin/gem list | /bin/grep passenger | /bin/grep ${passenger_version}",
    require => Package[$passenger_dependencies],
    timeout => "-1",
  }

  exec { "install-passenger-nginx-module":
    command => "${home}/.rbenv/versions/1.9.3-p392/bin/passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx",
    creates => "/opt/nginx/sbin/nginx",
    require => Exec["install-passenger"],
    timeout => "-1",
  }

  file { [ "/opt/nginx",
           "/opt/nginx/conf",
           "/opt/nginx/conf/includes",
           "/opt/nginx/sites-enabled",
           "/opt/nginx/sites-available",
           "/var/log/nginx" ]:
    ensure  => directory,
    owner   => "www-data",
    group   => "www-data",
  }

  file { "/opt/nginx/sites-enabled/default":
    ensure  => absent,
    require => Exec["install-passenger-nginx-module"],
  }

  file { "/opt/nginx/conf/nginx.conf":
    content  => template("rails/nginx.conf.erb"),
    notify   => Exec["reload-nginx"],
    require  => Exec["install-passenger-nginx-module"],
  }

  file { "/etc/init.d/nginx":
    source  => "puppet:///modules/rails/nginx.init",
    mode    => "700",
    require => Exec["install-passenger-nginx-module"],
  }

  service { "nginx":
    enable   => true,
    ensure   => running,
    require  => File["/etc/init.d/nginx"],
  }

  exec { "reload-nginx":
    command     => "/opt/nginx/sbin/nginx -t && /etc/init.d/nginx reload",
    refreshonly => true,
    require     => Exec["install-passenger-nginx-module"],
  }

}


