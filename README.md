# Vagrant Mono Box

Run [Mono][] in virtual box using [Vagrant][].

## Getting Started

### Dependencies

You have to install below software in order to run this code.

1. Install [Vagrant][] (1.7.2)
1. Install [VirtualBox][] (4.3.26)

## version

1. mono (3.12.0)
1. libgdiplus (3.12)
1. mod mono (3.12)
1. xsp (2.10)

Unless if you want to change this version please go to [mono source][] to get different version. Apply that version and extension to `version.ymal` file. I recommend to use current version.

## How to start

### See it in action

Run below command at `mono-box/mono/` lavel
$ vagrant up (It will take around 25 minute to start virtual machine)

Once above command run successfully, go to your browser and write 'http://localhost:7080'. You able to see default website that provided by xsp.

#### Website

1. Publish asp.net mvc code locally
1. Move publish folder to the `mono` folder at the root level
1. Go to `global.yaml` file and change path to `/vagrant_data/{your_folder_name}`
1. Run `vagrant up`
1. Goto `localhost:7080` to see browse the site

### Who do I talk to?

* Repo owner or admin

[Vagrant]: https://www.vagrantup.com/downloads.html
[Mono]: http://www.mono-project.com/download/
[Puppet]: http://puppetlabs.com/
[Chocolatey]: https://chocolatey.org/
[VirtualBox]: https://www.virtualbox.org/wiki/Downloads
[mono source]: http://origin-download.mono-project.com/sources/
