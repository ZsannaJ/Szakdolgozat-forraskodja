import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextArea extends StatelessWidget {
  final double width;
  final double height;
  final int max;
  final String initialText;
  final TextEditingController controller;
  final bool isNumericInput;

  const CustomTextArea({
    super.key,
    required this.width,
    required this.height,
    this.max = 500,
    this.initialText = '',
    required this.controller,
    this.isNumericInput = false,
  });

  @override
  Widget build(BuildContext context) {
    double textFieldHeight = height * 0.7;

    return Container(
      width: width * 0.8,
      height: textFieldHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFA1D4EE),
        borderRadius: BorderRadius.circular(textFieldHeight * 0.05),
      ),
      child: Center(
        child: TextField(
          maxLength: max,
          controller: controller, // Az átadott controller használata
          maxLines: null,
          keyboardType: isNumericInput ? TextInputType.number : TextInputType.multiline,
          inputFormatters: isNumericInput
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          style: TextStyle(
              fontSize: (height * 0.03 < 12) ? 12 : height * 0.03,
              fontFamily: "Wellfleet"),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

