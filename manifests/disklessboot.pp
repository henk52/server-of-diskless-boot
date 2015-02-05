
# yum groupinstall Base --installroot=/exported/root/directory

$szDisklessImagesBasePath = '/exported/disklessimages'
$szFedoraReleaseVersion = '20'

file { '/exported': ensure => directory }
file { "$szDisklessImagesBasePath": ensure => directory, require => File [ '/exported' ] }
file { "$szDisklessImagesBasePath/fedora20_x86_64": ensure => directory, require => File [ "$szDisklessImagesBasePath" ], }

# add the following two lines to /etc/yum.conf
# Setting to install every package from a group
# group_package_types=default, mandatory, optional
# time yum groupinstall "Minimal Install" --installroot=/exported/disklessimages/fedora20_x86_64  --releasever=20
#real	4m40.583s
#rm /exported/disklessimages/fedora20_x86_64/etc/yum.repos.d/*.repo
# cp /etc/yum.repos.d/local.repo /exported/disklessimages/fedora20_x86_64/etc/yum.repos.d
# time yum install --installroot=/exported/disklessimages/fedora20_x86_64  --releasever=20  yum kernel grub mdadm 


$szDefaultNfsOptionList =  'ro,no_root_squash'
$szDefaultNfsClientList = hiera ( 'DefaultNfsClientList', '172.16.1.0/255.255.255.0' )

$hNfsExports = {
 "$szDisklessImagesBasePath/fedora20_x86_64" => {
             'NfsOptionList' => "$szDefaultNfsOptionList",
             'NfsClientList' => "$szDefaultNfsClientList",
                                        },
}
 
class { 'nfsserver':
   hohNfsExports => $hNfsExports,
}

