import 'package:flutter/material.dart';

class CustomSimpleHeader extends StatelessWidget {
  final String title;
  final double width;
  final double height;

  const CustomSimpleHeader({
    super.key,
    required this.title,
    required this.width,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {

    double headerHeight = (height * 0.07 < 45) ? 45 : height * 0.07;
    double fontSize = (height * 0.03 < 14) ? 14 : height * 0.03;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Háttér konténer
        Container(
          width: width * 0.65,
          height: headerHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF4CDAFE),
            borderRadius: BorderRadius.circular(width * 0.08),
            border: Border.all(
              color: Colors.white,
              width: 4,
            ),
          ),
        ),
        // Szöveg réteg, ami a háttér felett jelenik meg
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding növelése
          child: Text(
            title,
            textAlign: TextAlign.center, // Szöveg középre igazítása
            softWrap: true, // Szöveg automatikus tördelése
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
