param(
    [String]$texpath = $(Read-Host "TexturePath"),
    [String]$destination = $(Read-Host "Destination"),
    [String]$modid = $(Read-Host "ModId"),
    [String]$type = $(Read-Host "Item or Block i/b")
)

Get-ChildItem $texpath -Filter *.png | Foreach-Object {
    if($type.ToLower() -eq "i"){
        $content = "{`n" + '  "parent": "minecraft:item/generated",' + "`n" + '  "textures": {' + "`n" + '    "layer0": "bluepower:items/' + $_.BaseName + '"' + "`n  }`n}"
        $content | Out-File -Encoding "UTF8" "$destination$($_.BaseName).json"
    }elseif($type.ToLower() -eq "b"){
        $content = "{`n" + '  "forge_marker": 1,' + "`n" + '  "defaults": {' + "`n" + '    "textures": {' + "`n" + '    "all": "bluepower:blocks/' + $_.BaseName + '"' + "`n    },`n" + '    "model": "cube_all",' + "`n" + '    "uvlock": true' + "`n  },`n" + '  "variants": {'+ "`n" + '    "normal": [{' + "`n`n    }]`n  }`n}"
        $content | Out-File -Encoding "UTF8" "$destination$($_.BaseName).json"
    }
}