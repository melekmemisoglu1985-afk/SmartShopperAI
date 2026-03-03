import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hesabım')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)])),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text('MM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Melek Memişoğlu', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('melekmemisoglu1985@gmail.com', style: TextStyle(color: Colors.white, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(leading: Icon(Icons.person_outline, color: Theme.of(context).primaryColor), title: const Text('Profil Bilgilerim'), subtitle: const Text('Ad, soyad, telefon'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
            ListTile(leading: Icon(Icons.shopping_bag_outlined, color: Theme.of(context).primaryColor), title: const Text('Aktif Siparişler'), subtitle: const Text('2 adet sipariş'), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () {}),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Çıkış Yap'),
                          content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
                            TextButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Çıkış yapıldı'), duration: Duration(seconds: 2))); }, child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red))),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Çıkış Yap'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
