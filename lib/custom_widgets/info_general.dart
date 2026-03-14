import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InfoGeneralScreen extends StatefulWidget {
  const InfoGeneralScreen({super.key});

  @override
  State<InfoGeneralScreen> createState() => _InfoGeneralScreenState();
}

class _InfoGeneralScreenState extends State<InfoGeneralScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedGender;
  String? _photoUrl;
  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;

  bool _isLoading = true;
  bool _isSaving = false;
  DateTime? _pickedBirthday;

  User? _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _nameController.text = _user?.displayName ?? '';
    _emailController.text = _user?.email ?? '';
    _photoUrl = _user?.photoURL;
    // cargar datos adicionales desde Firestore (birthday, gender)
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final birthdayIso = data?['birthday_iso'] as String?;
        final birthdayReadable = data?['birthday'] as String?;
        final gender = data?['gender'] as String?;
        setState(() {
          if (birthdayIso != null && birthdayIso.isNotEmpty) {
            // parse yyyy-MM-dd
            try {
              _pickedBirthday = DateTime.parse(birthdayIso);
              _birthdayController.text = '${_pickedBirthday!.day.toString().padLeft(2, '0')} ${_monthName(_pickedBirthday!.month)} ${_pickedBirthday!.year}';
            } catch (_) {
              // fallback to readable string
              if (birthdayReadable != null && birthdayReadable.isNotEmpty) _birthdayController.text = birthdayReadable;
            }
          } else if (birthdayReadable != null && birthdayReadable.isNotEmpty) {
            _birthdayController.text = birthdayReadable;
          }
          if (gender != null && gender.isNotEmpty) {
            _selectedGender = gender;
          }
          final profileUrl = data?['photo_url'] as String?;
          if (profileUrl != null && profileUrl.isNotEmpty) {
            _photoUrl = profileUrl;
          } else if (user.photoURL != null && user.photoURL!.isNotEmpty) {
            _photoUrl = user.photoURL;
          }
        });
        // Si existe birthday legible pero no birthday_iso, intentar parsear y guardar sincronizado
        if ((birthdayIso == null || birthdayIso.isEmpty) && birthdayReadable != null && birthdayReadable.isNotEmpty) {
          final parsed = _parseReadableBirthday(birthdayReadable);
          if (parsed != null) {
            try {
              await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                'birthday_iso': parsed.toIso8601String().split('T').first,
              }, SetOptions(merge: true));
              // actualizar también la variable local para mantener sincronía
              if (mounted) {
                setState(() {
                  _pickedBirthday = parsed;
                });
              }
            } catch (_) {
              // ignore write errors
            }
          }
        }
      }
    } catch (e) {
      // no bloquear la UI por errores de lectura; opcional: log
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _pickedBirthday = picked;
        _birthdayController.text = '${picked.day.toString().padLeft(2, '0')} ${_monthName(picked.month)} ${picked.year}';
      });
    }
  }

  Future<void> _changePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;
      setState(() {
        _pickedImage = image;
        _pickedImageBytes = bytes;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto seleccionada, recuerda guardar los cambios')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo seleccionar la foto: $e')),
      );
    }
  }

  String _monthName(int m) {
    const months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[m];
  }

  DateTime? _parseReadableBirthday(String text) {
    // Espera formato 'dd MMMM yyyy', p.ej. '20 Marzo 2006'
    try {
      final parts = text.trim().split(RegExp(r'\s+'));
      if (parts.length < 3) return null;
      final day = int.tryParse(parts[0]);
      final year = int.tryParse(parts.last);
      final monthName = parts.sublist(1, parts.length - 1).join(' ');
      if (day == null || year == null) return null;
      final monthsMap = {
        'enero': 1,
        'febrero': 2,
        'marzo': 3,
        'abril': 4,
        'mayo': 5,
        'junio': 6,
        'julio': 7,
        'agosto': 8,
        'septiembre': 9,
        'octubre': 10,
        'noviembre': 11,
        'diciembre': 12,
      };
      final m = monthsMap[monthName.toLowerCase()];
      if (m == null) return null;
      return DateTime(year, m, day);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final newName = _nameController.text.trim();

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? newPhotoUrl = _photoUrl;
        if (_pickedImage != null || (_pickedImageBytes != null)) {
          final uploadedUrl = await _uploadProfileImage(user);
          if (uploadedUrl != null) {
            newPhotoUrl = uploadedUrl;
          }
        }

        if (newName.isNotEmpty && newName != user.displayName) {
          await user.updateDisplayName(newName);
        }
        if (newPhotoUrl != null && newPhotoUrl.isNotEmpty && newPhotoUrl != user.photoURL) {
          await user.updatePhotoURL(newPhotoUrl);
        }

        final Map<String, Object?> updates = {};
        if (_selectedGender != null && _selectedGender!.isNotEmpty) {
          updates['gender'] = _selectedGender;
        }
        if (_birthdayController.text.isNotEmpty) {
          updates['birthday'] = _birthdayController.text;
        }
        final DateTime? birthdayIsoSource = _pickedBirthday ?? _parseReadableBirthday(_birthdayController.text);
        if (birthdayIsoSource != null) {
          updates['birthday_iso'] = birthdayIsoSource.toIso8601String().split('T').first;
        }
        if (newPhotoUrl != null && newPhotoUrl.isNotEmpty) {
          updates['photo_url'] = newPhotoUrl;
        }

        if (updates.isNotEmpty) {
          await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
                updates,
                SetOptions(merge: true),
              );
        }

        await user.reload();
        final refreshed = FirebaseAuth.instance.currentUser;
        setState(() {
          _user = refreshed;
          _photoUrl = newPhotoUrl ?? refreshed?.photoURL;
          _pickedImage = null;
          _pickedImageBytes = null;
        });
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cambios guardados')));
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error guardando: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<String?> _uploadProfileImage(User user) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref('users/${user.uid}/profile.jpg');
      UploadTask? uploadTask;

      if (!kIsWeb && _pickedImage != null) {
        uploadTask = storageRef.putFile(
          File(_pickedImage!.path),
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else if (_pickedImageBytes != null) {
        uploadTask = storageRef.putData(
          _pickedImageBytes!,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      }

      if (uploadTask == null) return null;

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      return snapshot.ref.getDownloadURL();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo subir la foto: $e')));
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Información general', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? SafeArea(
              child: Container(
                color: const Color(0xFFB71C1C),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.white24,
                              child: _pickedImageBytes != null
                                  ? ClipOval(
                                      child: Image.memory(
                                        _pickedImageBytes!,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : (_photoUrl != null && _photoUrl!.isNotEmpty)
                                      ? ClipOval(
                                          child: Image.network(
                                            _photoUrl!,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, _, _) => const Icon(Icons.person, size: 48, color: Colors.white),
                                          ),
                                        )
                                      : const Icon(Icons.person, size: 48, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _isSaving ? null : _changePhoto,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                              child: const Text('Cambiar foto', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      _label('Tu nombre'),
                      const SizedBox(height: 6),
                      _buildTextField(_nameController, hint: 'Nombre completo', icon: Icons.person, enabled: true),

                      const SizedBox(height: 12),
                      _label('Tu cumpleaños'),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: _selectBirthday,
                        child: AbsorbPointer(
                          child: _buildTextField(_birthdayController, hint: 'Fecha de nacimiento', icon: Icons.cake, enabled: true),
                        ),
                      ),

                      const SizedBox(height: 12),
                      _label('Correo electronico'),
                      const SizedBox(height: 6),
                      _buildTextField(_emailController, hint: 'Email', icon: Icons.email, enabled: false),

                      const SizedBox(height: 12),
                      _label('Genero'),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person_outline, color: Colors.black)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _selectedGender,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                                DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                                DropdownMenuItem(value: 'Prefiero no decirlo', child: Text('Prefiero no decirlo')),
                              ],
                              onChanged: (v) {
                                setState(() {
                                  _selectedGender = v;
                                });
                              },
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Selecciona tu género';
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12)),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text('Guardar cambios', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));

  Widget _buildTextField(TextEditingController controller, {required String hint, required IconData icon, bool enabled = true}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: const Icon(Icons.edit, size: 18),
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            validator: (v) {
              if (controller == _nameController && (v == null || v.trim().isEmpty)) return 'Ingresa tu nombre';
              return null;
            },
          ),
        ),
      ],
    );
  }
}
