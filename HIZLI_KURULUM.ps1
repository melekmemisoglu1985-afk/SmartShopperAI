# Flutter Hızlı Kurulum Scripti
# PowerShell'i Yönetici olarak çalıştırın ve bu scripti çalıştırın

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Flutter SDK Hızlı Kurulum Scripti" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Winget kontrolü
Write-Host "Winget kontrol ediliyor..." -ForegroundColor Yellow
$winget = Get-Command winget -ErrorAction SilentlyContinue

if (-not $winget) {
    Write-Host "HATA: Winget bulunamadı!" -ForegroundColor Red
    Write-Host "Lütfen Windows 10/11'in güncel olduğundan emin olun." -ForegroundColor Yellow
    Write-Host "Veya manuel kurulum yapın: https://flutter.dev" -ForegroundColor Cyan
    exit
}

Write-Host "✓ Winget bulundu!" -ForegroundColor Green
Write-Host ""

# Flutter kurulumu
Write-Host "Flutter SDK kuruluyor... (Bu işlem 5-10 dakika sürebilir)" -ForegroundColor Yellow
try {
    winget install --id=Google.Flutter -e --accept-source-agreements --accept-package-agreements
    Write-Host "✓ Flutter SDK kuruldu!" -ForegroundColor Green
} catch {
    Write-Host "HATA: Flutter kurulumu başarısız!" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit
}

Write-Host ""

# PATH'i yenile
Write-Host "PATH yenileniyor..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
Write-Host "✓ PATH yenilendi!" -ForegroundColor Green
Write-Host ""

# Flutter versiyonunu kontrol et
Write-Host "Flutter versiyonu kontrol ediliyor..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
try {
    flutter --version
    Write-Host "✓ Flutter başarıyla kuruldu!" -ForegroundColor Green
} catch {
    Write-Host "UYARI: Flutter komutu bulunamadı. PowerShell'i yeniden başlatın." -ForegroundColor Yellow
}

Write-Host ""

# Android Studio kurulumu sor
Write-Host "========================================" -ForegroundColor Cyan
$response = Read-Host "Android Studio'yu kurmak ister misiniz? (E/H)"

if ($response -eq "E" -or $response -eq "e") {
    Write-Host "Android Studio kuruluyor... (Bu işlem 10-15 dakika sürebilir)" -ForegroundColor Yellow
    try {
        winget install --id=Google.AndroidStudio -e --accept-source-agreements --accept-package-agreements
        Write-Host "✓ Android Studio kuruldu!" -ForegroundColor Green
    } catch {
        Write-Host "HATA: Android Studio kurulumu başarısız!" -ForegroundColor Red
    }
} else {
    Write-Host "Android Studio kurulumu atlandı." -ForegroundColor Yellow
    Write-Host "Not: Flutter Android geliştirme için Android Studio gerektirir." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Kurulum Tamamlandı!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Sonraki Adımlar:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. PowerShell'i KAPAT ve YENİDEN AÇ (önemli!)" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Sistem kontrolü yap:" -ForegroundColor Cyan
Write-Host "   flutter doctor" -ForegroundColor White
Write-Host ""
Write-Host "3. Android lisanslarını kabul et:" -ForegroundColor Cyan
Write-Host "   flutter doctor --android-licenses" -ForegroundColor White
Write-Host ""
Write-Host "4. Proje klasörüne git:" -ForegroundColor Cyan
Write-Host "   cd C:\Users\Muhsin\Desktop\SmartShopperAI" -ForegroundColor White
Write-Host ""
Write-Host "5. Bağımlılıkları yükle:" -ForegroundColor Cyan
Write-Host "   flutter pub get" -ForegroundColor White
Write-Host ""
Write-Host "6. Uygulamayı çalıştır:" -ForegroundColor Cyan
Write-Host "   flutter run" -ForegroundColor White
Write-Host ""

Write-Host "Detaylı bilgi için FLUTTER_KURULUM.md dosyasına bakın." -ForegroundColor Yellow
Write-Host ""
Write-Host "İyi geliştirmeler! 🚀" -ForegroundColor Green

# Kullanıcıdan onay bekle
Read-Host "Devam etmek için Enter'a basın"
