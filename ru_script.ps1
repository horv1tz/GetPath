function Move-Icon {
    if (-not (Test-Path "C:\GetPath")) {
        New-Item -ItemType Directory -Path "C:\GetPath" | Out-Null
        Write-Output "Добавлена папка программы"
    } else {
        Write-Warning "Папка программы уже существует"
    }

    if (-not (Test-Path "C:\GetPath\path.ico")) {
        $source = "ico\path.ico"
        $destination = "C:\GetPath\path.ico"
        Copy-Item -Path $source -Destination $destination -Force | Out-Null
        Write-Output "Установленна иконка"
    } else {
        Write-Warning "Иконка установленна"
    }
}

function Remove-Icon {
    if ((Test-Path "C:\GetPath")) {
        Remove-Item -Path "C:\GetPath" -Recurse -Force | Out-Null
        Write-Output "Удалена папка программы"
    } else {
        Write-Warning "Папка программы уже удалена"
    }
}

function Add-Function {
    Move-Icon
    $output = Invoke-Expression 'bat\test.bat'
    if ([System.Boolean]::Parse($output)) {
        Write-Warning "Пункт существует в реестре"
    } else {
        $path = (Get-Location).Path
        $regPath = Join-Path $path "reg\get-file-path.reg"
        if (Test-Path $regPath) {
            regedit /s $regPath
            Write-Output 'Добавленна функция "Получить путь к файлу"'
        }
        else {
            Write-Error "Не найден файл регистра, переустановите программу: $regPath"
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
            Write-Output 'Удалена функция "Получить путь к файлу"'
        }
        else {
            Write-Error "Не найден файл регистра, переустановите программу: $regPath"
        }
    } else {
        Write-Warning "Пункт не существует в реестре"
    }
}

$choices = @("Добавить функцию", "Удалить функцию")
$currentIndex = 0

do {
    Clear-Host
    Write-Host "Добро пожаловать."
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
