#== Class: profile::gdiplus

class profile::gdiplus {

  $version = '2.10'

  exec{'retrieve_gdiplus_pkg':
    command => "wget http://origin-download.mono-project.com/sources/libgdiplus/libgdiplus-${version}.tar.bz2",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
  }

  exec{ 'extract_gdiplus_pkg':
    command     => "tar -xvjf libgdiplus-${version}.tar.bz2",
    cwd         => '/usr/src',
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['retrieve_gdiplus_pkg'],
    refreshonly => true,
  }

  exec{'configure_gdiplus':
    command   => "/usr/src/libgdiplus-${version}/./configure --prefix=/usr",
    cwd       => "/usr/src/libgdiplus-${version}",
    path      => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe => Exec['extract_gdiplus_pkg'],
    notify    => Exec['mono_version'],
    refreshonly => true,
    timeout => 0,
  }

  exec{'make_gdiplus':
    command => "make",
    cwd     => "/usr/src/libgdiplus-${version}",
    require => Exec['configure_gdiplus'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }

  exec{'install_gdiplus':
    command => "make install",
    cwd     => "/usr/src/libgdiplus-${version}",
    require => Exec['make_gdiplus'],
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }
}
