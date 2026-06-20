Situation: The adlab libvirt network was created with DHCP enabled by default, and DC01 was running with a DHCP-assigned IP instead of its required static address.

Task: Convert adlab to a DHCP-free network and assign DC01 a static IP, so DC01 is the sole addressing/DNS authority on the lab network.

Action: Removed the <dhcp> block from the network XML, redefined the network with virsh net-define (preserving UUID/MAC to update rather than conflict), cycled the network, then set DC01's IP statically inside the VM via PowerShell.

Result: adlab confirmed DHCP-free via net-dumpxml; DC01 confirmed at 10.10.20.10 via ipconfig /all. Network and DC01 both set to autostart.
