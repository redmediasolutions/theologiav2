import 'package:flutter/material.dart';
import 'package:theologia_app_1/components/globalscaffold.dart';
import 'package:theologia_app_1/components/recentdevotionscard.dart';
import 'package:theologia_app_1/main.dart';

class Devotionpage extends StatelessWidget {
  const Devotionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Globalscaffold(

        title: '',
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            SizedBox(height: 0),          
            SizedBox(
              height: 210,
              width: double.infinity,
              child: TodaysDevotionContainer(
                title: "Morning Reflections",
                subtitle: "Finding peace in the morning stillness.",
                imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
                onPlay: () {},
              ),
            ),
            SizedBox(height: 10),
            Text('RECENT DEVOTIONS',
                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          )),
            SizedBox(height: 10),
            RecentDevotionCard(
  title: "The Path of Faith",
  subtitle: "Exploring the Journey • 12 mins",
  date: "May 15, 2024",
  imageUrl: "https://images.unsplash.com/photo-1501785888041-af3ef285b470",
  onPlay: () {
    audioHandler.play();
  },
),
            SizedBox(height: 5),

            //View all devotions container
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(colors: [const Color.fromARGB(255, 228, 163, 72),const Color.fromARGB(255, 181, 128, 54)])
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    IconButton.filled(onPressed: (){}, icon: Icon(Icons.wb_sunny_outlined,color: Colors.white),style:IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.2),) ),
                    SizedBox(width: 15),
                    Text('View All Devotions',
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w100),),
                    Spacer(),
                    Icon(Icons.navigate_next,color: Colors.white)     
                  ],
                ),
              ),

            )]
            )));
  }
}


class TodaysDevotionContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onPlay;

  const TodaysDevotionContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [

          /// BACKGROUND IMAGE
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          /// DARK GRADIENT OVERLAY
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.25),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb79260).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "DAILY HIGHLIGHT",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const Spacer(),

                /// TITLE + PLAY BUTTON
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    /// TEXTS
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// PLAY BUTTON
                    GestureDetector(
                      onTap: onPlay,
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFb79260),
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VerseContainer2 extends StatelessWidget {
  final String verse;
  const VerseContainer2({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 222, 221, 221))
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(verse),
      )
    );
  }
}