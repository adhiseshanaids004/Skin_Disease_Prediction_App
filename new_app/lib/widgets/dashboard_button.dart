import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const DashboardButton({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      // ignore: deprecated_member_use
      splashColor: color.withOpacity(0.2),
      // ignore: deprecated_member_use
      highlightColor: color.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark 
              // ignore: deprecated_member_use
              ? color.withOpacity(0.15)
              // ignore: deprecated_member_use
              : color.withOpacity(0.1),
          border: Border.all(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: color.withOpacity(isDark ? 0.2 : 0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark 
                    // ignore: deprecated_member_use
                    ? color.withOpacity(0.9)
                    // ignore: deprecated_member_use
                    : color.withBlue((color.blue * 0.8).toInt())
                             // ignore: deprecated_member_use
                             .withGreen((color.green * 0.8).toInt())
                             // ignore: deprecated_member_use
                             .withRed((color.red * 0.8).toInt()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
