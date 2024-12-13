import 'package:flutter/material.dart';

class Custom3DCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;

  const Custom3DCard({
    super.key,
    required this.width,
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: width,  // Alsó kártya szélesebb, 10px plusz
          height: height + 10,  // Alsó kártya magasabb, 10px plusz
          decoration: BoxDecoration(
            color: const Color(0xFFD1D8FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),  // Árnyék fekete 20%-os átlátszósággal
                offset: const Offset(0, 4),  // Árnyék eltolása lefelé
                blurRadius: 8,  // Árnyék elmosódása
              ),
            ],
          ),
        ),
        // Felső kártya (fehér, kisebb, felül igazítva)
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),  // Belső margók
              child: child,  // A tartalom
            ),
          ),
        ),
      ],
    );
  }
}