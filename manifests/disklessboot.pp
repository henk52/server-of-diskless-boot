
# yum groupinstall Base --installroot=/exported/root/directory

$szServiceIpAddress = hiera( 'ServiceIpAddress', '172.16.1.3' )

$szDisklessImagesBasePath = '/exported/disklessimages'
$szFedoraReleaseVersion = '20'

$szOsName = 'fedora20_x86_64'

$szInitRamFS = 'initramfs-3.16.7-200.fc20.x86_64.img'
$szVmLinuz   = 'vmlinuz-3.16.7-200.fc20.x86_64'

package { 'dracut-network': ensure => present, }

file { '/exported': ensure => directory }
file { "$szDisklessImagesBasePath": ensure => directory, require => File [ '/exported' ] }
file { "$szDisklessImagesBasePath/$szOsName": ensure => directory, require => File [ "$szDisklessImagesBasePath" ], }


# add the following two lines to /etc/yum.conf
# Setting to install every package from a group
# group_package_types=default, mandatory, optional
# time yum groupinstall "Minimal Install" --installroot=/exported/disklessimages/fedora20_x86_64  --releasever=20
#real	4m40.583s
#rm /exported/disklessimages/fedora20_x86_64/etc/yum.repos.d/*.repo
# cp /etc/yum.repos.d/local.repo /exported/disklessimages/fedora20_x86_64/etc/yum.repos.d
# time yum install --installroot=/exported/disklessimages/fedora20_x86_64  --releasever=20  yum kernel grub mdadm net-tools pciutils usbutils facter

# net-tools - ifconfig
# pciutils - lspci


# strace -f -o /tmp/t usermod --root /exported/disklessimages/fedora20_x86_64 --password \$1\$pee3MHkJ\$0Ggz48t1xbPq/UnZ5SqxX1 root


$szDefaultNfsOptionList =  'rw,no_root_squash,async,insecure,no_subtree_check'
# from: http://xmodulo.com/diskless-boot-linux-machine.html

$szDefaultNfsClientList = hiera ( 'DefaultNfsClientList', '172.16.1.0/255.255.255.0' )

$hNfsExports = {
 "$szDisklessImagesBasePath/$szOsName" => {
             'NfsOptionList' => "$szDefaultNfsOptionList",
             'NfsClientList' => "$szDefaultNfsClientList",
                                        },
}
 
class { 'nfsserver':
   hohNfsExports => $hNfsExports,
}

$szTftpBasePath = '/var/tftp'

file { "$szTftpBasePath/$szOsName":
  ensure => directory,
  owner  => nobody,
}

# dracut -f  -m "nfs network base" /var/tftp/fedora20_x86_64/initrd.img
# dracut -f  --add network /var/tftp/fedora20_x86_64/initrd.img 
#  chown nobody /var/tftp/fedora20_x86_64/initrd.img
# dracut -f --debug  root=dhcp  /var/tftp/fedora20_x86_64/initrd.img
# scp cadm@10.1.233.3:/home/ks/repo/linux/releases/20/Fedora/x86_64/os/images/pxeboot/initrd.img /var/tftp/fedora20_x86_64/
file { "$szTftpBasePath/$szOsName/initrd.img":
  ensure => present,
  source => "$szDisklessImagesBasePath/$szOsName/boot/$szInitRamFS",
  owner  => nobody,
  require => File [ "$szTftpBasePath/$szOsName", "$szDisklessImagesBasePath/$szOsName" ],
}

file { "$szTftpBasePath/$szOsName/vmlinuz":
  ensure => present,
  source => "$szDisklessImagesBasePath/$szOsName/boot/$szVmLinuz",
  owner  => nobody,
  require => File [ "$szTftpBasePath/$szOsName", "$szDisklessImagesBasePath/$szOsName" ],
}

file { "$szTftpBasePath/pxelinux.cfg/default":
  ensure  => file,
  backup  => false,
  content => template('server-of-diskless-boot/default.erb'),
}

file { "$szDisklessImagesBasePath/$szOsName/etc/fstab":
  ensure  => file,
  backup  => false,
  content => template('server-of-diskless-boot/etc_fstab.erb'),
}
