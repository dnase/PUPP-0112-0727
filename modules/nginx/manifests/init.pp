class nginx {
  package { 'nginx':
    ensure => present,
  }
  file { 'webroot':
    ensure => directory,
    path   => '/var/www',
    owner  => 'root',
    group  => 'root',
    mode   => '0775',
  }
  file { 'index.html':
    ensure => file,
    path   => '/var/www/index.html',
    owner  => 'root',
    group  => 'root',
    mode   => '0664',
    source => 'puppet:///modules/nginx/index.html',
  }
  file { 'nginx.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    path    => '/etc/nginx/nginx.conf',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
  }
  file { 'default.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    path    => '/etc/nginx/conf.d/default.conf',
    source  => 'puppet:///modules/nginx/default.conf',
    require => Package['nginx'],
  }
  service { 'nginx':
    ensure    => running,
    subscribe => File['default.conf', 'nginx.conf'],
  }
}
