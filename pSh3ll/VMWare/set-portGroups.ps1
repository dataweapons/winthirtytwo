vSwitch = "vSwitch0"
$portgrpname = "Zone01"
$AllConnectedHosts = Get-VMHost | Where {$_.ConnectionState -eq "Connected"}
 
foreach ($esxihost in $AllConnectedHosts) {
    $currentvSwitch = $esxihost | Get-VirtualSwitch | Where {$_.Name -eq $vSwitch}
    New-VirtualPortGroup -Name $portgrpname -VirtualSwitch $currentvSwitch -Confirm:$false
    $currentesxihost = Get-VMHost $esxihost | Get-View
    $netsys = Get-View $currentesxihost.configmanager.networksystem
    $portgroupspec = New-Object VMWare.Vim.HostPortGroupSpec
    $portgroupspec.vswitchname = $vSwitch
    $portgroupspec.Name = $portgrpname
    $portgroupspec.policy = New-object vmware.vim.HostNetworkPolicy
    $portgroupspec.policy.Security = New-object vmware.vim.HostNetworkSecurityPolicy
    $portgroupspec.policy.Security.AllowPromiscuous = $true
    $netsys.UpdatePortGroup($portgrpname,$PortGroupSpec)
     
}
