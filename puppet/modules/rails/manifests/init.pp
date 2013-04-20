# /home/vagrant/.rbenv/versions/1.9.3-p392/lib/ruby/gems/1.9.1/gems/passenger-4.0.0.rc6/doc/Users guide Nginx.html

class rails {
  include rails::passenger

  define app( $sitedomain ) {
    include rails

    file { "/opt/nginx/sites-available/${name}.conf":
      content => template("rails/app.conf.erb"),
      require => File["/opt/nginx/sites-available"],
    }

    file { "/opt/nginx/sites-enabled/${name}.conf":
      ensure   => link,
      target   => "/opt/nginx/sites-available/${name}.conf",
      require  => File["/opt/nginx/sites-enabled"],
      notify   => Exec["reload-nginx"],
    }

    file { "/opt/nginx/conf/includes/${name}.conf":
      source   => [ "puppet:///modules/rails/${name}.conf", "puppet:///modules/rails/empty.conf" ],
      notify   => Exec["reload-nginx"],
    }

    # file { [ "/var/www",
      # "/var/www/${name}",
      # "/var/www/${name}/releases",
      # "/var/www/${name}/shared",
      # "/var/www/${name}/shared/config",
      # "/var/www/${name}/shared/log",
      # "/var/www/${name}/shared/system" ]:
      # ensure => directory,
      # mode   => 775,
      # owner  => "www-data",
      # group  => "www-data",
    # }

  }
}

