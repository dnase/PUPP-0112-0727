class nginx {
  case $::osfamily {
    'redhat', 'debian' : {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/var/www'
      $confdir = '/etc/nginx'
      $blockdir = '/etc/nginx/conf.d'
    }
    'windows' : {
      $package = 'nginx-service'
      $owner = 'Administrator'
      $group = 'Administrators'
      $docroot = 'C:/ProgramData/nginx/html'
      $confdir = 'C:/ProgramData/nginx/conf'
      $blockdir = 'C:/ProgramData/nginx/conf.d'
    }
    default : {
      fail("Module ${module_name} is not supported on ${::osfamily}")
    }
  }
  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }
  package { $package:
    ensure => present,
  }
  file { 'webroot':
    ensure => directory,
    path   => $docroot,
  }
  file { 'index.html':
    ensure => file,
    path   => "${docroot}/index.html",
    source => "puppet:///modules/nginx/index.html",
  }
  file { 'nginx.conf':
    ensure  => file,
    path    => "${confdir}/nginx.conf",
    source  => "puppet:///modules/nginx/${::osfamily}.conf",
    require => Package[$package],
  }
  file { 'default.conf':
    ensure  => file,
    path    => "${blockdir}/default.conf",
    source  => "puppet:///modules/nginx/default-${::kernel}.conf",
    require => Package[$package],
  }
  service { 'nginx':
    ensure    => running,
    subscribe => File['default.conf', 'nginx.conf'],
  }
}
