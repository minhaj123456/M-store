import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AnimatedGradientText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const AnimatedGradientText({
    super.key,
    required this.text,
    this.fontSize = 32,
    this.fontWeight = FontWeight.bold,
  });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-_animation.value, 0),
              end: const Alignment(1, 0),
              colors: [
              const Color.fromARGB(255, 214, 58, 1),
  const Color.fromARGB(255, 242, 129, 30),
  const Color.fromARGB(255, 243, 238, 235),
  const Color.fromARGB(255, 243, 162, 76),
              ],
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: const Color.fromARGB(255, 231, 246, 132), // important for gradient mask
              letterSpacing: 1.2,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
