import 'package:flutter/material.dart';

class CustomDropdownField extends StatefulWidget {
  final double width;
  final double height;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final int? selectedIndex;

  const CustomDropdownField({
    super.key,
    required this.width,
    this.height = 45,
    required this.items,
    required this.onChanged,
    this.selectedIndex,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Ha van megadott index, akkor inicializáljuk a selectedValue-t
    if (widget.selectedIndex != null && widget.selectedIndex! >= 0 && widget.selectedIndex! < widget.items.length) {
      selectedValue = widget.items[widget.selectedIndex!];
    } else {
      selectedValue = null; // Ha nincs index, akkor üres legyen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      height: (widget.height * 0.055 < 40) ? 40 : widget.height * 0.055,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFA1D4EE), // A háttér világoskék szín
        borderRadius: BorderRadius.circular(widget.width * 0.05),
      ),
      child: GestureDetector(
        onTap: () => _showDropdownMenu(context), // Dropdown menü megjelenítése
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Hosszú szövegek esetén a szöveg levágása ellipszisszel
            Expanded(
              child: Text(
                selectedValue ?? 'Choose', // Alapértelmezett szöveg
                style: TextStyle(
                  fontSize: (widget.height * 0.018 < 10) ? 10 : widget.height * 0.018,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Wellfleet',
                  color: const Color(0xFF006699), // Szöveg színe
                  overflow: TextOverflow.ellipsis, // Szöveg levágása, ha túl hosszú
                ),
                maxLines: 1, // Csak egy sorban jelenjen meg
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Color(0xFF006699), // Nyíl színe (kék)
            ),
          ],
        ),
      ),
    );
  }

  void _showDropdownMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: widget.height * 0.4, // A lenyíló lista maximális magassága
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFA1D4EE), // Háttér színe
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Kerekített sarkok
          ),
          child: ListView(
            children: widget.items.map((String item) {
              return ListTile(
                title: Text(
                  item,
                  style: TextStyle(
                    color: const Color(0xFF006699),
                    fontFamily: 'Wellfleet',
                    fontSize: (widget.height * 0.018 < 10) ? 10 : widget.height * 0.018, // Alkalmazott szövegméret
                    overflow: TextOverflow.ellipsis, // Levágás hosszú neveknél
                  ),
                  maxLines: 1, // Csak egy sorban jelenjen meg
                ),
                onTap: () {
                  setState(() {
                    selectedValue = item; // Kiválasztott elem beállítása
                  });
                  widget.onChanged(item); // Callback a kiválasztott elemhez
                  Navigator.pop(context); // Bezárja a lenyíló menüt
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
