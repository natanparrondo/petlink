import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/style/colors.dart';
import 'package:myapp/style/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class PrefsService {
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setDateTime(String key, DateTime value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value.toIso8601String());
  }

  static Future<DateTime?> getDateTime(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString(key);
    if (stringValue == null) return null;
    return DateTime.tryParse(stringValue);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

class PetLinkIDPage extends StatefulWidget {
  const PetLinkIDPage({super.key});

  @override
  State<PetLinkIDPage> createState() => _PetLinkIDPageState();
}

class _PetLinkIDPageState extends State<PetLinkIDPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedBreed;
  XFile? _pickedImage;
  String? _imagePath;

  final List<String> _breeds = ['Caniche Toy', 'Schnauzer', 'Golden Retriever'];

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    try {
      _nameController.text = await PrefsService.getString('pet_name') ?? '';
      _imagePath = await PrefsService.getString('pet_picture') ?? '';
      _selectedDate = await PrefsService.getDateTime('pet_dob');
      _dateController.text =
          _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : '';
      _selectedBreed = await PrefsService.getString('pet_breed');
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar datos de la mascota')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
      await _saveImageLocally(image);
    }
  }

  Future<void> _saveImageLocally(XFile image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imageName =
          'pet_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final newPath = '${directory.path}/$imageName';
      final File savedImage = await File(image.path).copy(newPath);
      _imagePath = savedImage.path;
      await PrefsService.setString('pet_picture', newPath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la imagen')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.tile,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      await PrefsService.setString('pet_name', _nameController.text);
      if (_selectedDate != null) {
        await PrefsService.setDateTime('pet_dob', _selectedDate!);
      }
      if (_selectedBreed != null) {
        await PrefsService.setString('pet_breed', _selectedBreed!);
      }
      if (_imagePath != null) {
        await PrefsService.setString('pet_picture', _imagePath!);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil de mascota guardado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al guardar el perfil de la mascota'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('PetLink ID', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.tile,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _imagePath != null
                            ? FileImage(File(_imagePath!))
                            : null,
                    child:
                        _imagePath == null
                            ? const Icon(Icons.pets, size: 60)
                            : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _pickDate,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Raza de animal',
                labelStyle: TextStyle(color: AppColors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
              ),
              dropdownColor: AppColors.tile,
              value: _selectedBreed,
              onChanged: (value) => setState(() => _selectedBreed = value),
              items:
                  _breeds
                      .map(
                        (breed) => DropdownMenuItem(
                          value: breed,
                          child: Text(
                            breed,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                      )
                      .toList(),
              style: const TextStyle(color: AppColors.white),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.done, color: AppColors.white),
                label: const Text('Guardar', style: AppTextStyles.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
