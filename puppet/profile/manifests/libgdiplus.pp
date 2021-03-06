#== Class: profile::gdiplus

class profile::libgdiplus(
  $libgdiplus_version = '',
  $libgdipuls_extension =''
)inherits profile {

  exec{'retrieve_gdiplus_pkg':
    command => "wget http://origin-download.mono-project.com/sources/libgdiplus/${libgdiplus_version}.${libgdipuls_extension}",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Class['profile::mono'],
    unless  => "ls /usr/src/${libgdiplus_version}.${libgdipuls_extension}",
  }

  exec{ 'extract_gdiplus_pkg':
    command     => "tar -xvzf ${libgdiplus_version}.${libgdipuls_extension}",
    cwd         => '/usr/src',
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['retrieve_gdiplus_pkg'],
    refreshonly => true,
  }

  exec{'configure_gdiplus':
    command     => "/usr/src/${libgdiplus_version}/./configure --prefix=/usr",
    cwd         => "/usr/src/${libgdiplus_version}",
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['extract_gdiplus_pkg'],
    refreshonly => true,
    timeout     => 0,
  }

  exec{'make_gdiplus':
    command     => "make",
    cwd         => "/usr/src/${libgdiplus_version}",
    subscribe   => Exec['configure_gdiplus'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    environment => ["PKG_CONFIG_PATH=/usr/lib/pkgconfig"],
    refreshonly => true
  }

  exec{'install_gdiplus':
    command     => "make install",
    cwd         => "/usr/src/${libgdiplus_version}",
    subscribe   => Exec['make_gdiplus'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    environment => ["PKG_CONFIG_PATH=/usr/lib/pkgconfig"],
    refreshonly => true
  }
}
