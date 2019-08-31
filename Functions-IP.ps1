function Get-SubnetsIn($BitRemainder) {
   $TotalSubnets = [math]::pow(2, ($BitRemainder % 8))
   return $TotalSubnets
}
 
function Get-SubnetSize($QtyOfSubnets) {
   $Size = 256 / $QtyOfSubnets
   return $Size
}

function Convert-IPtoArray($IPStr) {
   $IPary = $IPStr.Split('.')
   return $IPary
}
function Convert-OctetToDecimal($Oct) {
   #$Oct
   $Decimal = [convert]::ToInt32($Oct, 2)
   Return $Decimal
}

function Convert-BinaryToDecimal($BinArray) {
   
   foreach ($BinOctet in $BinArray) {
      #$BinOctet
      $BuildIP = Convert-OctetToDecimal($BinOctet) 
      $DecimalIP += $BuildIP.ToString() + '.'
   }
   return $DecimalIP -replace ".$"
}

function Convert-OctetsToBinary($IPToConvert) {
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
   return $IPinBinary -replace ".$"
}

function Convert-CIDRtoBinaryStr($C) {
   $S = $null
   for ($i = 1; $i -le $C; $i++) {
      $S += '1'
   } 
   $S = $S.Padright(32, '0')
   $S = $S.Insert(8, '.').Insert(17, '.').Insert(26, '.')
   return $S
} 

function Get-MagicNumber($CIDR) {
   $MN = $CIDR % 8
   $MagicNumber = [math]::pow(2, 8 - $MN)
   return  $MagicNumber
}

#############################################################

#$IPCIDR = Read-Host "Enter any 4-Octet decimal IP Address and CIDR (x.x.x.x /x) to find its Net ID "

$IPCIDR = "200.200.100.200 /19"
$IPsplitCIDR = $IPCIDR -split '/'
 
$IPOctets = Convert-IPtoArray($IPsplitCIDR[0])
'Convert-IPtoArray', $IPOctets

$IPBinaryStr = Convert-OctetsToBinary($IPOctets)
'Convert-OctetsToBinary', $IPBinaryStr

$IPBinaryOctets = Convert-IPtoArray($IPBinaryStr)
'Convert-IPtoArray USER', $IPBinaryOctets

$CIDRBinaryStr = Convert-CIDRtoBinaryStr($IPsplitCIDR[1])
'Convert-CIDRtoBinaryStr', $CIDRBinaryStr 

$CIDRBinaryAry = Convert-IPtoArray($CIDRBinaryStr )
'Convert-IPtoArray SUBMASK', $CIDRBinaryAry

$Submask = Convert-BinaryToDecimal($CIDRBinaryAry)
'Convert-BinaryToDecimal SUBMASK', $Submask

$NumberOfSubnets = Get-SubnetsIn($IPsplitCIDR[1])
'Get-SubnetsIn ', $NumberOfSubnets 

$SubnetSize = Get-SubnetSize($NumberOfSubnets)
'Get-SubnetSize', $SubnetSize

$MagicNumber = Get-MagicNumber($IPsplitCIDR[1])
'Get-MagicNumber', $MagicNumber  



$IPsplitCIDR[1]
$IPsplitCIDR[0]
$Submask
 

Convert-OctetsToBinary($NetID)


############################################>

##Test Switch to find ID
$NetID = $ID = $null

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

$NetIDOctets = Convert-IPtoArray($NetID)
$BroadcastID = $X = $BC = $null

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
$BroadcastID 