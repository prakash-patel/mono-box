# == Class: profile/xsp
class profile::xsp {

  $version = '2.10'

  exec{'retrieve_xsp_pkg':
    command => "wget http://origin-download.mono-project.com/sources/xsp/xsp-${version}.tar.bz2",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Class['profile::gdiplus'],
    unless  => "ls /usr/src/xsp-${version}.tar.bz2",
  }

  exec{ 'extract_xsp_pkg':
    command     => "tar -xvjf xsp-${version}.tar.bz2",
    cwd         => '/usr/src',
    subscribe   => Exec['retrieve_xsp_pkg'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    refreshonly => true,
    user        => 'root',
  }

  exec{'configure_xsp':
    command => "/usr/src/xsp-${version}/./configure --prefix=/usr",
    cwd         => "/usr/src/xsp-${version}",
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['extract_xsp_pkg'],
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
  }

  exec{'make_xsp':
    command     => "su -c 'make'",
    cwd         => "/usr/src/xsp-${version}",
    environment => ["PKG_CONFIG_PATH=/usr/lib/pkgconfig"],
    subscribe   => Exec['configure_xsp'],
    user        => 'root',
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    refreshonly => true,
  }

  exec{'install_xsp':
    command     => "su -c 'make install'",
    cwd         => "/usr/src/xsp-${version}",
    subscribe   => Exec['make_xsp'],
    environment => ["PKG_CONFIG_PATH=/usr/lib/pkgconfig"],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
  }
}
