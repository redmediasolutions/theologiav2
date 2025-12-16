import 'package:flutter/material.dart';

class Articlepage extends StatelessWidget {
  const Articlepage
({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resusable secondary appbar
      appBar: SecondaryAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                 Icon(Icons.menu_book_rounded,color: const Color.fromARGB(255, 185, 142, 126),size: 18),
                 SizedBox(width: 10),
                 Text('Theology',
                    style: TextStyle(color: const Color.fromARGB(255, 191, 150, 135),fontSize: 13),)
                ],
              ),
              SizedBox(height: 20),
              Text('The Relevance of God\'s Grace in Our Life',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)), 
                     SizedBox(height: 15),

              //resuable  read time
              ReadDetails(readtime: '7 min read', date: 'November 15, 2024',),
              SizedBox(height: 20),
              Divider(),
              
              SizedBox(height: 25),
              //image
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: 
                 Image.asset('grace.jpeg')
                 ),
                 SizedBox(height: 25),

              //text1
              Text('Grace [grā] - elegance and beauty of movement. How God\'s grace transforms us.'),
              SizedBox(height: 20),

              //text2
              Text('Grace is not merely a theological concept, but a transformative power that shapes every aspect of our Christian walk. When we truly understand the depth of God\'s grace, it changes how we see ourselves, others, and our relationship with the Almighty.'),
              SizedBox(height: 20),

              //heading1
              Text('Understanding Grace',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
                    SizedBox(height: 20),
              //text of heading
              Text('The Greek word for grace, "charis," carries with it the idea of divine favor and kindness. It speaks to the unmerited goodwill of God toward humanity. This grace is not something we can earn or deserve; it is freely given by a loving Father who desires relationship with His children.'),
              SizedBox(height: 20),

              //verse container
              VerseContainer(verse: 'For it is by grace you have been saved, through faith—and this is not from yourselves, it is the gift of God.', 
               verselocation: '-Ephesians 2:8',),
               SizedBox(height: 20),

              // text3
              Text('Throughout Scripture, we see countless examples of God\'s grace in action. From the garden of Eden to the cross of Calvary, the story of redemption is woven with threads of divine grace. God could have abandoned humanity after the fall, but instead, He chose to pursue us with relentless love.'),
              SizedBox(height: 20),

              //heading2
              Text('Grace in Daily Living',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),

              //text of heading2
              Text('Living in grace means extending to others the same kindness and forgiveness we have received from God. It means releasing bitterness, choosing mercy over judgment, and walking in humility. When we truly grasp how much we\'ve been forgiven, it becomes natural to forgive others.'),
              SizedBox(height: 20),

              //text 4
              Text('Grace also empowers us for righteous living. It is not a license to sin, but rather the power to overcome sin. As Paul writes in Titus 2:11-12, "For the grace of God has appeared that offers salvation to all people. It teaches us to say \'No\' to ungodliness and worldly passions, and to live self-controlled, upright and godly lives in this present age.'),
              SizedBox(height: 20),

              //heading3
              Text('The Transformative Power',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),

              //text of heading3
              Text('When we live in the reality of God\'s grace, transformation becomes inevitable. We begin to see ourselves not through the lens of our failures, but through God\'s eyes of love and acceptance. This doesn\'t mean we become complacent about sin; rather, it gives us the security and strength to face our shortcomings honestly and grow.'),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 30),

              //conclusion
              Text('As we conclude, let us remember that grace is both our foundation and our calling. We stand on the grace of God, and we are called to be conduits of that same grace to a world desperately in need of hope, love, and transformation.'),
              SizedBox(height: 40),
              Divider(),
              SizedBox(height:20),

              //Continue reading
              Text('Continue Reading',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w600)),
                    SizedBox(height: 15),
              
              //other reads 
              Articles(type: 'Decoding Pentecostalism', topic: 'Understanding the Gifts of the Spirit', time: '11 min read'),
              SizedBox(height: 20),

              Articles(type: 'Theology', topic: 'The Trinity: Understanding the Three-in-One', time: '15 min read')



            ],
          ),
        ),
      )


       );
  }
}

class VerseContainer extends StatelessWidget {
  final String verse;
  final String verselocation;
  const VerseContainer({
    super.key, required this.verse, required this.verselocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 249, 249, 249),
        border: Border(
          left: BorderSide(
            width: 3,
            color: const Color.fromARGB(255, 184, 148, 135)
          )
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(verse,style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(height: 10),
            Text(verselocation,
             style: TextStyle(
              color: const Color.fromARGB(255, 162, 126, 112)
             ),)
          ],
        ),
      ),
    
    );
  }
}






class SecondaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SecondaryAppbar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(       
      backgroundColor: Colors.white,
      leading: Icon(Icons.arrow_back),
      actions: [
        IconButton(onPressed: (){},
         icon: Icon(Icons.bookmark_border) 
         ),
        IconButton(onPressed: (){},
         icon: Icon(Icons.share_outlined)),
        SizedBox(width: 15,)
      ],
    );
  }
}

class ReadDetails extends StatelessWidget {
  final String readtime;
  final String date;
  const ReadDetails
({super.key, required this.readtime, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.access_time,size: 18,color: const Color.fromARGB(255, 122, 122, 122),),
        SizedBox(width: 8),
        Text(readtime,
         style: TextStyle(
           fontSize: 13,
           color: const Color.fromARGB(255, 88, 88, 88)
         ),),
        SizedBox(width: 15),
        Icon(Icons.circle,size: 5,),
        SizedBox(width: 15),
        Text(date,
         style: TextStyle(
           fontSize: 13,
           color: const Color.fromARGB(255, 88, 88, 88)
         ),)
      ],
    );
  }
}

class Articles extends StatelessWidget {
  final String type;
  final String topic;
  final String time;
  const Articles({super.key, required this.type, required this.topic, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type,
             style: TextStyle(
              fontSize: 12,
              color: const Color.fromARGB(255, 177, 141, 128)
             ),),
             SizedBox(height: 10),
            Text(topic,
                       style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time,size: 15,),
                SizedBox(width: 8),
                Text(time,
                 style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
                 ),),
              ],
            ),        
          ]
          
        ),
      )
    );
  }
}