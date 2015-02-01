# == Class: server-of-diskless-boot
#
# Full description of class manager here.
#
# === Parameters
#
# Document parameters here.
#
# [*szNetworkInterfaceName*]
#   If set, then the IP address will be fixed to it, 
#    if not set, then grab the second interface name from the facter.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { server-of-diskless-boot:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class server-of-diskless-boot (
  $szNetworkInterfaceName = hiera( 'NetworkInterfaceName', '' ),
  $szServiceIpAddress = hiera( 'ServiceIpAddress', '172.16.1.3' ),
){

  #if $szNetworkInterfaceName not set then set it
  if ( $szNetworkInterfaceName == '' ) {
  #  # Facter: interfaces (Array of interfaces), grab the secodn entry.
    notify{ "Network interface name not set.": }
    $arInterfaceList = split($interfaces, ',')
    $szNicName = $arInterfaceList[1]
  } else {
    $szNicName = $szNetworkInterfaceName
  }

  notify{ "NIC: $szNicName ( $szServiceIpAddress )": }

  network::if::static { "$szNicName":
    ensure    => 'up',
    ipaddress => "$szServiceIpAddress",
    netmask   => '255.255.255.0',
  }
}
