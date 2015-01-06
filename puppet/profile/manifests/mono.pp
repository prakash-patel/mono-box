#== Class: profile/mono

class profile::mono {

  $version = '3.12.0'

  exec { 'prerequisite_packages':
    command => 'yum -y install gcc gcc-c++ bison pkgconfig httpd glib2-devel gettext make freetype-devel fontconfig-devel libXft-devel libpng-devel libjpeg-devel libtiff-devel giflib-devel ghostscript-devel libexif-devel httpd-devel cairo-devel',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout => 0,
  }

  exec{'retrieve_mono_pkg':
    command => "wget http://download.mono-project.com/sources/mono/mono-${version}.tar.bz2",
    cwd     => '/usr/src',
    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
    require => Exec['prerequisite_packages'],
    unless  => "ls /usr/src/mono-${version}.tar.bz2",
  }

  exec{ 'extract_mono_pkg':
    command     => "tar -xvjf mono-${version}.tar.bz2",
    cwd         => '/usr/src',
    subscribe   => Exec['retrieve_mono_pkg'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    refreshonly => true,
    user        => 'root',
  }

  exec{'configure_mono':
    command     => "/usr/src/mono-${version}/./configure --prefix=/usr",
    cwd         => "/usr/src/mono-${version}",
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    subscribe   => Exec['extract_mono_pkg'],
    timeout     => 0,
    refreshonly => true,
    user        => 'root',
  }

  exec{'make_mono':
    command     => "make",
    cwd         => "/usr/src/mono-${version}",
    subscribe   => Exec['configure_mono'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    refreshonly => true,
    user        => 'root',
  }

  exec{'install_mono':
    command     => "make install",
    cwd         => "/usr/src/mono-${version}",
    subscribe   => Exec['make_mono'],
    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
    timeout     => 0,
    notify      => Exec['mono_version'],
    refreshonly => true,
    user        => 'root',
  }

  file { '/etc/profile.d/mono.sh':
    content     => template('profile/profile_d_mono.sh.erb'),
    group       => 'root',
    mode        => '0777',
    owner       => 'root',
    replace     => true,
    subscribe   => Exec['install_mono'],
  }

  exec{ "mono_version" :
    command   => 'mono --version',
    path      => "/usr/sbin:/usr/bin:/sbin:/bin",
    logoutput => true,
  }
}
