#region ---Preface to creating a vitual switch
<#
    Objective: Test communication between two Virtual Machines using a 
    Virtual Switch of the Internal type.
#>
#endregion

#region ---Create the Virtual Switch 
<#
    From an elevated instance of Powershell ISE on the Physical Host...
    
    Create a variable for the new Virtual Switch's name of your chosing
#>
$VMSwitchName = "VMinternal"

#Create a variable for the switch's type in our example "Intenal"

$VMSwitchType = "Internal"

#Add some switch notes of your chosing though not required

$VMSwitchNotes = "This Switch type allows VMs and their Physical Host to communicate with each other"



#First check for existing virtual switches to prevent name duplication

Get-VMSwitch * | Format-Table -Wrap -AutoSize


#Check for Net Adapters that already exist on the Physical Host

Get-NetAdapter * | Format-Table -Wrap -AutoSize

#Execute the code for a new Switch  
New-VMSwitch -name $VMSwitchName   -SwitchType $VMSwitchType -Notes $VMSwitchNotes

#re-check both the Adapters on the Physical Host...
Get-NetAdapter * | Format-Table -Wrap -AutoSize

# ...and the virtual switches now available to Hyper-V
 

<#
    Notice how the switch name "VMinternal" occurs in the list of Net Adapters on the Physical Host AND it is prefaced 
    by vEthernet as an object available to Hyper-V machines.
    It can also by viewed and manipulated in the Windows GUI environment like any other Net Adapter
    Here is a handy short-cut from the CLI
#>

ncpa.cpl

<#
    While in the GUI you can check its IPv4 Properties and note that it recieves its IP address dynamically 
    instead of having a static address already set.

    In the next section, we will change it to a static address from the CLI
#>

#endregion

#region ---Setting IP Addresses...

#...We can cough up a weedy list of Net IP Addresses with a terse 
Get-NetIPAddress

<#
    ...or something more focused on the active Net IP Addresses available on 
    our Physical Host with a general GET request that presents only Version 4 IP addresses.
    In other words, we don't need to look at every Property of every NetIPAddress
#> 

Get-NetIPAddress | Select-Object -Property AddressFamily, IPAddress, InterfaceAlias, InterfaceIndex | where {($_.AddressFamily -eq 'ipv4') }

<#
    In this output we can easily see the InterfaceAlias of our 
    VMinternal (prefaced with vEthernet). 
    Its IPv4 network address is 169.245.x.x This particular network is just a place holder meaning no network has been assigned. 
    It may be less tedious to refer to this net adapter by its InterfaceIndex of a 
    2 digit number (in this particular case, 40 ) than a lengthy though friendlier string 
    of "vEthernet (VMinternal)"

    Here is a sample piping filter just to focus on our target adapter with an InterfaceIndex query
#> 
$myIfIndex = 12
Get-NetIPAddress | Where-Object {$_.InterfaceIndex -eq $myIfIndex }

# or we could polish the polish

$myIfAlias = "vEthernet (" + $VMSwitchName + ")"
$formatAdapterList = Get-NetIPAddress `
                        | Select-Object -Property AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex `
                        | where {($_.AddressFamily -eq 'ipv4') -and ($_.InterfaceAlias -eq $myIfAlias )}
$formatAdapterList
$formatAdapterList.InterfaceAlias

$myIfAlias -eq $formatAdapterList.InterfaceAlias

#endregion 

#region Our exercise is limited to an Internal Network Switch,
<#     
     so we will ignore the Default Gateway and DNS addresses for now.

     We will set 3 variables

     $myifIndex -to Identify which adapter is being changed

     $myIP4 -a unique v4 IP address of our choosing whose first three octets will establish 
            our network name, let's use 192.168.5 and a final octet of 1 to indentify 
            this adapter (which is masquerading as a vitual switch)
             
     $myCIDR - our subNet mask of 255.255.255.0 will be set using 
            CIDR notation, or 24 (3x8 get it?)
#> 
$formatAdapterList
$myifIndex = 12
$myIP4 = "192.168.6.1"
$myCIDR = 24

New-NetIPAddress –InterfaceIndex $myifIndex -IPAddress $myIP4  –PrefixLength $myCIDR 

#OR...
#A caution on using Interfaceindex is that it must be checked each time an Adapter object is created because the computer auto-increments if
#If for example you remove this Switch an recreate it, to would get 41 instead of 40.
#To absolutely and automatically be concise you should devise a snippet to skip it, 
#by querying with the Property: AddressFamily and properly constructing a $myIfAlias variable

New-NetIPAddress –InterfaceAlias $myIfAlias -IPAddress $myIP4  –PrefixLength $myCIDR 

#reload our formatted Adapter list
$formatAdapterList = Get-NetIPAddress `
                        | Select-Object -Property AddressFamily, IPAddress, InterfaceAlias, PrefixLength, InterfaceIndex `
                        | where {($_.AddressFamily -eq 'ipv4') -and ($_.InterfaceAlias -eq $myIfAlias )}

#and display it
$formatAdapterList

#to start afresh execute
Remove-VMSwitch -name $VMSwitchName 

#endregion 

#region ---Firewall OFF
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
#endregion

#region ---This test is successfull if...
<#
 the active ping command stops generating "Request timed out"
and begins to issue "Reply from 192.168...." responses
Press Ctl-C to exit

Re-enable Windows Defender Firewall
#>
#endregion

#region ---Firewall ON...please

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

#...The End
#endregion