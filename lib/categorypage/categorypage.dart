import 'package:flutter/material.dart';

class Categorypage extends StatelessWidget {
  const Categorypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TertiaryAppbar(majortopic: 'Biblical Manhood'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ExploreAndIcon(),
              SizedBox(height: 25),
              CategoryTopicCard(title: 'The Role of Men in Christian Leadership', summary: 'Exploring biblical principles of godly leadership and...', readtime:'8 min read', date: 'December 5, 2024'),
              SizedBox(height: 15),
              CategoryTopicCard(title: 'Strength and Humility: A Biblical Balance', summary: 'Understanding how true strength is found in humility...', readtime: '6 min read', date: 'December 1, 2024'),
              SizedBox(height: 15),
              CategoryTopicCard(title: 'Fathers as Spiritual Leaders', summary: 'Practical insights on leading your family with wisdom and...', readtime: '10 min read', date: 'November 28, 2024')
          
            ],
          ),
        )


      ),
          )
        ;
  }
}


class TertiaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String majortopic;
  const TertiaryAppbar({
    super.key,required this.majortopic
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(       
      backgroundColor: Colors.white,
      leading: Icon(Icons.arrow_back),
      title: 
        Text(majortopic,
         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22,fontWeight: FontWeight.w500)),
        centerTitle: false,
      
    );
  }
}

class ExploreAndIcon extends StatelessWidget {
  const ExploreAndIcon
({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF96784B),
                ),                
                child: Icon(Icons.menu_book_rounded,color: Colors.white,),
              ),
            ),
            SizedBox(height: 20),
            Center(
                 child: SizedBox(
                  width: double.infinity,
                   child: Text('Explore our collection of articles and studies on biblical manhood',
                    style: TextStyle(
                      fontSize: 15,
                    ),),
                 ),
               ),
    
            
          ]
              );
  }
}

class CategoryTopicCard extends StatelessWidget {
  final String title;
  final String summary;
  final String readtime;
  final String date;
  
  const CategoryTopicCard({super.key, required this.title, required this.summary, required this.readtime, required this.date});

  @override
  Widget build(BuildContext context) {
    return 
      Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18,18,15,12),
          child: Row(
            spacing: 15,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    ),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.network('https://images.unsplash.com/photo-1764957080878-3f9866270aad?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHw1fHx8ZW58MHx8fHx8',
                    fit: BoxFit.fill,),
                  ),
                ),  
              ),
              Expanded(
                flex: 9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      child: Text(title,
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 6),
                    Container(
                      width: 190,
                      child: Text(summary)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time,size: 16),
                        SizedBox(width: 5),
                        Text(readtime,style: TextStyle(fontSize: 12,color: Colors.grey)),
                        SizedBox(width: 5),
                        Icon(Icons.circle,size: 5,),
                        SizedBox(width: 5),
                        Text(date,style: TextStyle(fontSize: 12,color: Colors.grey),)
                      ],
                    ),
                    
                  ],
                ),
              )
            ],
          ),
        )      
      );    
  }
}