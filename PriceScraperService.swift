import Foundation
import SwiftSoup

struct ProductPrice: Identifiable {
    let id = UUID()
    let storeName: String
    let price: String
    let url: String
}

class PriceScraperService {
    
    func searchPrices(for productName: String) async -> [ProductPrice] {
        let optimizedQuery = optimizeSearchQuery(productName)
        
        // Paralel arama için task grubu
        await withTaskGroup(of: ProductPrice?.self) { group in
            var prices: [ProductPrice] = []
            
            // Tüm sitelerde paralel arama
            group.addTask { await self.searchTrendyol(productName: optimizedQuery) }
            group.addTask { await self.searchAmazon(productName: optimizedQuery) }
            group.addTask { await self.searchHepsiburada(productName: optimizedQuery) }
            group.addTask { await self.searchN11(productName: optimizedQuery) }
            group.addTask { await self.searchCiceksepeti(productName: optimizedQuery) }
            
            // Sonuçları topla
            for await price in group {
                if let price = price {
                    prices.append(price)
                }
            }
            
            // En ucuzdan pahalıya sırala
            return prices.sorted { extractNumericPrice($0.price) < extractNumericPrice($1.price) }
        }
    }
    
    private func optimizeSearchQuery(_ productName: String) -> String {
        // Gereksiz kelimeleri temizle
        let stopWords = ["the", "a", "an", "and", "or", "but", "in", "on", "at", "to", "for"]
        var words = productName.lowercased()
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty && !stopWords.contains($0) }
        
        // İlk 3-4 anlamlı kelimeyi al
        if words.count > 4 {
            words = Array(words.prefix(4))
        }
        
