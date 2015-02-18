# == Class: profile/http

class profile::http(
  $doc_root = '',
  $dot_net_framework = '',
  $mono_port = '',
) inherits profile{

  firewall { '101 allow xsp':
    action => accept,
    port   => [
    $mono_port,
    ],
    proto  => tcp,
  }

  class { 'apache':
    require => Class['profile::modmono'],
    default_vhost => false,
  }

  class { 'hosts':
    host_entries => {
      "vagrant-hbase.icadev.local" => {
        'host_aliases' => ["vagrant-hbase"],
        'ip'           => "192.168.56.120",
      },
    }
  }

  apache::vhost { 'mono':
    servername => 'localhost',
    port    => $mono_port,
    docroot => $doc_root,
    additional_includes => '/etc/httpd/conf/mod_mono.conf',
    serveradmin => 'web-admin@vagrant-mono.local',
    custom_fragment => "
    MonoDebug vagrant-mono.local true
    MonoServerPath vagrant-mono.local \"/usr/bin/mod-mono-server${dot_net_framework}\"
    MonoSetEnv vagrant-mono.local MONO_IOMAP=all
    MonoApplications vagrant-mono.local \"/:${doc_root}\"
    <Location \"/\">
      Allow from all
      Order allow,deny
      MonoSetServerAlias vagrant-mono.local
      SetHandler mono
      SetOutputFilter DEFLATE
      SetEnvIfNoCase Request_URI \"\\.(?:gif|jpe?g|png)$\" no-gzip dont-vary
    </Location>
    <IfModule mod_deflate.c>
      AddOutputFilterByType DEFLATE text/html text/plain text/xml text/javascript
    </IfModule>",
  }
}
