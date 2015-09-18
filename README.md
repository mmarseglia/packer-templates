# packer-templates

Packer template for building Vagrant base boxes.  Written to be customized at
the os and application layers.  Customization is achieved by creating a variable
file and corresponding scripts.

## Method

Application customization is layered on top of a standard OS template. The
application layer consists of specific application customizations.

Scripts are applied in order:

* pre OS script.
* common base script, applies to all boxes.
* common vagrant script, applies to all boxes.
* common virtualbox or OS specific vmware script.
* OS, application script. application specific commands.
* common clean up script.
* post OS script.

The order as defined in the template:

```
"scripts/{{user `os`}}/pre.sh",
"scripts/common/base.sh",
"scripts/common/vagrant.sh",
"scripts/{{user `os`}}/vmware.sh",
"scripts/{{user `os`}}/{{user `application`}}.sh",
"scripts/common/cleanup.sh",
"scripts/{{user `os`}}/post.sh"
```

Example CentOS 6.6 x64 base image scripts applied in order:

```
packer-templates/scripts
├── centos-6-6
│   ├──pre.sh
├── common
│   ├── base.sh
│   ├── vagrant.sh
│   ├── virtualbox.sh
├── centos-6-6
│   ├── base.sh
├── common
│   ├── cleanup.sh
├── centos-6-6
│   ├── post.sh
```

User variables are defined in a variables file:

* os
	* centos-6-6
* iso_checksum
	* checksum of the ISO used to install the OS
* iso_url
	* URL to download the install ISO from  
* boot_command
	* kernel parameters and boot command, minus the URL to the Kickstart script
	* this is to account for differences between RedHat 6 and 7 boot options
* guest_os_type
	* Passed to the hypervisor helps it determine what OS type is installed

Example Cent OS 6.6, x64, base image.

```
"os": "centos-6-6",
"iso_checksum": "4ed6c56d365bd3ab12cd88b8a480f4a62e7c66d2",
"iso_url": "http://your.host.here/CentOS-6.6-x86_64-minimal.iso",
"boot_command" : "<tab> text ks=",
"guest_os_type": "centos-64"
```

## Usage

### Install Packer

Download the latest packer
[http://www.packer.io/downloads.html](http://www.packer.io/downloads.html) and
unzip the appropriate directory.  Full install instructions
[https://packer.io/docs/installation.html](https://packer.io/docs/installation.html).

#### OS X, Homebrew

```
brew install packer
```

#### Windows, Chocolatey
```
choco install packer
```

### Install the packer vmware-ovf plugin

You must download and install the packer vmware-ovf plugin
[https://github.com/gosddc/packer-post-processor-vagrant-vmware-ovf]() to create
VMware virtual machines with this template.


### Run Packer

You must specify the option **-var-file** and associated variable file for the
image you want to build.

```
git clone this repository
cd packer-templates
```

Run packer specifying the variable file for the image you want to create.  To
create a CentOS 6.6 image specify the centos-6-6.json variable file.

```
packer build -only vmware-iso -var-file centos-6-6.json template.json
```

You can also override variables on the command line if you want to use a
different download location for the ISO.

```
packer build -only vmware-iso -var-file centos-6-6.json -var 'iso_url=http://your.download.location' template.json
```

## Output
Packer will place the resulting builds in the vagrant or vmware-ovf directories.
Images made using the vmware-iso builder will produce a Vagrant image and a
VMware OVF image.  The VMware OVF image is suitable for import into any platform
that supports OVF including, but not limited to, vCenter and vCloud Air.

## Supported versions

This template tested using packer 0.8.1.

## Author

mike@marseglia.org
