import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trash_crew/views/Login.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Ensure DashBoard exists
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF41A317),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Rectangle.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20), // Adds spacing
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login'); // Navigates when tapped
              },
              child: const Text(
                'Waste To Wealth',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
