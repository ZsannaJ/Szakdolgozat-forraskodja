
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final double width;
  final double height;
  final int max;
  final dynamic initialText;
  final ValueChanged<String>? onChanged;
  final bool isNumericInput;


  const CustomTextField({
    super.key,
    required this.width,
    this.height = 45,
    this.max = 500,
    this.onChanged,
    this.isNumericInput = false,
    this.initialText = '',
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    // Inicializáljuk a TextEditingController-t a megfelelő értékkel
    controller = TextEditingController(text: widget.initialText.toString());
  }

  @override
  void dispose() {
    controller.dispose(); // Ne felejtsük el törölni a controller-t
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width * 0.8,
      height: (widget.height * 0.055 < 40) ? 40 : widget.height*0.055,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFA1D4EE),
        borderRadius: BorderRadius.circular(widget.width*0.05),
      ),
      child: Center(
        child: TextField(
          maxLength: widget.max,

          controller: controller, // A TextEditingController itt van használva
          keyboardType: widget.isNumericInput
              ? TextInputType.number
              : TextInputType.text,
          inputFormatters: widget.isNumericInput
              ? [FilteringTextInputFormatter.digitsOnly] // Csak számok engedélyezése
              : [],
          style: TextStyle(fontSize: ((widget.height * 0.018 < 10) ? 10 : widget.height * 0.018), fontFamily: "Wellfleet"),
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            isDense: true,
            counterText: '',
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          onChanged: widget.onChanged, // Ha nincs, nem fog történni semmi
        ),
      ),
    );
  }
}
