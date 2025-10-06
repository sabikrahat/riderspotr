import 'package:flutter/material.dart';

import 'custom_text_field.dart';

class DropdownTextfield extends StatefulWidget {
  const DropdownTextfield({
    super.key,
    required this.items,
    required this.labelText,
    this.initialValue,
    this.onChanged,
  });

  final String labelText;
  final String? initialValue;
  final List<String> items;
  final ValueChanged<String>? onChanged;

  @override
  State<DropdownTextfield> createState() => _DropdownTextfieldState();
}

class _DropdownTextfieldState extends State<DropdownTextfield>
    with TickerProviderStateMixin {
  bool _isDropdownOpen = false;
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late String? _selectedValue;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation =
        Tween<double>(
          begin: -20.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _slideAnimation.value),
                            child: Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                width: size.width,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade900,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ListView(
                                    padding: EdgeInsets.zero,
                                    children: List.generate(
                                      widget.items.length,
                                      (index) {
                                        final item = widget.items[index];
                                        return ListTile(
                                          title: Text(
                                            item,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _selectedValue = item;
                                            });
                                            widget.onChanged?.call(item);
                                            _closeDropdown();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
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
    _animationController.forward();
  }

  void _closeDropdown() {
    if (_isDropdownOpen) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _isDropdownOpen = false;
        setState(() {});
      });
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
      child: CustomTextField(
        key: _dropdownKey,
        onTap: () => _showDropdown(),
        readOnly: true,
        controller: TextEditingController(text: _selectedValue),
        decoration: InputDecoration(
          labelText: widget.labelText,
          suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
        ),
      ),
    );
  }
}
