class profile::http{

  firewall { '101 allow xsp':
    action => accept,
    port   => [
    '80',
    ],
    proto  => tcp,
  }

  class { 'apache':
    require => Class['profile::modmono'],
    default_vhost => false,
  }

  apache::vhost { 'mono':
    servername => 'localhost',
    port    => '80',
    docroot => '/usr/src/xsp-2.10/test',
    additional_includes => '/etc/httpd/conf/mod_mono.conf',
    serveradmin => 'web-admin@vagrant-mono.local',
    custom_fragment => '
    MonoServerPath vagrant-mono.local "/usr/bin/mod-mono-server2"
    MonoSetEnv vagrant-mono.local MONO_IOMAP=all
    MonoApplications vagrant-mono.local "/:/usr/src/xsp-2.10/test"
    <Location "/">
    Allow from all
    Order allow,deny
    MonoSetServerAlias vagrant-mono.local
    SetHandler mono
    SetOutputFilter DEFLATE
    SetEnvIfNoCase Request_URI "\.(?:gif|jpe?g|png)$" no-gzip dont-vary
    </Location>
    <IfModule mod_deflate.c>
      AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript
    </IfModule>',
  }
}
