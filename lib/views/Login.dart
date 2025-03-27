import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_crew/bloc/user_bloc.dart';
import 'package:trash_crew/controllers/user_controller.dart';
import 'package:trash_crew/views/HomeScreen.dart';
import 'package:trash_crew/views/Schedule.dart';
import 'package:trash_crew/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // To store and retrieve token

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  // Check if a token exists and navigate to Schedule screen if it does
  void _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      print("Token found, navigating to Schedule...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final userBloc = BlocProvider.of<UserBloc>(context);

    print("Attempting to login with: $username");

    try {
      final user = await _userController.login(username, password, userBloc);

      if (user != null) {
        final token = user.token?? '';
        // Save the token if login is successful
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token); // Assuming `user.token` contains the JWT token

        print("Login successful, navigating to Schedule...");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print("Login failed: Invalid username or password");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      print("Error during login: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Welcome Back',
                style: TextStyle(
                  color: Color(0xFF41A317),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _inputField('Username', _usernameController, false),
            const SizedBox(height: 20),
            _inputField('Password', _passwordController, true),
            const SizedBox(height: 10),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 185),
                  child: _forgotPasswordButton(),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF41A317),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: _registerButton()),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
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

  TextButton _registerButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: const Text(
        'New user? Register',
        style: TextStyle(color: Color(0xFF41A317), fontSize: 16),
      ),
    );
  }

  TextButton _forgotPasswordButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Forgot Password?',
        style: TextStyle(color: Color(0xFF41A317), fontSize: 16),
      ),
    );
  }
}
