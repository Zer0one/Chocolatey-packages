import-module au

function global:au_SearchReplace {
    @{
       "$($Latest.PackageName).nuspec" = @{
          "^(\s*<projectSourceUrl>).*(<\/projectSourceUrl>)" = "`${1}$($Latest.Source)`$2"
       }
    }
}

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_GetLatest {
   $Release = 'https://www.freefilesync.org'

   $download_page = Invoke-WebRequest -Uri "$Release/download.php"

   $URLstub = $download_page.links |
                 Where-Object {$_.href -match '\.exe$'} | 
                 Select-Object -ExpandProperty href

   $SourceStub = $download_page.links |
                 Where-Object {$_.href -match 'source\.zip$'} | 
                 Select-Object -ExpandProperty href

   $version = $URLstub -replace '.*_([0-9.]+)_.*','$1'

   $url = "$Release$URLstub"
   $Source = "$Release$SourceStub"

   return @{ Version = $version; URL32 = $url; Source = $Source}
}

update -ChecksumFor none -NoReadme