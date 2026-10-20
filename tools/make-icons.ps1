param([string]$Root = (Split-Path $PSScriptRoot -Parent))
Add-Type -AssemblyName System.Drawing

function New-RIcon([string]$Path, [int]$Size) {
  $dir = Split-Path $Path -Parent
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
  $bmp = New-Object System.Drawing.Bitmap $Size, $Size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.Clear([System.Drawing.ColorTranslator]::FromHtml('#4F46E5'))
  $fontSize = [Math]::Floor($Size * 0.58)
  $font = New-Object System.Drawing.Font('Arial', $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $format = New-Object System.Drawing.StringFormat
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Center
  $g.DrawString('R', $font, [System.Drawing.Brushes]::White, (New-Object System.Drawing.RectangleF(0,0,$Size,$Size)), $format)
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $format.Dispose(); $font.Dispose(); $g.Dispose(); $bmp.Dispose()
}

New-RIcon (Join-Path $Root 'pwa/icons/icon-192.png') 192
New-RIcon (Join-Path $Root 'pwa/icons/icon-512.png') 512
New-RIcon (Join-Path $Root 'pwa/icons/icon-512-maskable.png') 512

$densities = @{ 'mdpi' = 48; 'hdpi' = 72; 'xhdpi' = 96; 'xxhdpi' = 144; 'xxxhdpi' = 192 }
foreach ($density in $densities.GetEnumerator()) {
  $folder = Join-Path $Root "android/app/src/main/res/mipmap-$($density.Key)"
  foreach ($name in @('ic_launcher.png', 'ic_launcher_round.png', 'ic_launcher_foreground.png')) {
    New-RIcon (Join-Path $folder $name) $density.Value
  }
  foreach ($orientation in @("drawable-port-$($density.Key)", "drawable-land-$($density.Key)")) {
    New-RIcon (Join-Path $Root "android/app/src/main/res/$orientation/splash.png") ([Math]::Max(160, $density.Value * 4))
  }
}
New-RIcon (Join-Path $Root 'android/app/src/main/res/drawable/splash.png') 256
