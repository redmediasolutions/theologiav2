import 'package:flutter/material.dart';
import 'package:theologia_app_1/components/globalscaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Globalscaffold(
        title: 'Theologia',
        body:SingleChildScrollView(
          child: 
        
        Padding(padding: EdgeInsetsGeometry.all(20),
        child:
        Column(
          children: [      
            // LISTEN TO DEVOTIONS   
           Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 197, 17, 229),const Color.fromARGB(255, 118, 77, 239)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
                ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30,vertical: 25),
            height: 140,
            width: double.infinity,
          
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [                 
                    Text('Daily Audio',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,color: Colors.white),),
                    Text('Listen to ',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 25,color: Colors.white),),
                     Text('Devotions',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 25,color: Colors.white),)
                     
                  ],
                ),
                Spacer(),
                IconButton(onPressed:(){},
                 iconSize: 70,
                 icon: Icon( Icons.play_circle                  
                 ),
                 color: Colors.white,
                 )

              ],
            ),
           ),
           SizedBox(height: 40),
           Row(
            children: [
              Icon(Icons.menu_book_rounded,
               color: Colors.brown),
               SizedBox(width: 10),
              Text('Featured Article',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.arrow_right_outlined)              
            ],
           ),
           SizedBox(height: 20),
           Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(20),
              child: 
              Stack(
               children: [
              Image.network('https://images.unsplash.com/photo-1533000971552-6a962ff0b9f9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YmlibGV8ZW58MHx8MHx8fDA%3D',
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: 
                  Text('The Relevance of God\'s Grace in Our Life',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20,color: Colors.white),
                     )
                          )            ]
            )
            )

            ),
           SizedBox(height: 20),

           Row(
            children: [
              Icon(Icons.grid_3x3_rounded,color: Colors.brown,),
              SizedBox(width: 10),
              Text('Categories',
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_right_outlined)
            ],
           ),
           SizedBox(height: 20),
           Row(
            children: [
              categories_button(topic: 'Biblical Manhood'),
              SizedBox(width: 20),
              categories_button(topic: 'Book Studies'),
              SizedBox(width:20),
              categories_button(topic: 'Decoding Pentacostalism',)

            ],
           ),
           SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.question_mark,
               color: Colors.brown),
               SizedBox(width: 10),
              Text('Questions',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.arrow_right_outlined)              
            ],
           ),
           SizedBox(height: 15),
           questions_container(
            title: 'What is the indwelling of the Holy Spirit?', description: 'The indwelling of the Holy Spirit can be defined as ...'),
           SizedBox(height: 15),
           questions_container(title: 'What is the infilling of the Holy Spirit?', description: 'Being filled with the holy spirit implies granting Him the ...'),
           SizedBox(height: 15),
           questions_container(title: 'Who is the Holy Spirit?', description: 'Third Member of Trinity'),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.headphones_outlined,
               color: Colors.brown),
               SizedBox(width: 10),
              Text('Recent Devotions',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 16,fontWeight: FontWeight.w500)),
              Spacer(),
              Icon(Icons.arrow_right_outlined)              
            ],
           ),
          SizedBox(height: 20),
          recent_devotions(titler: 'When I am afraid', descriptionr: 'In God I trust, and I\'m not afraid. What can ...', date: 'November 17,2023',),
          SizedBox(height: 20),
          recent_devotions(titler: 'When we are broken', descriptionr: 'You will be healed and restored', date: 'November 16,2023'),
          SizedBox(height: 20),
          recent_devotions(titler: 'The Relevance of God\'s Grace in Our Life', descriptionr: 'Grace [gra]- elegance and beauty of ...', date: 'November 15,2023')
   




          ],
        )
        )
        )
           
           
        );

  }
}

class categories_button extends StatelessWidget {
  final String topic;
  const categories_button({
    super.key, required this.topic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment:AlignmentGeometry.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 208, 170, 121)
                ),
                height: 100,
                width: 100,
              ),
              IconButton.filled(
                    color: Color.fromARGB(255, 194, 161, 118),
                    onPressed: (){}, 
                    padding: EdgeInsets.all(10),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.white),),
                  icon: Icon(Icons.menu_book) ),
                   //Icon(Icons.menu_book,color: Colors.brown)),
              SizedBox(height: 5),
                            ],
          ),
          SizedBox(height: 3),
          Text(topic,
           style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize:13,color:  Colors.black),)
          
        ],
      ),
    );
  }
}

class questions_container extends StatelessWidget {
 final String title;
 final String description;
 
  const questions_container({
    super.key, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 236, 236, 236)),
        borderRadius: BorderRadius.circular(10)
      ),
      height: 70,
      width: double.infinity,
      child:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(title,
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w600)),
               SizedBox(height: 3),
           Text(description,
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14)),
           
         ],
       ),
    );
  }
}


class recent_devotions extends StatelessWidget {
 final String titler;
 final String descriptionr;
 final String date;
 
  const recent_devotions({
    super.key, required this.titler, required this.descriptionr,required this.date
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 236, 236, 236)),
        borderRadius: BorderRadius.circular(10)
      ),
      height: 90,
      width: double.infinity,
      child:
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(titler,
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w600)),
               SizedBox(height: 3),
           Text(descriptionr,
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 14)),
               SizedBox(height: 3),
               Text(date,
               style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 13,color: Colors.grey))
           
           
         ],
       ),
    );
  }
}