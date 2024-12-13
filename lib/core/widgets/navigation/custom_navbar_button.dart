import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:ranker/core/constants/enums.dart';

IconData getIconForButton(NavbarIcon buttonType) {
  switch (buttonType) {
    case NavbarIcon.rank:
      return Icons.workspace_premium;
    case NavbarIcon.graph:
      return Icons.hub;
    case NavbarIcon.players:
      return Icons.person;
    case NavbarIcon.teams:
      return Icons.groups;
    case NavbarIcon.matches:
      return Icons.stadium;
    case NavbarIcon.settings:
      return Icons.settings_outlined;
    case NavbarIcon.receipt:
      return Icons.receipt_long_rounded;
    case NavbarIcon.play:
      return Icons.monitor_rounded;
    case NavbarIcon.exit:
      return Icons.exit_to_app;
    default:
      return Icons.help_outline;
  }
}

class CustomNavbarButton extends StatelessWidget {
  final String title;
  final ButtonStyleType buttonStyleType;
  final NavbarIcon navbarIcon;
  final double buttonSize;
  final Function() onTap;

  const CustomNavbarButton(
      {super.key,
        required this.title,
        required this.buttonStyleType,
        required this.navbarIcon,
        required this.buttonSize,
        required this.onTap});


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Color startColor;
    Color endColor;
    Color borderColor;

    switch (buttonStyleType) {
      case ButtonStyleType.yellow:
        startColor = const Color(0xFFFFEE88);
        endColor = const Color(0xFFFFDB0A);
        borderColor = const Color(0xFFFFB213);
        break;
      case ButtonStyleType.pink:
        startColor = const Color(0xFFFDC0FF);
        endColor = const Color(0xFFFC8AFF);
        borderColor = const Color(0xFFDA57F0);
        break;
      case ButtonStyleType.blue:
        startColor = const Color(0xFF94E7FC);
        endColor = const Color(0xFF4CDAFE);
        borderColor = const Color(0xFF08B9FF);
        break;
      case ButtonStyleType.red:
        startColor = const Color(0xFFFF7999);
        endColor = const Color(0xFFFF4672);
        borderColor = const Color(0xFFE90038);
        break;
      case ButtonStyleType.green:
        startColor = const Color(0xFFA6F208);
        endColor = const Color(0xFF67EB00);
        borderColor = const Color(0xFF4EC307);
        break;
      case ButtonStyleType.dark:
        startColor = const Color(0xFF44AADD);
        endColor = const Color(0xFF006699);
        borderColor = const Color(0xFF003366);
        break;
      case ButtonStyleType.orange:
        startColor = const Color(0xFFFFA33C);
        endColor = const Color(0xFFFFB200);
        borderColor = const Color(0xFFFF6500);
        break;
    }

    return Container(
      width: buttonSize,
      height: buttonSize,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(buttonSize / 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 0,
          ),
        ],
      ),
      child: NiceButtons(
        width: buttonSize * 0.95,
        height: buttonSize * 0.94,
        gradientOrientation: GradientOrientation.Horizontal,
        startColor: startColor,
        endColor: endColor,
        borderColor: borderColor,
        borderRadius: buttonSize / 4,
        stretch: false,
        onTap: (finish) {
          onTap.call();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ikon
              Stack(
                children: [
                  Positioned(
                    top: 4,
                    left: 0,
                    child: Icon(
                      getIconForButton(navbarIcon),
                      size: buttonSize*0.45, // Ikon mérete
                      color: Colors.black.withOpacity(0.3), // Árnyék fekete 30%-os átlátszósággal
                    ),
                  ),
                  // Eredeti ikon
                  Icon(
                    getIconForButton(navbarIcon),
                    size: buttonSize*0.45,
                    color: Colors.white, // Ikon eredeti színe
                  ),
                ],
              ),

              // Távolság ikon és szöveg között
              SizedBox(height: buttonSize *0.02), // Finoman állítsd a távolságot

              // Szöveg
              Text(
                title,
                style: TextStyle(
                  fontSize: buttonSize * 0.15, // Szöveg mérete
                  color: Colors.white,
                  shadows: const [
                    BoxShadow(color: Colors.black38, blurRadius: 8),
                  ],
                ),
                textAlign: TextAlign.center, // Szöveg középre igazítása
              ),
            ],
          ),
        ),
      ),
    );

  }
}
