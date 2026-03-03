# Flutter SDK Kurulum Rehberi (Windows)

## Yöntem 1: Winget ile Otomatik Kurulum (ÖNERİLEN)

### Adım 1: PowerShell'i Yönetici Olarak Açın

```powershell
# Flutter'ı kur
winget install --id=Google.Flutter -e

# Kurulum sonrası PATH'i yenile
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

### Adım 2: Kurulumu Doğrula

```powershell
flutter --version
flutter doctor
```

---

## Yöntem 2: Manuel Kurulum

### Adım 1: Flutter SDK İndir

1. https://docs.flutter.dev/get-started/install/windows adresine git
2. "Download Flutter SDK" butonuna tıkla
3. ZIP dosyasını indir (yaklaşık 1.5 GB)

### Adım 2: Çıkart ve Yerleştir

```powershell
# Örnek: C:\src\flutter klasörüne çıkart
# ZIP dosyasını sağ tık > Extract All > C:\src\flutter
```

### Adım 3: PATH'e Ekle

1. Windows Arama'da "Environment Variables" yaz
2. "Edit the system environment variables" seç
3. "Environment Variables" butonuna tıkla
4. "Path" değişkenini seç ve "Edit" tıkla
5. "New" tıkla ve ekle: `C:\src\flutter\bin`
6. "OK" ile kaydet

### Adım 4: PowerShell'i Yeniden Başlat ve Test Et

```powershell
flutter --version
flutter doctor
```

---

## Adım 3: Android Studio Kurulumu

Flutter Android geliştirme için Android Studio gerektirir.

### Android Studio İndir ve Kur

```powershell
# Winget ile
winget install --id=Google.AndroidStudio -e

# Veya manuel: https://developer.android.com/studio
```

### Android Studio Yapılandırması

1. Android Studio'yu aç
2. "Plugins" > "Flutter" ara ve kur
3. "Dart" plugin'i otomatik kurulacak
4. SDK Manager'dan Android SDK kur (API 33 önerilir)

---

## Adım 4: Flutter Doctor Kontrolleri

```powershell
flutter doctor
```

### Çıktı Örneği:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.16.0)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[✓] Chrome - develop for the web
[✓] Visual Studio - develop Windows apps
[✓] Android Studio (version 2023.1)
[✓] VS Code (version 1.85)
[✓] Connected device (1 available)
[✓] Network resources
```

### Eksik Olanları Düzelt

```powershell
# Android lisanslarını kabul et
flutter doctor --android-licenses

# Eksik bileşenleri kur
flutter doctor
```

---

## Adım 5: Projeyi Çalıştır

### Bağımlılıkları Yükle

```powershell
cd C:\Users\Muhsin\Desktop\SmartShopperAI
flutter pub get
```

### Android Emülatör Oluştur

1. Android Studio > Tools > Device Manager
2. "Create Device" tıkla
3. Pixel 5 seç > Next
4. API 33 (Tiramisu) seç > Next
5. "Finish" tıkla
6. Play butonuna bas (emülatör başlar)

### Uygulamayı Çalıştır

```powershell
# Cihazları listele
flutter devices

# Uygulamayı çalıştır
flutter run

# Veya belirli cihazda
flutter run -d <device-id>
```

---

## Hızlı Kurulum Scripti

Aşağıdaki scripti `kurulum.ps1` olarak kaydedin ve PowerShell'de yönetici olarak çalıştırın:

```powershell
# Flutter kurulum scripti
Write-Host "Flutter SDK kuruluyor..." -ForegroundColor Green

# Winget ile Flutter kur
winget install --id=Google.Flutter -e

# PATH'i yenile
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Flutter versiyonunu kontrol et
flutter --version

# Flutter doctor çalıştır
flutter doctor

Write-Host "`nFlutter kurulumu tamamlandı!" -ForegroundColor Green
Write-Host "Şimdi Android Studio kurmanız gerekiyor." -ForegroundColor Yellow
Write-Host "Komut: winget install --id=Google.AndroidStudio -e" -ForegroundColor Cyan

# Android Studio kur (opsiyonel)
$response = Read-Host "Android Studio'yu şimdi kurmak ister misiniz? (E/H)"
if ($response -eq "E" -or $response -eq "e") {
    winget install --id=Google.AndroidStudio -e
    Write-Host "Android Studio kuruldu!" -ForegroundColor Green
}

Write-Host "`nSonraki adımlar:" -ForegroundColor Yellow
Write-Host "1. PowerShell'i yeniden başlatın" -ForegroundColor Cyan
Write-Host "2. flutter doctor çalıştırın" -ForegroundColor Cyan
Write-Host "3. flutter doctor --android-licenses çalıştırın" -ForegroundColor Cyan
Write-Host "4. Proje klasöründe: flutter pub get" -ForegroundColor Cyan
Write-Host "5. flutter run" -ForegroundColor Cyan
```

---

## Sorun Giderme

### "flutter: command not found"
- PowerShell'i yeniden başlatın
- PATH'in doğru eklendiğini kontrol edin: `$env:Path`

### "Android SDK not found"
- Android Studio'yu kurun
- SDK Manager'dan Android SDK kurun
- `flutter doctor --android-licenses` çalıştırın

### "No devices found"
- Android emülatör başlatın
- Veya gerçek Android cihazı USB ile bağlayın
- USB Debugging'i açın (Ayarlar > Geliştirici Seçenekleri)

### Emülatör Yavaş
- BIOS'tan Intel VT-x veya AMD-V'yi aktifleştirin
- Windows Hyper-V'yi devre dışı bırakın

---

## Kurulum Sonrası

### Proje Çalıştırma

```powershell
cd C:\Users\Muhsin\Desktop\SmartShopperAI

# Bağımlılıkları yükle
flutter pub get

# Uygulamayı çalıştır
flutter run

# Hot reload: r tuşu
# Hot restart: R tuşu
# Çıkış: q tuşu
```

### APK Oluşturma

```powershell
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# APK konumu
# build/app/outputs/flutter-apk/app-release.apk
```

---

## Tahmini Kurulum Süreleri

- Flutter SDK: 5-10 dakika
- Android Studio: 10-15 dakika
- Android SDK: 5-10 dakika
- İlk proje çalıştırma: 5-10 dakika
- **TOPLAM: 25-45 dakika**

---

## Gerekli Disk Alanı

- Flutter SDK: ~2 GB
- Android Studio: ~3 GB
- Android SDK: ~5 GB
- **TOPLAM: ~10 GB**

---

## Faydalı Komutlar

```powershell
# Flutter versiyonu
flutter --version

# Sistem kontrolü
flutter doctor -v

# Cihazları listele
flutter devices

# Paketleri güncelle
flutter pub upgrade

# Cache temizle
flutter clean

# Yeni proje oluştur
flutter create my_app

# Uygulamayı çalıştır
flutter run

# Hot reload
r (uygulama çalışırken)

# Hot restart
R (uygulama çalışırken)
```

---

## Sonraki Adımlar

1. ✅ Flutter SDK kur
2. ✅ Android Studio kur
3. ✅ flutter doctor çalıştır
4. ✅ flutter pub get (proje klasöründe)
5. ✅ Emülatör başlat
6. ✅ flutter run

**İyi geliştirmeler!** 🚀
