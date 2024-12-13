import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Importáljuk a flutter_svg csomagot

class IconPicker extends StatefulWidget {
  final Function(String) onIconSelected;
  final String initialIconPath; // A kezdeti ikon útvonala
  final double height;

  const IconPicker({
    super.key,
    required this.onIconSelected,
    this.height = 80,
    this.initialIconPath = 'assets/icons/icon1.svg',
  });

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  late String _selectedIcon;

  // Az ikonok listája az assets/icons/ mappában
  final List<String> _iconList = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon6.svg',
    'assets/icons/icon7.svg',
    'assets/icons/icon8.svg',
    'assets/icons/icon9.svg',
  ];

  bool _isDropdownOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _selectedIcon = widget.initialIconPath.isNotEmpty ? widget.initialIconPath : _iconList[0];
    print('Selected icon: $_selectedIcon');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (_isDropdownOpen) {
                _removeOverlay();
              } else {
                _showOverlay(context);
              }
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            width: (widget.height * 0.15 < 100) ? 100 : widget.height * 0.15,
            height: (widget.height * 0.15 < 100) ? 100 : widget.height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFA1D4EE),
            ),
            child: Stack(
              children: [
                Center(
                  // SVG kép betöltése
                  child: SvgPicture.asset(
                    _selectedIcon, // A kiválasztott ikon elérési útja
                    fit: BoxFit.contain, // Kép arányos megjelenítése
                    width: (widget.height * 0.12 < 80) ? 80 : widget.height * 0.12, // A kívánt szélesség
                    height: (widget.height * 0.12 < 80) ? 80 : widget.height * 0.12, // A kívánt magasság
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Icon(
                    _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - (size.width + 150) / 3.8,
        top: offset.dy + size.height,
        width: size.width + 150,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: size.width + 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0x77A1D4EE),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
              ),
              itemCount: _iconList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = _iconList[index]; // Az új ikon elérési útja
                      widget.onIconSelected(_selectedIcon); // Callback meghívása
                      _removeOverlay();
                      _isDropdownOpen = false;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        _iconList[index],
                        fit: BoxFit.contain, // SVG képek megfelelő megjelenítése
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
