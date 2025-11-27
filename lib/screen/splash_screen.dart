import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shoe_world/tools/animated_text.dart';
import 'package:shoe_world/tools/mainlayout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Scale animation (zoom-in)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _controller.addListener(() {
      setState(() {}); // For progress bar update
    });

    // Navigate after animation completes
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Responsive logo size
    double logoSize = size.width * 0.3;
    if (logoSize > 220) logoSize = 220;

    // Responsive font size
    double fontSize = size.width > 900
        ? 48
        : size.width > 600
            ? 36
            : 30;

     return Scaffold(
      backgroundColor: Colors.white, // plain white background
      body: Stack(
        children: [
          // Centered logo + app name + tagline
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: logoSize,
                      width: logoSize,
                      child: Image.asset(
                        'assets/images/images-removebg-preview (1).png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedGradientText(
                      text: "M-Store",
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Everything you need, all in one place!',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom loading section
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated loading text
                DefaultTextStyle(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Loading Products...',
                        speed: const Duration(milliseconds: 50),
                      ),
                     
                      TyperAnimatedText(
                        'Almost ready for you...',
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                    repeatForever: true,
                  ),
                ),
                const SizedBox(height: 15),

                // Linear progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    minHeight: 4,
                    color: Colors.black,
                    backgroundColor: Colors.black12,
                  ),
                ),
                const SizedBox(height: 10),

                // Progress percentage
                Text(
                  '${(_controller.value * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),

                // Circular progress
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
