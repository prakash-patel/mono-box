include mono
#include gdiplus

class mono {

  $mono_version = 'mono-3.10.0'

  $prerequisite_packages = [
    "gcc",
    "gcc-c++",
    "libtool",
    "bison",
    "autoconf",
    "automake",
  ]

  package { $prerequisite_packages:
    ensure   => installed,
    provider => yum,
  }

  package { 'gettext':
    ensure => installed,
  }

  exec{'retrieve_mono_pkg':
    command => "/usr/bin/wget http://download.mono-project.com/sources/mono/${mono_version}.tar.bz2",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Package['gettext'],
  }

  exec{ 'extract_mono_pkg':
    command => "/bin/tar -xvjf ${mono_version}.tar.bz2",
    cwd     => '/usr/src',
    require => Exec['retrieve_mono_pkg'],
  }

  exec{'configure_mono':
    command => "/usr/src/${mono_version}/./configure --prefix=/usr",
    cwd     => "/usr/src/${mono_version}",
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Exec['extract_mono_pkg'],
    timeout => 0,
  }

  exec{'make_mono':
    command => "make",
    cwd     => "/usr/src/${mono_version}",
    require => Exec['configure_mono'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }

  exec{'make_install_mono':
    command => "make install",
    cwd   => "/usr/src/${mono_version}",
    require => Exec['make_mono'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
    notify  => Exec['mono_version'],
  }

  exec{ "mono_version" :
    command   => 'echo mono --version',
    path      => "/usr/sbin:/usr/bin:/sbin:/bin",
    logoutput => true,
  }

  exec{ "mcs_version" :
    command => 'echo mcs --version',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    logoutput => true,
  }
}
