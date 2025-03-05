import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _size = 300;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _size = 120;
        _opacity = 1.0;
      });
    });

    // Navigate after animation completes
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: Curves.easeInOut,
            height: _size,
            width: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    "https://dynamic.design.com/asset/logo/2627f46f-94ef-40a7-8fd5-f24fd981a1ef/logo-search-grid-2x?logoTemplateVersion=1&v=638732470614770000&text=Tazk&colorpalette=red"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}