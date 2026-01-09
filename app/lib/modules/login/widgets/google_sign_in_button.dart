import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const GoogleSignInButton({super.key, this.onPressed});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 480),
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7A00),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A00).withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isPressed ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CustomPaint(
                      size: const Size(18, 18),
                      painter: GoogleIconPainter(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Đăng nhập với Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.015,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF4285F4);
    final path1 = Path()
      ..moveTo(17.64, 9.2)
      ..cubicTo(17.64, 8.563, 17.583, 7.949, 17.476, 7.36)
      ..lineTo(9, 9)
      ..lineTo(9, 10.841)
      ..lineTo(13.844, 10.841)
      ..cubicTo(13.635, 11.557, 13.248, 12.196, 12.704, 12.716)
      ..lineTo(15.612, 15.075)
      ..cubicTo(17.314, 13.567, 18.296, 11.259, 18.296, 8.519)
      ..lineTo(17.64, 9.2)
      ..close();
    canvas.drawPath(path1, paint);

    paint.color = const Color(0xFF34A853);
    final path2 = Path()
      ..moveTo(9, 18)
      ..cubicTo(11.43, 18, 13.467, 17.194, 14.956, 15.82)
      ..lineTo(12.048, 13.561)
      ..cubicTo(11.242, 14.101, 10.211, 14.42, 9, 14.42)
      ..cubicTo(6.656, 14.42, 4.672, 12.836, 3.964, 10.705)
      ..lineTo(0.957, 13.037)
      ..cubicTo(2.348, 15.827, 5.426, 18, 9, 18)
      ..close();
    canvas.drawPath(path2, paint);

    paint.color = const Color(0xFFFBBC05);
    final path3 = Path()
      ..moveTo(3.964, 10.71)
      ..cubicTo(3.784, 10.17, 3.682, 9.593, 3.682, 9)
      ..cubicTo(3.682, 8.407, 3.784, 7.83, 3.964, 7.29)
      ..lineTo(0.957, 4.958)
      ..cubicTo(0.348, 6.173, 0, 7.548, 0, 9)
      ..cubicTo(0, 10.452, 0.348, 11.827, 0.957, 13.042)
      ..lineTo(3.964, 10.71)
      ..close();
    canvas.drawPath(path3, paint);

    paint.color = const Color(0xFFEA4335);
    final path4 = Path()
      ..moveTo(9, 3.58)
      ..cubicTo(10.321, 3.58, 11.508, 4.034, 12.44, 4.925)
      ..lineTo(15.022, 2.345)
      ..cubicTo(13.463, 0.891, 11.426, 0, 9, 0)
      ..cubicTo(5.426, 0, 2.348, 2.173, 0.957, 4.958)
      ..lineTo(3.964, 7.272)
      ..cubicTo(4.672, 5.142, 6.656, 3.58, 9, 3.58)
      ..close();
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
