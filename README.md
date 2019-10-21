# vagrant-mutagen-project

This plugin adds an entry to your `~/.ssh/config` file on the host system.

On **up**, **resume** and **reload** commands, it tries to add the information, if it does not already exist in your config file. 
On **halt**, **destroy**, and **suspend**, those entries will be removed again.


## Installation

    $ vagrant plugin install vagrant-mutagen-project

Uninstall it with:

    $ vagrant plugin uninstall vagrant-mutagen-project

Update the plugin with:

    $ vagrant plugin update vagrant-mutagen-project

## Usage

You need to set `orchestrate` and `config.vm.hostname`.

    config.mutagen.orchestrate = true

This hostname will be used for the entry in the `~/.ssh/config` file.

Orchestration also requires a `mutagen.yml` file configured for your project.

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
git clone https://github.com/spaulg/vagrant-mutagen-project
cd vagrant-mutagen-project
bundler install
bundler package
vagrant plugin install vagrant-mutagen-project-*.gem
```
