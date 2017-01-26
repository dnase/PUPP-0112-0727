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
    owner => $owner,
    group => $group,
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
    ensure  => file,
    path    => "${docroot}/index.html",
    content => epp('nginx/index.html.epp', { docroot => $docroot}),
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
  file { 'default.conf':
    ensure  => file,
    path    => "${blockdir}/default.conf",
    content => epp('nginx/default.conf.epp', {docroot => $docroot}),
    require => Package[$package],
  }
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['default.conf', 'nginx.conf'],
  }
}
