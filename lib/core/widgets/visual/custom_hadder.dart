import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final VoidCallback onClose;
  final bool isItBlue;

  const CustomHeader({
    super.key,
    required this.title,
    required this.width,
    this.height = 1,
    required this.onClose,
    this.isItBlue = true,
  });

  @override
  Widget build(BuildContext context) {
    // Szín változó, amely a `keke` bemenet alapján váltakozik
    final Color backgroundColor = isItBlue ? const Color(0xFF006699) : const Color(0xFFE90038);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Cím konténer
        Container(
          width: width * 0.9,
          height: (height * 0.065 < 40) ? 40 : height * 0.065,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height*0.1),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: (height * 0.02 < 10) ? 10 : height * 0.02,
              ),
            ),
          ),
        ),
        // Bezárás gomb
        Positioned(
          right: -height*0.012,
          top: -height*0.005,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              width: (height * 0.065 < 43) ? 43 : height * 0.072,
              height: (height * 0.065 < 43) ? 43 : height * 0.072,
              decoration: BoxDecoration(
                color: backgroundColor,  // Dinamikus gomb szín
                shape: BoxShape.circle,  // Kör alakú gomb
                border: Border.all(      // Fehér körvonal a gomb körül
                  color: Colors.white,
                  width: (height * 0.005 < 3) ? 3 : height * 0.005,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.close,  // Fehér "X" ikon
                  color: Colors.white,
                  size: (height * 0.04 < 25) ? 25 : height * 0.04,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
