function Move-Icon {
    if (-not (Test-Path "C:\GetPath")) {
        New-Item -ItemType Directory -Path "C:\GetPath" | Out-Null
        Write-Output "The program folder has been added"
    } else {
        Write-Warning "The program folder already exists"
    }

    if (-not (Test-Path "C:\GetPath\path.ico")) {
        $source = "ico\path.ico"
        $destination = "C:\GetPath\path.ico"
        Copy-Item -Path $source -Destination $destination -Force | Out-Null
        Write-Output "The icon was installed"
    } else {
        Write-Warning "The icon is already installed"
    }
}

function Remove-Icon {
    if ((Test-Path "C:\GetPath")) {
        Remove-Item -Path "C:\GetPath" -Recurse -Force | Out-Null
        Write-Output "The program folder was deleted"
    } else {
        Write-Warning "The folder with the program no longer exists"
    }
}

function Add-Function {
    Move-Icon
    $output = Invoke-Expression 'bat\test.bat'
    if ([System.Boolean]::Parse($output)) {
        Write-Warning "The item exists in the registry"
    } else {
        $path = (Get-Location).Path
        $regPath = Join-Path $path "reg\get-file-path.reg"
        if (Test-Path $regPath) {
            regedit /s $regPath
            Write-Output 'Added the "Get file path" function'
        }
        else {
            Write-Error "The register file was not found, reinstall the program"
        }
    }
}

function Remove-Function {
    Remove-Icon
    $output = Invoke-Expression 'bat\test.bat'
    if ([System.Boolean]::Parse($output)) {
        $path = (Get-Location).Path
        $regPath = Join-Path $path "reg\delete.reg"
        if (Test-Path $regPath) {
            regedit /s $regPath
            Write-Output 'The "Get file path" function has been removed'
        }
        else {
            Write-Error "The register file was not found, reinstall the program"
        }
    } else {
        Write-Warning "The item does not exist in the registry"
    }
}

$choices = @("Add Function", "Remove function")
$currentIndex = 0

do {
    Clear-Host
    Write-Host "Welcome"
    Write-Host "---------------------------"

    for ($i = 0; $i -lt $choices.Length; $i++) {
        if ($i -eq $currentIndex) {
            Write-Host "> $($choices[$i])" -ForegroundColor Cyan
        } else {
            Write-Host "  $($choices[$i])"
        }
    }

    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    switch ($key.VirtualKeyCode) {
        38 { if ($currentIndex -gt 0) { $currentIndex-- } } # Up Arrow
        40 { if ($currentIndex -lt ($choices.Length - 1)) { $currentIndex++ } } # Down Arrow
        13 { # Enter Key
            switch ($currentIndex) {
                0 { Add-Function }
                1 { Remove-Function }
            }
            Start-Sleep -Seconds 2
        }
    }
} until ($key.VirtualKeyCode -eq 27) # Escape Key to Exit
