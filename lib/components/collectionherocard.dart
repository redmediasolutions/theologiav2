import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CollectionHeroCard extends StatelessWidget {
  final String imageUrl;
  final String seriesLabel;
  final String title;
  final String description;

  const CollectionHeroCard({
    super.key,
    required this.imageUrl,
    required this.seriesLabel,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            /// Dark gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
    
            /// Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
    
                  /// Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4A373),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      seriesLabel.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
    
                  const Spacer(),
    
                  /// Title
                  Text(
                    title,
                    style: GoogleFonts.lora(
                      fontSize: 34,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.1,
                    ),
                  ),
    
                  const SizedBox(height: 10),
    
                  /// Description
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.85),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}