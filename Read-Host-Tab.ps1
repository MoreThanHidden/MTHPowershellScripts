param(
[String]$prompt,
[String[]]$autocomplete
)

[String]$keys = "" #Text
[int]$pos = 0 #Cursor Position
[string]$hist = "" #Auto Complete History
[int]$hpos = 0 #Auto Complete Count

while ($($keypress.Key) -ne "Escape" -and $($keypress.Key) -ne "Enter"){
    [Console]::CursorLeft = 0
    [Console]::Write($prompt)
    [Console]::CursorLeft = $prompt.Length + $pos
    $keypress = [Console]::ReadKey("NoEcho")
    switch ($($keypress.Key)) {
        "Tab" {
            if($autocomplete){
                if($hpos -eq 0){
                    $hist = $keys
                }elseif($keys -notlike ($hist + "*")){
                    $hist = $keys
                }

                $res = $autocomplete -like ($hist + "*")

                if($res -is [array]){
                    if($hpos -ge $res.Length){
                        $hpos = 0
                }
                    $keys = $res[$hpos]
                    $hpos++
                }elseif($res){
                    $keys = $res
                }
                $pos = $keys.Length
            }
        }
        "Backspace" {
            if($keys.Length -gt $pos){
                $keys = $keys.Substring(0,($pos - 1)) + $keys.Substring($pos,$keys.Length - $pos)
                $pos -= 1
            }elseif ($keys.Length -gt 0) {
                 $keys = $keys.Substring(0,($keys.Length - 1))
                 $pos -= 1
            }
        }
        "Delete" {
            if($keys.Length -gt $pos){
                $keys = $keys.Substring(0,$pos) + $keys.Substring($pos + 1,$keys.Length - ($pos + 1))
            }
        }
        "LeftArrow" {
            if ($pos -gt 0) {$pos--}
        }
        "RightArrow" {
            if ($pos -lt $keys.Length) {$pos++}
        }
        Default {
            $keys += $($keypress.KeyChar)
            $pos += 1
        }
    }
    if($keypress.Key -ne "Tab"){$hpos = 0}

    [Console]::CursorLeft = 0
    [Console]::Write($prompt + $keys.PadRight([Console]::WindowWidth - ($keys.length + $prompt.Length + 1) ))
}
[Console]::CursorLeft = 0
return $keys