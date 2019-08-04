$directions = @("down","north","south","east","west")
$rotations = @(1,2,3)

function clone($obj){
    $newobj = New-Object PsObject
    $obj.psobject.Properties | % {Add-Member -MemberType NoteProperty -InputObject $newobj -Name $_.Name -Value $_.Value}
    return $newobj
}

#Create a Json Multipart file given rotation 0 and facing "up" 
function get-mcjson-rotateface{
    param(
        $input_json
    )

    $json = ConvertFrom-Json –InputObject $input_json

    foreach($item in $json.multipart){
        foreach($dir in $directions){
            $newapply = clone $item.apply
            $newwhen = clone $item.when
            $newitem = @{"when"=$newwhen; "apply"=$newapply}
            if($newitem.apply.x -eq $null){Add-Member -MemberType NoteProperty -InputObject $newitem.apply -Name "x" -Value 0}
            if($newitem.apply.y -eq $null){Add-Member -MemberType NoteProperty -InputObject $newitem.apply -Name "y" -Value 0}
            $newitem.when.facing = $dir

            switch($dir){
                "down"{
                    $newitem.apply.x = 180
                }
                "north"{
                    $newitem.apply.x += 90
                }
                "south"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 180
                }
                "east"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 90
                }
                "west"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 270
                }
            }

            if($newitem.apply.x -ge 360){
                $newitem.apply.x -= 360
            }

            if($newitem.apply.y -ge 360){
                $newitem.apply.y -= 360
            }

            $json.multipart += $newitem
            
            foreach($rot in $rotations){
                $newapply = clone $newitem.apply
                $newwhen = clone $newitem.when
                $newitem = @{"when"=$newwhen; "apply"=$newapply}
                $newitem.when.rotation = $rot

                switch($dir){
                    1{
                        $newitem.apply.y += 90
                    }
                    2{
                        $newitem.apply.y += 180
                    }
                    3{
                        $newitem.apply.y += 270
                    }
                }

                if($newitem.apply.x -ge 360){
                    $newitem.apply.x -= 360
                }

                if($newitem.apply.y -ge 360){
                    $newitem.apply.y -= 360
                }

                $json.multipart += $newitem
            }
        }
    }
    $json | ConvertTo-Json -Depth 4
}


#Create a Json Multipart file given facing "up" 
function get-mcjson-face{
    param(
        $input_json
    )

    $json = ConvertFrom-Json –InputObject $input_json

    foreach($item in $json.multipart){
        foreach($dir in $directions){
            $newapply = clone $item.apply
            $newwhen = clone $item.when
            $newitem = @{"when"=$newwhen; "apply"=$newapply}
            if($newitem.apply.x -eq $null){Add-Member -MemberType NoteProperty -InputObject $newitem.apply -Name "x" -Value 0}
            if($newitem.apply.y -eq $null){Add-Member -MemberType NoteProperty -InputObject $newitem.apply -Name "y" -Value 0}
            $newitem.when.facing = $dir

            switch($dir){
                "down"{
                    $newitem.apply.x += 180
                }
                "north"{
                    $newitem.apply.x += 90
                }
                "south"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 180
                }
                "east"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 90
                }
                "west"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 270
                }
            }

            $json.multipart += $newitem
        }
    }
    $json | ConvertTo-Json -Depth 4
}
