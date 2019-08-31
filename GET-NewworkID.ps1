
function Convert-IPtoArray($IPStr) {
   $IPary = $IPStr.Split('.')
   return $IPary
}

function Get-SubmaskFromCIDR($CIDR) {
   $Total = 0
   $NumberOf255Octets = [Math]::Truncate($CIDR / 8)
   $PartialOctet = ($CIDR % 8)
   if ($PartialOctet -gt 0) { 
      for ($i = 7 ; $i -gt (7 - $PartialOctet) ; $i--) {
  
         $TOTAL += [math]::pow(2, $i) 
      }
      $Total = $Total.ToString + '.'
   }
   else {
      $ZeroMask = 1   
   }
   $ZeroMask += 3 - $NumberOf255Octets  
   return ( '255.' * $NumberOf255Octets ) + $Total + ('0.' * $ZeroMask )
   
}
$S = '27'
$Submask = Get-SubmaskFromCIDR($S)
$Submask


$NetID = $ID = $S = $null
$Submask = $null
$BroadcastID = $X = $BC = $null

$IPOctets = $NetIDOctets = @()

######################## GET SUBMASK

$S = Convert-IPtoArray($Submask)

for ($i = 0; $i -lt 4; $i++) {
   
   $X = $IPOctets[$i] -band $S[$i]
   switch ($X) {

      $IPOctets[$i] { $ID = $IPOctets[$i] }
      
      { $_ -le $IPOctets[$i] } { $ID = $X }
      
      0 { $ID = 0 }
   }
   $NetID += $ID.ToString() + '.'
}    
$NetID = $NetID -replace ".$"
$NetID

################################
$NetIDOctets = Convert-IPtoArray($NetID)

for ($i = 0; $i -lt 4; $i++) {
   $X = $S[$i]
   switch ($X) {

      255 { $BC = $NetIDOctets[$i] }
      
      { $_ -lt 255 } { $BC = ([convert]::ToInt32($NetIDOctets[$i]) + ($MagicNumber)) - 1 }
      
      0 { $BC = 255 }
   }
   $BroadcastID += $BC.ToString() + '.'
}
$BroadcastID = $BroadcastID -replace ".$"
###########################################