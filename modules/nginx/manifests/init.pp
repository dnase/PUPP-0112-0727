class nginx {
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  package { 'nginx':
    ensure => present,
  }
  file { 'webroot':
    ensure => directory,
    path   => '/var/www',
  }
  file { 'index.html':
    ensure => file,
    path   => '/var/www/index.html',
    source => 'puppet:///modules/nginx/index.html',
  }
  file { 'nginx.conf':
    ensure  => file,
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
  }
  file { 'default.conf':
    ensure  => file,
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
  }
  service { 'nginx':
    ensure    => running,
    subscribe => File['default.conf', 'nginx.conf'],
  }
}