        return words.joined(separator: " ")
    }
    
    private func searchTrendyol(productName: String) async -> ProductPrice? {
        let searchQuery = "\(productName) fiyat site:trendyol.com"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.google.com/search?q=\(encodedQuery)&hl=tr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            // Google arama sonuçlarından Trendyol linkini bul
            let links = try doc.select("a[href*='trendyol.com']")
            
            for link in links.array() {
                if let href = try? link.attr("href"),
                   href.contains("trendyol.com"),
                   let productUrl = extractURL(from: href) {
                    
                    // Ürün sayfasından fiyat çek
                    if let price = await scrapeTrendyolPrice(url: productUrl) {
                        return ProductPrice(storeName: "Trendyol", price: price, url: productUrl)
                    }
                }
            }
        } catch {
            print("Trendyol arama hatası: \(error)")
        }
        
        return nil
    }
    
    private func searchAmazon(productName: String) async -> ProductPrice? {
        let searchQuery = "\(productName) fiyat site:amazon.com.tr"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.google.com/search?q=\(encodedQuery)&hl=tr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            // Google arama sonuçlarından Amazon linkini bul
            let links = try doc.select("a[href*='amazon.com.tr']")
            
            for link in links.array() {
                if let href = try? link.attr("href"),
                   href.contains("amazon.com.tr"),
                   let productUrl = extractURL(from: href) {
                    
                    // Ürün sayfasından fiyat çek
                    if let price = await scrapeAmazonPrice(url: productUrl) {
                        return ProductPrice(storeName: "Amazon", price: price, url: productUrl)
                    }
                }
            }
        } catch {
            print("Amazon arama hatası: \(error)")
        }
        
        return nil
    }
    
    private func scrapeTrendyolPrice(url: String) async -> String? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            // Trendyol fiyat selektörleri
            let priceSelectors = [
                "span.prc-dsc",
                "span[class*='price']",
                "div.price-container span"
            ]
            
            for selector in priceSelectors {
                if let priceElement = try? doc.select(selector).first(),
                   let priceText = try? priceElement.text(),
                   !priceText.isEmpty {
                    return cleanPrice(priceText)
                }
            }
        } catch {
            print("Trendyol fiyat çekme hatası: \(error)")
        }
        
        return nil
    }
    
    private func scrapeAmazonPrice(url: String) async -> String? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            // Amazon fiyat selektörleri
            let priceSelectors = [
                "span.a-price-whole",
                "span#priceblock_ourprice",
                "span.a-offscreen"
            ]
            
            for selector in priceSelectors {
                if let priceElement = try? doc.select(selector).first(),
                   let priceText = try? priceElement.text(),
                   !priceText.isEmpty {
                    return cleanPrice(priceText)
                }
            }
        } catch {
            print("Amazon fiyat çekme hatası: \(error)")
        }
        
        return nil
    }
    
    private func extractURL(from googleLink: String) -> String? {
        // Google redirect URL'inden gerçek URL'i çıkar
        if let range = googleLink.range(of: "url=") {
            let urlPart = String(googleLink[range.upperBound...])
            if let endRange = urlPart.range(of: "&") {
                return String(urlPart[..<endRange.lowerBound])
            }
            return urlPart
        }
        
        // Direkt URL ise
        if googleLink.hasPrefix("http") {
            return googleLink
        }
        
        return nil
    }
    
    private func cleanPrice(_ price: String) -> String {
        // Fiyatı temizle ve formatla
        var cleaned = price
            .replacingOccurrences(of: "TL", with: "")
            .replacingOccurrences(of: "₺", with: "")
            .trimmingCharacters(in: .whitespaces)
        
        // Sayısal değeri çıkar ve formatla
        let numericValue = extractNumericPrice(cleaned)
        if numericValue != Double.infinity {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.locale = Locale(identifier: "tr_TR")
            
            if let formatted = formatter.string(from: NSNumber(value: numericValue)) {
                return "\(formatted) ₺"
            }
        }
        
        return cleaned.isEmpty ? price : "\(cleaned) ₺"
    }
    
    private func searchHepsiburada(productName: String) async -> ProductPrice? {
        let searchQuery = "\(productName) fiyat site:hepsiburada.com"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.google.com/search?q=\(encodedQuery)&hl=tr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            let links = try doc.select("a[href*='hepsiburada.com']")
            
            for link in links.array() {
                if let href = try? link.attr("href"),
                   href.contains("hepsiburada.com"),
                   let productUrl = extractURL(from: href) {
                    
                    if let price = await scrapeHepsiburadaPrice(url: productUrl) {
                        return ProductPrice(storeName: "Hepsiburada", price: price, url: productUrl)
                    }
                }
            }
        } catch {
            print("Hepsiburada arama hatası: \(error)")
        }
        
        return nil
    }
    
    private func searchN11(productName: String) async -> ProductPrice? {
        let searchQuery = "\(productName) fiyat site:n11.com"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.google.com/search?q=\(encodedQuery)&hl=tr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            let links = try doc.select("a[href*='n11.com']")
            
            for link in links.array() {
                if let href = try? link.attr("href"),
                   href.contains("n11.com"),
                   let productUrl = extractURL(from: href) {
                    
                    if let price = await scrapeN11Price(url: productUrl) {
                        return ProductPrice(storeName: "N11", price: price, url: productUrl)
                    }
                }
            }
        } catch {
            print("N11 arama hatası: \(error)")
        }
        
        return nil
    }
    
    private func searchCiceksepeti(productName: String) async -> ProductPrice? {
        let searchQuery = "\(productName) fiyat site:ciceksepeti.com"
        guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://www.google.com/search?q=\(encodedQuery)&hl=tr") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            let links = try doc.select("a[href*='ciceksepeti.com']")
            
            for link in links.array() {
                if let href = try? link.attr("href"),
                   href.contains("ciceksepeti.com"),
                   let productUrl = extractURL(from: href) {
                    
                    if let price = await scrapeCiceksepetiPrice(url: productUrl) {
                        return ProductPrice(storeName: "Çiçeksepeti", price: price, url: productUrl)
                    }
                }
            }
        } catch {
            print("Çiçeksepeti arama hatası: \(error)")
        }
        
        return nil
    }
    
    private func scrapeHepsiburadaPrice(url: String) async -> String? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            let priceSelectors = [
                "span[data-bind*='currentPriceBeforePoint']",
                "span.price-value",
                "div[data-bind*='price'] span"
            ]
            
            for selector in priceSelectors {
                if let priceElement = try? doc.select(selector).first(),
                   let priceText = try? priceElement.text(),
                   !priceText.isEmpty {
                    return cleanPrice(priceText)
                }
            }
        } catch {
            print("Hepsiburada fiyat çekme hatası: \(error)")
        }
        
        return nil
    }
    
    private func scrapeN11Price(url: String) async -> String? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            let priceSelectors = [
                "ins.newPrice",
                "span.newPrice",
                "div.priceContainer ins"
            ]
            
            for selector in priceSelectors {
                if let priceElement = try? doc.select(selector).first(),
                   let priceText = try? priceElement.text(),
                   !priceText.isEmpty {
                    return cleanPrice(priceText)
                }
            }
        } catch {
            print("N11 fiyat çekme hatası: \(error)")
        }
        
        return nil
    }
    
    private func scrapeCiceksepetiPrice(url: String) async -> String? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            var request = URLRequest(url: url)
            request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15", forHTTPHeaderField: "User-Agent")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let html = String(data: data, encoding: .utf8) else { return nil }
            
            let doc = try SwiftSoup.parse(html)
            
            let priceSelectors = [
                "span.price",
                "div.product-price span",
                "span[class*='price']"
            ]
            
            for selector in priceSelectors {
                if let priceElement = try? doc.select(selector).first(),
                   let priceText = try? priceElement.text(),
                   !priceText.isEmpty {
                    return cleanPrice(priceText)
                }
            }
        } catch {
            print("Çiçeksepeti fiyat çekme hatası: \(error)")
        }
        
        return nil
    }
    
    private func extractNumericPrice(_ priceString: String) -> Double {
        // Fiyat stringinden sayısal değeri çıkar (virgül ve nokta desteği)
        let cleaned = priceString
            .replacingOccurrences(of: "₺", with: "")
            .replacingOccurrences(of: "TL", with: "")
            .replacingOccurrences(of: ".", with: "") // Binlik ayracı
            .replacingOccurrences(of: ",", with: ".") // Ondalık ayracı
            .trimmingCharacters(in: .whitespaces)
        
        // Sadece sayıları ve noktayı al
        let numbers = cleaned.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()
        return Double(numbers) ?? Double.infinity
    }
}
