$Folder = "D:\Muziek\"
$URL = Read-Host -Prompt "URL"
$sURL  = $URL.Remove($URL.IndexOf('?'))
youtube-dl.exe $sURL --output "$Folder%(creator)s  %(title)s.%(ext)s" --extract-audio --audio-format mp3