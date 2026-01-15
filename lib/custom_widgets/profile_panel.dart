import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'info_general.dart';
import 'change_password.dart';
import 'privacy_center.dart';
import 'faq_screen.dart';

class ProfilePanel extends StatefulWidget {
  const ProfilePanel({super.key});

  @override
  State<ProfilePanel> createState() => _ProfilePanelState();
}

class _ProfilePanelState extends State<ProfilePanel> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    setState(() {
      _user = user;
    });
  }

  String _displayName(User? user) {
    if (user == null) return 'Invitado';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    }
    final email = user.email ?? '';
    if (email.contains('@')) return email.split('@').first;
    return email.isEmpty ? 'Usuario' : email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C), // rojo fuerte parecido al diseño
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white24,
                child: _user?.photoURL != null
                    ? ClipOval(
                        child: Image.network(
                          _user!.photoURL!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 48, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.person, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _displayName(_user),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1565C0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Usuario desde 2025',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView(
                  children: [
                    _buildOption(context, Icons.info, 'Información General', onTap: () async {
                      final res = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(builder: (context) => const InfoGeneralScreen()),
                      );
                      if (res == true) {
                        await _loadUser();
                      }
                    }),
                    _buildOption(context, Icons.lock, 'Cambiar Contraseña', onTap: () async {
                      final res = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                      if (res == true) {
                        // opcional: mostrar confirmación adicional o refrescar
                      }
                    }),
                    _buildOption(context, Icons.privacy_tip, 'Centro de privacidad', onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyCenterScreen()),
                      );
                    }),
                    _buildOption(context, Icons.help_outline, 'Preguntas frecuentes', onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FaqScreen()),
                      );
                    }),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 255, 111, 0),
                          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen(title: 'qpon')),
                            (route) => false,
                          );
                        },
                        child: const Text('Cerrar sesión'),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Desarrollado por MyUT © 2025',
                        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8), fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      children: [
        const Divider(color: Colors.white24, height: 1),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon, color: Colors.black),
          ),
          title: Text(label, style: const TextStyle(color: Colors.white)),
          onTap: onTap,
        ),
      ],
    );
  }
}
