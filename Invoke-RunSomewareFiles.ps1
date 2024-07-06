function Invoke-RunSomewareFiles {
    param (
        [string]$InitDir
    )

    function Get-RandomContent {
        $length = Get-Random -Minimum 20 -Maximum 100
        $content = -join ((65..90) + (97..122) | Get-Random -Count $length | ForEach-Object {[char]$_})
        return $content
    }

    function Get-RandomExtension {
        $extensions = @("txt", "config", "ppt", "xlsx", "doc", "docx", "pdf")
        return $extensions | Get-Random
    }

    if (-Not (Test-Path -Path $InitDir)) {
        New-Item -Path $InitDir -ItemType "directory" | Out-Null
    }

    $logfilesDirectory = Join-Path -Path $InitDir -ChildPath "logfiles"
    if (-Not (Test-Path -Path $logfilesDirectory)) {
        New-Item -Path $logfilesDirectory -ItemType "directory" | Out-Null
    }

    $fileCount = Get-Random -Minimum 1 -Maximum 10
    for ($i = 1; $i -le $fileCount; $i++) {
        $fileName = "testfile$i.$(Get-RandomExtension)"
        $filePath = Join-Path -Path $InitDir -ChildPath $fileName
        New-Item -Path $filePath -ItemType "file" -Value (Get-RandomContent) | Out-Null
    }

    $fileCount = Get-Random -Minimum 1 -Maximum 10
    for ($i = 1; $i -le $fileCount; $i++) {
        $fileName = "logfile$i.$(Get-RandomExtension)"
        $filePath = Join-Path -Path $logfilesDirectory -ChildPath $fileName
        New-Item -Path $filePath -ItemType "file" -Value (Get-RandomContent) | Out-Null
    }

    Write-Output "Files created successfully in $InitDir and $logfilesDirectory"
}

# Example usage:
# Invoke-RunSomewareFiles -InitDir "C:\ImportantFiles"
