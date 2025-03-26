import 'package:flutter/material.dart';
import 'package:trash_crew/controllers/user_controller.dart';
import 'package:trash_crew/views/Login.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _profileImageController = TextEditingController();
  final UserController _userController = UserController();

  void _register(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final location = _locationController.text;
    final profileImageUrl = _profileImageController.text;

    final success = await _userController.register(email, profileImageUrl, location, password);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: Color(0xFF41A317),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _inputField('Email', _emailController, false),
            const SizedBox(height: 20),
            _inputField('Password', _passwordController, true),
            const SizedBox(height: 20),
            _inputField('Location', _locationController, false),
            const SizedBox(height: 20),
            _inputField('Profile Image URL', _profileImageController, false),
            const SizedBox(height: 20),
            Center(child: _registerButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF41A317)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF41A317), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF41A317), width: 3),
        ),
      ),
    );
  }

  ElevatedButton _registerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _register(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF41A317),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: const Text(
        'Register',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
