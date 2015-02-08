# server-of-diskless-boot
Server to host diskless booting

See: http://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/nfs-diskless-systems.html

What it will do:
* Configure the Interface for fixed IP
* dnsmasq - DHCP, tftp
* nfs server
* Generate Boot environement 
** e.g: yum groupinstall Base --installroot=/exported/root/directory

cd /etc/puppet/modules
wget http://10.1.2.3:/storage/puppet/razorsedge-network-3.2.0.tar.gz
tar -zxf razorsedge-network-3.2.0.tar.gz
mv razorsedge-network-3.2.0 network



TODO
- Create the pxe 'default' file from a template.
- Generate the tftboot files in s fedora20_x86_64 subdir.
- test the boot
- Go from there.
