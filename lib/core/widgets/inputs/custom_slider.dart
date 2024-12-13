import 'package:flutter/material.dart';
// CustomTextField importálása

class CustomSlider extends StatefulWidget {
  final double width;
  final double minValue;
  final double maxValue;
  final double step;
  final double initialValue;
  final ValueChanged<double>? onChanged;

  const CustomSlider({
    super.key,
    required this.width,
    this.minValue = 0,
    this.maxValue = 100,
    this.step = 1,
    this.initialValue = 0,
    this.onChanged,
  });

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: currentValue,
          min: widget.minValue,
          max: widget.maxValue,
          divisions: ((widget.maxValue - widget.minValue) / widget.step).round(),
          label: currentValue.toStringAsFixed(0), // A slider címkéje
          activeColor: const Color(0xFF006699), // A csúszka színének beállítása
          onChanged: (value) {
            setState(() {
              currentValue = value; // Frissítjük az aktuális értéket
            });
            if (widget.onChanged != null) {
              widget.onChanged!(value); // Ha van onChanged callback, meghívjuk
            }
          },
        ),
        // A CustomTextField a slider értékének megjelenítésére
      ],
    );
  }
}
