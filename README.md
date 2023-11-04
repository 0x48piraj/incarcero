# Incarcero: The swiss army knife for malware analysis

Malware analysis is like defusing bombs. The objective is to disassemble and understand a program that was built to do harm, which, is often obfuscated (ie: packed) to make the analysis more complicated.

Incarcero is a tool that creates Virtual Machines (VMs) preconfigured with malware analysis tools and security settings tailored for malware analysis without any user interaction.

Additionally, this repository also includes probably the **largest malware source code collection** as well as a module allowing one to download malware samples sourcing from popular online databases.


**Note:** Binaries with a generic names such as MD5 value or smbXXX.tmp were not detected as malware by [VirusTotal](https://www.virustotal.com/gui/home/upload) at the moment of the upload, but this doesn't mean it's not a malware sample. Please feel free to setup, analyze and perform reverse engineering any and all of the samples in this repository, if you actually do, let me know the results of your investigation.


## Requirements

* Python 3.3+
* [Packer](https://www.packer.io/docs/install/index.html)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or an vSphere / ESXi server


#### Minimum specs for the build machine

* At least 5 GB of RAM
* VT-X extensions strongly recommended

### Fedora

    dnf install ruby-devel gcc-c++ zlib-devel
    vagrant plugin install winrm winrm-fs

### Debian

    apt install vagrant git python3-pip
    
### Ubuntu

    apt install git python3-pip

### ArchLinux

    pacman -Sy vagrant packer python-pip git


## Installation

### Linux/Unix

* Install git and packer using your distribution's packaging tool
  (packer is sometimes called packer-io)
* Install vagrant from their website : https://www.vagrantup.com/downloads.html (Installing from some distributions' packaging tools have caused issues). 
* Install incarcero:

```
sudo pip3 install git+https://github.com/0x48piraj/incarcero.git#egg=incarcero
```

### Windows

NOTE: Starting with Windows 10 Hyper-V is always running below the operating
system. Since VT-X needs to be operated exclusively by only one Hypervisor, causes VirtualBox (and
incarcero) to fail. To disable Hyper-V and allow
VirtualBox to run, issue the following command in an administrative command
prompt then reboot: `bcdedit /set hypervisorlaunchtype off`. Since version 6 of Virtualbox
it supports using Hyper-V as the fallback execution core ([changelog](https://www.virtualbox.org/wiki/Changelog-6.0))

#### Using Chocolatey

The following steps assume that you have https://chocolatey.org/[Chocolatey]
installed. Otherwise, follow the [manual installation procedure](#manually).

Install dependencies:

    choco install python vagrant packer git virtualbox

Refresh the console:

    refreshenv

Install incarcero:

    pip3 install setuptools
    pip3 install -U git+https://github.com/0x48piraj/incarcero.git#egg=incarcero

#### Manually

* Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads),
  [Vagrant](https://www.vagrantup.com/downloads.html) and
  [git](https://git-scm.com/downloads)
* [Install Packer](https://www.packer.io/downloads.html), drop the packer binary
  in a folder in your user's PATH like `C:\Windows\System32\`
* [Install Python 3](https://www.python.org/downloads/) (make sure to add
  Python to your environment variables)
* Open a console (Windows-Key + cmd)

```
pip3 install setuptools
pip3 install -U git+https://github.com/0x48piraj/incarcero.git#egg=incarcero
```

### To deploy on AWS (optional)
Run this command after normal installation:
    
    vagrant plugin install vagrant-aws

NOTE: The AWS feature has only been tested on Linux for the moment and EC2 does not support 32-bit desktop version of Windows 10.

## Usage

### Box creation

This creates your base box that is imported in Vagrant. Afterwards you can
re-use the same box several times per sample analysis.

Run:

    incarcero build <template>

You can also list all supported templates with:

    incarcero list

This will build a Vagrant box ready for malware investigation you can now
include it in a Vagrantfile afterwards.

For example:

    incarcero build win10_x64_analyst

[The configuration section](#configuration) contains further information about
what can be configured with incarcero.


### Per analysis instances

    incarcero spin win10_x64_analyst <name>

This will create a `Vagrantfile` prepared to use for malware analysis. Move it
into a directory of your choice and issue:

    vagrant up

By default the local directory will be shared in the VM on the Desktop. This
can be changed by commenting the relevant part of the `Vagrantfile`.

For example:

    incarcero spin win7_x86_analyst 20160519.cryptolocker.xyz

### To deploy on AWS (optional)

incarcero can upload and interact with a VM on the Amazon Web serivces. To do so, follow these steps:

. incarcero will need a S3 bucket on AWS to upload the VM before converting it to an AMI (Amazon Machine Image). If you don't have one, 
[create one now](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html).

. Your instance also requires a [security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html#CreatingSecurityGroups) with at least a rule allowing inbound connections for WinRM (Type: WinRM-HTTP, Protocol: TCP, Port Range: 5985, Source: host's public IP).

. Next, you need a `vmimport` service role configured.
  Follow the section named _VM Import Service Role_ of [this guide](https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html).
  These steps must be performed with an account that has `iam:CreateRole` and `iam:PutRolePolicy` permissions.

. If the [default config](#configuration) is used, change the hypervisor to aws and fill the mandatory options related. Otherwise, be sure to add all the options about AWS to your custom config.

. Finally, you can follow the same steps described in the [Box creation](#box-creation) and the [Per analysis instances](#per-analysis-instances) sections to launch your instance!

NOTE: The AMI import can take a very long time (about an hour), however you can verify the status of the task by doing [this](#ami-import-status). At the moment, only one AMI can be build per template.

#### AMI import status
Install awscli using pip:

    pip install awscli

[Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) awscli with:

    aws configure

Then run:

    aws ec2 describe-import-image-tasks 

#### RDP

To connect to an instance on the cloud using RDP, run this command at the same location of your `Vagrantfile`: 

    vagrant rdp -- /cert-ignore

For this to work, the instance will require a security group allowing RDP inbound connections (Type: RDP, Protocol: TCP, Port Range: 3389, Source: host's public IP).

NOTE: You can safely ignore the following error because rsync is not yet implemented: `No host IP was given to the Vagrant core NFS helper. This is an internal error that should be reported as a bug.` 


#### Stopping an Instance

To stop an instance on the cloud, run this command at the same location of your `Vagrantfile`:

    vagrant halt

## Configuration

incarcero' configuration is located in a directory that follows usual operating
system conventions:

* Linux/Unix: `~/.config/incarcero/`
* Mac OS X: `~/Library/Application Support/incarcero/`
* Win 7+: `C:\Users\<username>\AppData\Local\incarcero\incarcero\`

The file is named `config.js` and is copied from an example file on first run.
[The example configuration](incarcero/config-example.js) is documented.

### ESXi / vSphere support

incarcero uses virtualbox as a back-end by default but since version 0.3.0
support for ESXi / vSphere has been added. Notes about the
[steps required for ESXi / vSphere support are
available](docs/esx-setup.adoc). Since everyone's setup is a little bit different do not hesitate
to open an issue if you encounter a problem or improve our documentation via a
pull request.

### Profiles

We are exploring with the concept of _profiles_ which are stored separately
than the configuration and can be used to create files, alter the registry or
install additional packages. See
[profile-example.js](incarcero/profile-example.js) for an example
configuration. This new capacity is experimental and subject to change as we
experiment with it.

### AWS security groups

Currently, incarcero does not support the automatic creation of the security groups, so you'll have to use the AWS console to create yours. However, using the library [Boto3](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html) there should be a way to implement this.


# Disclaimer

This repository is for **research** purposes only, the use of this code is **your responsibility**.

I take NO responsibility and/or liability for how you choose to use any of the source code available here. By using any of the files available in this repository, you understand that you are AGREEING TO USE AT YOUR OWN RISK. Once again, ALL files available here are for EDUCATION and/or RESEARCH purposes ONLY.

I'm not the author of any of the code available here. This repository contains malware source code samples leaked online (and found in multiple other sources), I uploaded it to GitHub to simplify the process of those who want to analyze the code.

Any actions and/or activities related to the material contained within this repository is solely your responsability. Misuse of the information in this repository can result in criminal charges being brought against the persons in question. I will not be held responsible in the event any criminal charges are brought against any individuals misuing the code in this repository to break the law.

This repository does not promote any hacking related activity. All the information in this repository is for educational purposes only.

# Credits

This project was rejuvenated with the help of [malboxes](https://github.com/GoSecure/malboxes).
