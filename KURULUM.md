# SmartShopperAI Kurulum Rehberi

## Gerekli Adımlar

### 1. Projeyi Xcode'da Açın
- `SmartShopperAI.xcodeproj` dosyasına çift tıklayın
- Xcode otomatik olarak açılacaktır

### 2. SwiftSoup Paketi Otomatik Yüklenecek
Xcode projeyi açtığında SwiftSoup paketini otomatik olarak indirecektir. Eğer otomatik yüklenmezse:

1. Xcode menüsünden: `File` > `Add Package Dependencies...`
2. Arama kutusuna yapıştırın: `https://github.com/scinfu/SwiftSoup.git`
3. Version: `2.6.0` veya üzeri seçin
4. `Add Package` butonuna tıklayın

### 3. İzinler Kontrol Edildi ✅
`Info.plist` dosyasında aşağıdaki izinler zaten mevcut:

- **Kamera İzni**: `NSCameraUsageDescription`
- **İnternet Erişimi**: `NSAppTransportSecurity` > `NSAllowsArbitraryLoads`

### 4. Gerçek Cihazda Test Edin
- Simülatör kamera desteklemez
- iPhone veya iPad'inizi Mac'e bağlayın
- Xcode'da cihazınızı seçin
- Run (▶️) butonuna basın

### 5. İlk Çalıştırma
- Uygulama kamera izni isteyecek - "İzin Ver" seçin
- Kamera otomatik başlayacak
- Bir objeye kamerayı tutun ve fotoğraf çekin
- Obje tanımlanacak ve fiyatlar aranacak

## Sorun Giderme

### SwiftSoup Yüklenmediyse
```bash
# Xcode'u kapatın
# Terminal'de proje klasöründe:
xcodebuild -resolvePackageDependencies
```

### Kamera Çalışmıyorsa
- Gerçek cihaz kullandığınızdan emin olun
- Ayarlar > SmartShopperAI > Kamera iznini kontrol edin

### İnternet Bağlantısı Hatası
- Info.plist'te `NSAppTransportSecurity` ayarının olduğundan emin olun
- Cihazınızın internet bağlantısını kontrol edin

## Teknik Detaylar

- **Minimum iOS**: 15.0
- **Xcode**: 14.0+
- **Swift**: 5.7+
- **Bağımlılıklar**: SwiftSoup 2.6.0+

## Özellikler

✅ Kamera ile fotoğraf çekme
✅ Apple Vision ile obje tanımlama
✅ Google üzerinden fiyat araması
✅ Trendyol ve Amazon fiyat karşılaştırma
✅ Tamamen ücretsiz (API yok)
