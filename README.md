# SmartShopperAI

SwiftUI ile geliştirilmiş, Apple Vision framework kullanarak cihaz üzerinde obje tanımlama ve fiyat karşılaştırma yapan iOS uygulaması.

## Özellikler

- Kamera ile fotoğraf çekme
- Apple Vision ile cihaz üzerinde (ücretsiz) obje tanımlama
- Hayvan, yüz ve genel obje algılama
- Tanımlanan objenin ismini ekranda gösterme
- Google üzerinden otomatik fiyat araması
- 5 farklı siteden fiyat karşılaştırma:
  - Trendyol
  - Amazon
  - Hepsiburada
  - N11
  - Çiçeksepeti
- Paralel arama ile hızlı sonuç
- En ucuz fiyatları sıralı gösterme
- Optimize edilmiş arama sorguları
- SwiftSoup ile HTML parsing

## Gereksinimler

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+
- İnternet bağlantısı (fiyat araması için)

## Kurulum

1. Projeyi Xcode'da açın
2. SwiftSoup bağımlılığını yükleyin (Swift Package Manager otomatik yükler)
3. Gerçek bir iOS cihazı seçin (simülatör kamera desteklemez)
4. Projeyi çalıştırın

## Kullanım

1. Uygulama açıldığında kamera otomatik başlar
2. Alt kısımdaki beyaz butona basarak fotoğraf çekin
3. Apple Vision otomatik olarak objeyi tanımlar
4. Tanımlanan obje ismi ekranda görünür
5. Uygulama arka planda 5 sitede paralel fiyat araması yapar
6. Bulunan fiyatlar en ucuzdan pahalıya sıralanır
7. En ucuz 5 fiyat "En Ucuz Fiyat" başlığı altında gösterilir

## Teknik Detaylar

- Vision framework ile obje tanımlama
- URLSession ile web scraping
- SwiftSoup ile HTML parsing
- Async/await ile asenkron işlemler
- Task Group ile paralel arama
- Optimize edilmiş arama sorguları (gereksiz kelimeler temizlenir)
- Akıllı fiyat sıralama (en ucuz önce)
- Kullanıcıya ek maliyet yok (API kullanılmıyor)

## Optimizasyonlar

- Arama sorgularında "fiyat" kelimesi eklenerek daha doğru sonuçlar
- Gereksiz kelimeler (the, a, an, vb.) temizlenir
- İlk 4 anlamlı kelime kullanılır
- Paralel arama ile 5 site aynı anda taranır
- Fiyatlar sayısal olarak karşılaştırılır (string değil)
- Türkçe locale ile fiyat formatlama

## Notlar

- Kamera izni gereklidir
- İnternet bağlantısı gereklidir (fiyat araması için)
- Gerçek cihazda test edilmelidir
- MobileNetV2 modeli kullanılır (cihaz üzerinde çalışır)
- Web scraping sitelerin yapısına bağlıdır, değişiklik gösterebilir
