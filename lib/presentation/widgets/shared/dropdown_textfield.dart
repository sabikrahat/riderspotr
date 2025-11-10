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
    
    // Calculate dynamic height based on number of items (max 5 items visible)
    final itemHeight = 48.0;
    final maxVisibleItems = 5;
    final calculatedHeight = (widget.items.length * itemHeight).clamp(0.0, maxVisibleItems * itemHeight);

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
                                constraints: BoxConstraints(
                                  maxHeight: calculatedHeight,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount: widget.items.length,
                                    separatorBuilder: (context, index) => Divider(
                                      height: 1,
                                      color: Colors.white.withValues(alpha: 0.1),
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = widget.items[index];
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          item,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
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
