import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _motivationalMessage = "";

  final List<String> _messages = [
    "Bol su, iyi zihin! 💧🧠",
    "Sağlık bir bardakla başlar.",
    "Bir bardak daha, hedefe daha yakın!",
    "Unutma, vücudunun %70'i sudan oluşur!",
    "İçtiğin her bardak seni tazeler 💪",
    "Bugün kendin için bir bardak su iç 💙",
  ];

  @override
  void initState() {
    super.initState();
    _generateMotivation();
  }

  void _generateMotivation() {
    final random = Random();
    setState(() {
      _motivationalMessage = _messages[random.nextInt(_messages.length)];
    });
  }

  void _signOut() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goToLogin() {
    Navigator.pushNamed(context, '/login');
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Profil")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kullanıcı bilgileri veya giriş yap butonu
                if (authProvider.isLoggedIn) ...[
                  // Giriş yapılmış durum
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.person, size: 32, color: Colors.blue),
                              SizedBox(width: 12),
                              Text(
                                "Kullanıcı Bilgileri",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text("Ad Soyad"),
                            subtitle: Text(authProvider.userName),
                            contentPadding: EdgeInsets.zero,
                          ),
                          ListTile(
                            leading: const Icon(Icons.email_outlined),
                            title: const Text("E-posta"),
                            subtitle: Text(authProvider.userEmail),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout),
                      label: const Text("Çıkış Yap"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ] else ...[
                  // Giriş yapılmamış durum
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Giriş Yapmamışsınız",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Sağlık takibinize başlamak için giriş yapın",
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _goToLogin,
                              icon: const Icon(Icons.login),
                              label: const Text("Giriş Yap"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Motivasyon mesajı (her durumda göster)
                const Text("🧠 Günün Motivasyon Mesajı:", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    _motivationalMessage,
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800, // Daha koyu mavi - net görünür
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Harita butonu
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/map'),
                  icon: const Icon(Icons.map),
                  label: const Text("Haritayı Gör"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
