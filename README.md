# Vagrant Mono Box

Run [Mono][] in virtual box using [Vagrant][].

## Getting Started

### Dependencies

You have to install below software in order to run this code.

1. Install [Vagrant][]
1. Install [Puppet][]
1. Install [VirtualBox][]

## version

1. mono (3.12.0)
1. libgdiplus (3.12)
1. mod mono (3.12)
1. xsp (2.10)

Unless if you want to change this version please go to [mono soruce][] to get different version. Apply that version to each `.pp` file.

## How to start

### See it in action

Run below command at root lavel
$ vagrant up ( It will take around 25 minute, do not watch porn.. lol )

Once above command run successfully, go to your browser and write 'http://localhost:8080'. You able to see default website that provided by xsp.

#### Website ( TODO)
1. Publish c# code locally
1. Move publish folder to the `mono` folder at the root level
1. Run `vagrant up`
1. Goto `localhost:8080` to see browse the site

### Who do I talk to?

* Repo owner or admin

[Vagrant]: https://www.vagrantup.com/downloads.html
[Mono]: http://www.mono-project.com/download/
[Puppet]: http://puppetlabs.com/
[Chocolatey]: https://chocolatey.org/
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
[mono source]: http://origin-download.mono-project.com/sources/