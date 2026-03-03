import 'package:flutter/material.dart';

void showOrdersBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Siparişlerim', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
            const SizedBox(height: 16),
            _buildOrderItem('Kablosuz Kulaklık', 'Kargoda', '₺ 299,90', Colors.orange, Icons.local_shipping),
            const Divider(height: 24),
            _buildOrderItem('Spor Ayakkabı', 'Hazırlanıyor', '₺ 549,90', Colors.blue, Icons.inventory_2),
          ],
        ),
      );
    },
  );
}

void showCouponsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Kuponlarım', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
            const SizedBox(height: 16),
            _buildCouponCard('50 TL İndirim', '500 TL ve üzeri alışverişlerde', '31 Aralık 2026', Colors.green),
            const SizedBox(height: 12),
            _buildCouponCard('%20 İndirim', 'Elektronik kategorisinde', '15 Ocak 2027', Colors.purple),
          ],
        ),
      );
    },
  );
}

void showWalletBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Hepsipay Cüzdanım', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade600]), borderRadius: BorderRadius.circular(16)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mevcut Bakiye', style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('1.250,00 ₺', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildOrderItem(String title, String status, String price, Color color, IconData icon) {
  return Row(
    children: [
      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 28)),
      const SizedBox(width: 16),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(status, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500))])),
      Text(price, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ],
  );
}

Widget _buildCouponCard(String title, String description, String expiry, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color, width: 2)),
    child: Row(
      children: [
        Icon(Icons.local_offer, color: color, size: 32),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)), const SizedBox(height: 4), Text(description, style: const TextStyle(fontSize: 12)), const SizedBox(height: 4), Text('Son kullanma: $expiry', style: const TextStyle(fontSize: 11, color: Colors.grey))])),
      ],
    ),
  );
}
