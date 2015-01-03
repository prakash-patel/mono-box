# == Class: profile/xsp

class profile::xsp {

  $version = '2.10'

  exec{'retrieve_xsp_pkg':
    command => "wget http://origin-download.mono-project.com/sources/xsp/xsp-${version}.tar.bz2",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
  }

  exec{ 'extract_xsp_pkg':
    command => "tar -xvjf xsp-${version}.tar.bz2",
    cwd     => '/usr/src',
    require => Exec['retrieve_xsp_pkg'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
  }

  exec{'configure_xsp':
    command => "/usr/src/xsp-${version}/./configure --prefix=/usr",
    cwd     => "/usr/src/xsp-${version}",
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => [Exec['extract_xsp_pkg'],Class['profile::mono']],
    timeout => 0,
  }

  exec{'make_xsp':
    command => "make",
    cwd     => "/usr/src/xsp-${version}",
    require => Exec['configure_xsp'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }

  exec{'install_xsp':
    command => "make install",
    cwd   => "/usr/src/xsp-${version}",
    require => Exec['make_xsp'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }
}
