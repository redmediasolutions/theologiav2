import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theologia_app_1/articlepage/articlepage.dart';

class Devotionpage extends StatelessWidget {
  const Devotionpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Row(
          children: [
            Icon(Icons.arrow_back),
            SizedBox(width: 20),
            Icon(Icons.wb_sunny_outlined,size: 20,color: const Color.fromARGB(255, 224, 173, 126),)
          ],
        ),
        title: Text('Devotion for the Day',
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 19)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            SizedBox(height: 0),          
            TodaysDevotionContainer(title: 'Endure People'),           
            Row(
              children: [
                Text('Transcript',style: TextStyle(color: const Color.fromARGB(255, 117, 116, 116)),),
                Spacer(),
                Text('Tue, Nov 18',style: TextStyle(color: const Color.fromARGB(255, 117, 116, 116)))]),
            Text('Endure People',
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 25)),
            Text('Ephesians 4:2-3 NIV',style: TextStyle(color: const Color.fromARGB(255, 119, 118, 118),fontSize: 13),),
            SizedBox(height: 10),
            //Verse
            VerseContainer2(verse: 'Be completely humble and gentle; be patient, bearing with one another in love. Make every effort to keep the unity of the Spirit through the bond of peace.'),
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
  const TodaysDevotionContainer({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 197, 17, 229),const Color.fromARGB(255, 118, 77, 239)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
                ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 25),
            height: 212,
            width: double.infinity,
          
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Devotion',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100),),
                SizedBox(height: 18),
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text(title,
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 32,color: Colors.white))]),
                    SizedBox(height: 2),
                    IconButton(onPressed: (){}, icon: Icon(Icons.play_circle,color: Colors.white,size: 65,)),
                    
           ] )

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