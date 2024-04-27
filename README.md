### Instalar Oh My Posh en Linux


```
wget https://raw.githubusercontent.com/digiraldo/Oh-My-Posh-Linux/main/install.sh
chmod +x install.sh
./install.sh
```
```
curl -s https://ohmyposh.dev/install.sh | bash -s
```
```
wget https://ohmyposh.dev/install.sh
chmod +x install.sh
./install.sh
```

### Agregar Usuario a sudoers
#### Inicie primero como usuario root
```
su -
```
```
wget https://raw.githubusercontent.com/digiraldo/Oh-My-Posh-Linux/main/usr.sh
chmod +x usr.sh
./usr.sh
```

### Repostorio de Pruebas


```
wget https://raw.githubusercontent.com/digiraldo/Oh-My-Posh-Linux/main/init.sh
chmod +x init.sh
./init.sh
```
```
wget https://raw.githubusercontent.com/digiraldo/Oh-My-Posh-Linux/main/insta.sh
chmod +x insta.sh
./insta.sh
```

### Repostorio de Pruebas Panel Instalacion Nginx y PHP
```
wget https://raw.githubusercontent.com/digiraldo/Minecraft-BE-Server-Panel-Admin-Web/master/panelwww.sh
chmod +x panelwww.sh
./panelwww.sh
```

### Para Windows
```
winget install JanDeDobbeleer.OhMyPosh -s winget
```
```
Get-PoshThemes
```
```
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
```
```
oh-my-posh
```
* Como administrador instalamos la fuente FiraCode
```
oh-my-posh font install
```
```
New-Item -Path $PROFILE -Type File -Force
```
```
notepad $PROFILE
```
```
(@(& $path_exe init pwsh --config=$pathThemes+'atomic.omp.json' --print) -join "`n") | Invoke-Expression
```
* Instalar Iconos del Terminal

```
Install-Module -Name Terminal-Icons -Repository PSGallery
```
```
Import-Module Terminal-Icons
```
* Mostrar todo el historial que hemos escrito en el terminal
```
Set-PSReadLineOption -PredictionViewStyle ListView
```
* Incluir en el notepad $PROFILE
```
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomic.omp.json" | Invoke-Expression
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionViewStyle ListView
```
