import 'dart:io';
import 'package:bottlebucks/services/registerapi.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _register() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }
    else {
      // Handle successful registration logic here
      FormData formData = FormData.fromMap({
        'name': _nameController.text,
        'address': _addressController.text,
        'email': _emailController.text,
        'username': _emailController.text,
        'phone': _phoneController.text,
        'District': _districtController.text,
        'city': _cityController.text,
        'pin': _pinController.text,
        'password': _passwordController.text,
        if (_selectedImage != null)
          'profileImage': MultipartFile.fromFileSync(_selectedImage!.path, filename: _selectedImage!.path.split('/').last),
      });
      register(context, formData);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registration successful ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF6E4),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Register for BottleBucks"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white.withOpacity(0.95),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage:
                        _selectedImage != null ? FileImage(_selectedImage!) : null,
                    child: _selectedImage == null
                        ? const Icon(Icons.camera_alt, size: 35, color: Colors.green)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                // Name
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration("Full Name", Icons.person),
                ),
                const SizedBox(height: 12),

                // Address
                TextField(
                  controller: _addressController,
                  decoration: _inputDecoration("Address", Icons.home),
                ),
                const SizedBox(height: 12),

                // Email
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email", Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),

                // Phone
                TextField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Phone Number", Icons.phone),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                // District
                TextField(
                  controller: _districtController,
                  decoration: _inputDecoration("District", Icons.map_outlined),
                ),
                const SizedBox(height: 12),

                // City
                TextField(
                  controller: _cityController,
                  decoration: _inputDecoration("City", Icons.location_city),
                ),
                const SizedBox(height: 12),

                // PIN
                TextField(
                  controller: _pinController,
                  decoration: _inputDecoration("PIN Code", Icons.pin_drop),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
