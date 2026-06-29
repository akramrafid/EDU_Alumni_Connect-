import 'package:flutter/material.dart';

class UniversityCrest extends StatelessWidget {
  final double size;
  final Color color;

  const UniversityCrest({
    super.key,
    this.size = 140,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: size * 0.28,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              'EAST DELTA',
              style: TextStyle(
                color: color,
                fontSize: size * 0.065,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'UNIVERSITY',
              style: TextStyle(
                color: color,
                fontSize: size * 0.05,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Container(
              height: 1.5,
              width: size * 0.45,
              color: color.withOpacity(0.6),
            ),
            const SizedBox(height: 2),
            Text(
              'EST. 2006',
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: size * 0.045,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
