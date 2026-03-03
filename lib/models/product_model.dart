class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviewCount;
  final String? badge;
  final bool isFreeShipping;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    this.badge,
    this.isFreeShipping = false,
  });

  String get discountPercentage {
    if (oldPrice == null || oldPrice! <= price) return '';
    final discount = ((oldPrice! - price) / oldPrice! * 100).round();
    return '%$discount';
  }

  static List<Product> getDummyProducts() {
    return [
      Product(
        id: '1',
        name: 'Apple iPhone 15 Pro 256GB',
        image: '📱',
        price: 54999.00,
        oldPrice: 64999.00,
        rating: 4.8,
        reviewCount: 1250,
        badge: 'Çok Satan',
        isFreeShipping: true,
      ),
      Product(
        id: '2',
        name: 'Samsung Galaxy S24 Ultra 512GB',
        image: '📱',
        price: 49999.00,
        oldPrice: 59999.00,
        rating: 4.7,
        reviewCount: 890,
        badge: 'Yeni',
        isFreeShipping: true,
      ),
      Product(
        id: '3',
        name: 'Sony WH-1000XM5 Kablosuz Kulaklık',
        image: '🎧',
        price: 8999.00,
        oldPrice: 12999.00,
        rating: 4.9,
        reviewCount: 2340,
        badge: 'Editörün Seçimi',
        isFreeShipping: true,
      ),
      Product(
        id: '4',
        name: 'Apple MacBook Air M2 13" 256GB',
        image: '💻',
        price: 42999.00,
        oldPrice: 49999.00,
        rating: 4.8,
        reviewCount: 567,
        isFreeShipping: true,
      ),
      Product(
        id: '5',
        name: 'Dyson V15 Detect Kablosuz Süpürge',
        image: '🧹',
        price: 18999.00,
        oldPrice: 24999.00,
        rating: 4.6,
        reviewCount: 432,
        badge: 'İndirimde',
        isFreeShipping: true,
      ),
      Product(
        id: '6',
        name: 'Nike Air Max 270 Spor Ayakkabı',
        image: '👟',
        price: 3499.00,
        oldPrice: 4999.00,
        rating: 4.5,
        reviewCount: 1890,
        isFreeShipping: true,
      ),
    ];
  }
}
