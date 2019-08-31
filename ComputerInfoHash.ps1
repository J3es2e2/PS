$data = Get-ComputerInfo
 
$data | 
  Get-Member -MemberType *Property | 
  Select-Object -ExpandProperty Name |
  ForEach-Object { $hash = @{}} { $hash[$_] = $data.$_ } { $hash } |
  Out-GridView