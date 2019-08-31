#One Name per Line

$name = Get-Content .\File.txt
Get-Random -InputObject $name

# OR

#Just use an array of names and then add them as a parameter to Get-Random.   
#You could even pipe it to Get-Random if you liked as well.

$NameList='John','Charlotte','Sean','Colleen','Namoli','Maura','Neula'

Get-Random -InputObject $NameList