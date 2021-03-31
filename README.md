# vagrant-mutagen-project

This plugin updates the current users SSH config to register the Vagrant 
machine, and then starts the Mutagen project.

This version was forked from https://github.com/dasginganinja/vagrant-mutagen
with the intention of resolving bugs in SSH setup and Windows support
for Deskpro use. The majority of the business logic around SSH config and 
Mutagen project handling has been rewritten. 

The plugin has not been published to rubygems.org and is only available 
for manual download from Github releases.

## Installation

Remove any previous installation of vagrant-mutagen plugin first,
then download the latest gem file from the Github releases page
and install using the gem filename:

    $ vagrant plugin uninstall vagrant-mutagen
    $ vagrant plugin install /path/to/gem 

Windows support will require the Windows fork of the OpenSSH client to be installed: 
(https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview)

Uninstall it with:

    $ vagrant plugin uninstall vagrant-mutagen-project

## Usage

You need to set `orchestrate` and `config.vm.hostname`.

    config.mutagen.orchestrate = true

This hostname will be used for the entry in the `~/.ssh/config` file.

Orchestration also requires a `mutagen.yml` file configured for your project.

The mutagen project file name can be overridden with:

    config.mutagen.project_file = "mutagen-other.yml"

### Example Project Orchestration Config (`mutagen.yml`)

As an example starting point you can use the following for a Drupal project:
```
sync:
  vagrant-mutagen-project-node1:
    alpha: '.'
    beta: 'vagrant-mutagen-project-node1:/home/vagrant/vagrant-mutagen-project'
    mode: 'two-way-resolved'
    flushOnCreate: true
    ignore:
      vcs: true
    configurationBeta:
      permissions:
        defaultOwner: vagrant
        defaultGroup: vagrant
        defaultFileMode: 644
        defaultDirectoryMode: 755
```

## Installing development version

If you would like to install the development version of vagrant-mutagen-project, 
run the commands:

```
git clone https://github.com/deskpro/vagrant-mutagen-project
cd vagrant-mutagen-project
bundle install
rake build
vagrant plugin install pkg/vagrant-mutagen-project-*.gem
```

## Useful development commands

To run the plugin with Vagrant in development, run the command: 

```
bundle exec vagrant ...
```

This does not require a gem be built before execution.
