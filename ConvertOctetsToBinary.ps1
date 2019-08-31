function OctetsToBInary($IPToConvert) {
   # Takes a decimal IP (4-octets) and converts it to a binary expression of string type
   # help from: https://blogs.msmvps.com/richardsiddaway/?s=Convert-ToBinary&search=Search

   # will need some range checking when converted to function

   $Octets = $null

   $Octets = $IPToConvert.split(".")
 
   $PrePadBinary = $PaddedBinary = $IPinBinary = $null

   foreach ($Oct in $Octets) { 
      $PrePadBinary = [convert]::ToString($Oct, 2)
      $PaddedBinary = $PrePadBinary.Padleft(8, '0')
      $IPinBinary += $PaddedBinary + '.'
   }
   return $IPinBinary.Substring(0, 35) #remove the spurious SPACE at the end. Needs to be re-written as lenght agnostic i.e. only works with 4 octets
}

function Convert-CIDRtoBIN([int]$C) {
   $NumberOf255Octets = $PartialOctet = $255Mask = $HostMask = $null
   $NumberOf255Octets = [Math]::Truncate($CIDRDec / 8)
   $PartialOctet = ($CIDRDec % 8)

   $255Mask = '11111111.' * $NumberOf255Octets
   $HostMask = '1' * $PartialOctet 
   $HostMask = $HostMask.PadRight(8, '0')
   <#
   $CIDRDec
   $NumberOf255Octets
   $PartialOctet
   $255Mask
   $HostMask 
#>
   return ($255Mask + $HostMask)
}
function Convert-ZeroOctets($X) {
   $8Zeros = '.00000000'
   if ($X.Length -eq 26) {
      $X = $X + $8Zeros
   } 
   if ($X.Length -eq 17) {
      $X = $X + $8Zeros * 2
   }
   if ($X.Length -eq 8) {
      $X = $X + $8Zeros * 3
   }
   return $X
}
############   end of funtions 
#######################################################

$IP = $null
$IP = Read-Host "Enter any 4-Octet decimal IP Address to convert to a binary string "
$X = OctetsToBInary($IP)
$X

#########################################################
$X = $BuildOctets = $null
[int]$CIDRDec = Read-Host "For a Binary Subnet mask, Input CIDR (0-32)"
$BuildOctets = Convert-CIDRtoBIN($CIDRDec)
$X = Convert-ZeroOctets($BuildOctets)
$X

##############################################################

# [math].GetMethods()
 
$CIDR = $NumberOf255Octets = $PartialOctet = $TOTAL = $CIDRIPDec = $null

$CIDR = Read-Host "For A 4 octet decimal subnet mask, Enter CIDR (0-32) "

$NumberOf255Octets = [Math]::Truncate($CIDR / 8) 

$PartialOctet = ($CIDR % 8)
if ($PartialOctet -eq 0) { $TOTAL = '0' }

for ($i = 7 ; $i -gt (7 - $PartialOctet) ; $i--) {
  
   $TOTAL += [math]::pow(2, $i) 
}
if ($NumberOf255Octets -eq 4) {

   $CIDRIPDec = '255.' * $NumberOf255Octets 
   $CIDRIPDec = $CIDRIPDec.Substring(0, 15) 
}
else {
   
   $CIDRIPDec = ('255.' * $NumberOf255Octets) + $TOTAL + ('.0' * (3 - $NumberOf255Octets)) 
}
$CIDRIPDec

