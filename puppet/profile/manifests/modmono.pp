# == Class: profile/mod_mono
class profile::modmono {

  $version = '3.12'

  exec{'retrieve_mod_mono_pkg':
    command => "wget http://origin-download.mono-project.com/sources/mod_mono/mod_mono-${version}.tar.gz",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Class['profile::xsp'],
    unless  => "ls /usr/src/mod_mono-${version}.tar.gz",
  }

  exec{ 'extract_mod_mono_pkg':
    command     => "tar -xvzf mod_mono-${version}.tar.gz",
    cwd         => '/usr/src',
    subscribe   => Exec['retrieve_mod_mono_pkg'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    refreshonly => true,
    user        => 'root',
  }

  exec{'configure_mod_mono':
    command     => "/usr/src/mod_mono-${version}/./configure --prefix=/usr",
    cwd         => "/usr/src/mod_mono-${version}",
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['extract_mod_mono_pkg'],
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
    environment => ["LD_LIBRARY_PATH=/usr/lib"],
  }

  exec{'make_mod_mono':
    command     => "su -c 'make'",
    cwd         => "/usr/src/mod_mono-${version}",
    subscribe   => Exec['configure_mod_mono'],
    user        => 'root',
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    refreshonly => true,
    environment => ["LD_LIBRARY_PATH=/usr/lib"],
  }

  exec{'install_mod_mono':
    command     => "su -c 'make install'",
    cwd         => "/usr/src/mod_mono-${version}",
    subscribe   => Exec['make_mod_mono'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    user        => 'root',
    timeout     => 0,
    refreshonly => true,
    environment => ["LD_LIBRARY_PATH=/usr/lib"],
  }

  exec{'creates_links_and_cache':
    command     => 'ldconfig',
    subscribe   => Exec['install_mod_mono'],
    refreshonly => true,
    user        => 'root',
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
  }
}
