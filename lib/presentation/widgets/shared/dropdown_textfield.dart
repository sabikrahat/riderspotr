import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DropdownTextfield extends StatefulWidget {
  const DropdownTextfield({super.key});

  @override
  State<DropdownTextfield> createState() => _DropdownTextfieldState();
}

class _DropdownTextfieldState extends State<DropdownTextfield> {
  bool _isDropdownOpen = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    final renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Theme(
        data: Theme.of(context),
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () => _closeDropdown(),
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Invisible overlay that covers the entire screen so tapping
                  // outside will close the dropdown
                  Positioned.fill(child: Container(color: Colors.transparent)),
                  // The actual dropdown content
                  Positioned(
                    left: position.dx,
                    top: position.dy + size.height + 4,
                    child: GestureDetector(
                      onTap: () {
                        // Prevent closing when tapping on the dropdown content
                      },
                      child: Container(
                        width: size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade900,
                        ),
                        child: ListView(
                          children: [ListTile(title: Text('Item 1'))],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    setState(() {
      _isDropdownOpen = true;
    });
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (_isDropdownOpen) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isDropdownOpen = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (_isDropdownOpen) {
          _closeDropdown();
        }
        return false;
      },
      child: TextFormField(
        key: _dropdownKey,
        onTap: () => _showDropdown(),
        readOnly: true,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
