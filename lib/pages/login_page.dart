import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simüle edilmiş giriş işlemi (1 saniye bekle)
      await Future.delayed(const Duration(seconds: 1));

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(
        _nameController.text.trim(),
        _emailController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      // Ana sayfaya yönlendir
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş Yap"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo veya ikon
              const Icon(
                Icons.person,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 32),
              
              // Başlık
              const Text(
                "FitTakip'e Hoş Geldiniz!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              const Text(
                "Sağlık takibinize başlamak için giriş yapın",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // İsim alanı
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Adınız Soyadınız",
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Lütfen adınızı girin";
                  }
                  if (value.trim().length < 2) {
                    return "Ad en az 2 karakter olmalı";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email alanı
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "E-posta Adresiniz",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Lütfen e-posta adresinizi girin";
                  }
                  if (!value.contains('@')) {
                    return "Geçerli bir e-posta adresi girin";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Giriş butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 16),

              // Bilgi metni
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 24,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Bu uygulama demo amaçlıdır. Herhangi bir bilgi girebilirsiniz.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}