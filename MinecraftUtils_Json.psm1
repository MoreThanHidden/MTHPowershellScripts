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
                    break
                }
                "north"{
                    $newitem.apply.x += 90
                    break
                }
                "south"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 180
                    break
                }
                "east"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 90
                    break
                }
                "west"{
                    $newitem.apply.x += 90
                    $newitem.apply.y += 270
                    break
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
                $newitem2 = @{"when"=$newwhen; "apply"=$newapply}
                $newitem2.when.rotation = $rot
                
                switch($rot){
                    1{
                        switch($dir){
                            "down"{
                                $newitem2.apply.y += 90
                                break
                            }
                            "north"{
                                $newitem2.apply.model += "_z"
                                break
                            }
                            "south"{
                                $newitem2.apply.model += "_z"
                                break
                            }
                            "east"{
                                $newitem2.apply.model += "_z"
                                break
                            }
                            "west"{
                                $newitem2.apply.model += "_z"
                                break
                            }
                        }
                        break
                    }
                    2{
                        switch($dir){
                            "down"{
                                $newitem2.apply.y += 180
                                break
                            }
                            "north"{
                                $newitem2.apply.y += 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "south"{
                                $newitem2.apply.y += 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "east"{
                                $newitem2.apply.y += 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "west"{
                                $newitem2.apply.y += 180
                                $newitem2.apply.x += 180
                                break
                            }
                        }
                        break
                    }
                    3{
                        switch($dir){
                            "down"{
                                $newitem2.apply.y += 270
                                break
                            }
                            "north"{
                                $newitem2.apply.model += "_z"
                                $newitem2.apply.y -= 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "south"{
                                $newitem2.apply.model += "_z"
                                $newitem2.apply.y -= 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "east"{
                                $newitem2.apply.model += "_z"
                                $newitem2.apply.y -= 180
                                $newitem2.apply.x += 180
                                break
                            }
                            "west"{
                                $newitem2.apply.model += "_z"
                                $newitem2.apply.y -= 180
                                $newitem2.apply.x += 180
                                break
                            }
                        }
                        break
                    }
                }

                if($newitem2.apply.x -ge 360){
                    $newitem2.apply.x -= 360
                }

                if($newitem2.apply.y -ge 360){
                    $newitem2.apply.y -= 360
                }

                $json.multipart += $newitem2
                $newitem2 = $null
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
