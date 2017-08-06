$keypress = [Console]::ReadKey("NoEcho")
$keys = ""
while ($($keypress.Key) -ne "Escape" -and $($keypress.Key) -ne "Enter"){
    If($($keypress.Key) -eq "Tab"){
        [Console]::Write("Test") 
    }else{
        $keys+= $($keypress.KeyChar)
        [Console]::CursorLeft = 0
        [Console]::Write($keys + "`r")  
        [Console]::CursorLeft = $keys.length
    }
    $keypress = $([Console]::ReadKey("NoEcho"))
}
[Console]::WriteLine("`r")
