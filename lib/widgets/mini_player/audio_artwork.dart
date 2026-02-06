import 'package:flutter/material.dart';

/// Widget untuk menampilkan artwork/album art dengan gradient overlay
class AudioArtwork extends StatelessWidget {
  final String? imageUrl;
  final String text;
  final double size;
  final Color primaryColor;

  const AudioArtwork({
    super.key,
    this.imageUrl,
    required this.text,
    this.size = 60,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: 0.8),
            primaryColor.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note_rounded,
              color: Colors.white.withValues(alpha: 0.8),
              size: size * 0.4,
            ),
            SizedBox(height: size * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size * 0.15),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: size * 0.12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
