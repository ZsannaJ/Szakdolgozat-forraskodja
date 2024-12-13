import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:ranker/core/constants/enums.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final ButtonStyleType buttonStyleType;
  final ButtonSize buttonSize;
  final double height;
  final double width;
  final Function() onTap;

  const CustomButton(
      {super.key,
        required this.title,
        required this.buttonStyleType,
        required this.buttonSize,
        required this.onTap,
        required this.width,
        this.height = 95,
      });


  bool get isButtonSizeSmall =>
      buttonSize == ButtonSize.small;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    double smallH = (height * 0.07 < 45) ? 45 : height*0.07;
    double smallW = (height * 0.2 < 100) ? 100 : height*0.2;
    if(smallW > width * 0.35){
      smallW = width * 0.35;
      smallH = smallW / 2.5;
    }


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
      width: isButtonSizeSmall
        ? smallW : height * 0.3,
      height: isButtonSizeSmall
          ? smallH : height*0.13,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isButtonSizeSmall ? height*0.06 : height*0.05),
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
        height: isButtonSizeSmall
            ? smallH * 0.9 : height * 0.11,
        gradientOrientation: GradientOrientation.Horizontal,
        startColor: startColor,
        endColor: endColor,
        borderColor: borderColor,
        borderRadius: isButtonSizeSmall ? height*0.05 : height*0.05,
        stretch: false,
        onTap: (finish) {
          onTap.call();
        },
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: isButtonSizeSmall ? ((height*0.025 < 12) ? 12 : height*0.025) : (height*0.03),
                color: Colors.white,
                shadows: const [
                  BoxShadow(color: Colors.black38, blurRadius: 8)
                ]),
          ),
        ),
      ),
    );
  }
}
