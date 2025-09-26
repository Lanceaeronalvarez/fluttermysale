import 'package:flutter/material.dart';

class IconTextBadgeButton extends StatelessWidget {
  final double height;
  final IconData icon;
  final String text;
  final int count;
  final VoidCallback? onTap;

  final double spacing;
  final BorderRadius borderRadius;
  final Color borderColor;
  final Color background;

  const IconTextBadgeButton({
    super.key,
    required this.height,
    required this.icon,
    required this.text,
    required this.count,
    this.onTap,
    this.spacing = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.borderColor = const Color(0xFFCCA68B),
    this.background = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            SizedBox(width: spacing),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (count > 0) SizedBox(width: spacing),
            if (count > 0) _createBadge(),
          ],
        ),
      ),
    );
  }

  Widget _createBadge() {
    String badgeText = (count > 99) ? '99+' : count.toString();
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF54ECFF),
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              height: 1.0,
            ),
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
