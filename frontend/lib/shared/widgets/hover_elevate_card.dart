import 'package:flutter/material.dart';

class HoverElevateCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HoverElevateCard({super.key, required this.child, this.onTap});

  @override
  State<HoverElevateCard> createState() => _HoverElevateCardState();
}

class _HoverElevateCardState extends State<HoverElevateCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.diagonal3Values(_isHovering ? 1.02 : 1.0, _isHovering ? 1.02 : 1.0, 1.0),
          transformAlignment: FractionalOffset.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isHovering
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
