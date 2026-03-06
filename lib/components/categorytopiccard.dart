import 'package:flutter/material.dart';

class CategoryTopicCard extends StatelessWidget {
  final String title;
  final String summary;
  final String readtime;
  final String date;
  final String category;
  final String imageUrl;
  final String views;

  const CategoryTopicCard({
    super.key,
    required this.title,
    required this.summary,
    required this.readtime,
    required this.date,
    required this.category,
    required this.imageUrl,
    required this.views,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Top Image
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                imageUrl,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            /// Category + Date
            Row(
              children: [
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB08968),
                    letterSpacing: 0.8,
                  ),
                ),

                const SizedBox(width: 10),

                const Icon(Icons.circle, size: 4, color: Colors.grey),

                const SizedBox(width: 10),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
            ),

            const SizedBox(height: 10),

            /// Summary
            Text(
              summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 16),

            /// Bottom Meta Row
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),

                const SizedBox(width: 6),

                Text(
                  readtime,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(width: 18),

                const Icon(Icons.visibility_outlined,
                    size: 18, color: Colors.grey),

                const SizedBox(width: 6),

                Text(
                  views,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}