class nginx {
  case $::osfamily {
    'redhat', 'debian' : {
      $package = 'nginx'
      $owner = 'root'
      $group = 'root'
      $docroot = '/var/www'
      $logdir = '/var/log'
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
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  package { $package:
    ensure => present,
  }
  nginx::vhost { 'default':
    docroot    => $docroot,
    servername => $::fqdn,
  }
  file { "${docroot}/vhosts":
    ensure => directory,
  }
  file { 'nginx.conf':
    ensure     => file,
    path       => "${confdir}/nginx.conf",
    content    => epp('nginx/nginx.conf.epp', {
      user     => $owner,
      logdir   => $logdir,
      confdir  => $confdir,
      blockdir => $blockdir,
    }),
    require => Package[$package],
  }
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['nginx.conf'],
  }
}
