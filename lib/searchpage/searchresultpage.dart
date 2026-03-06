import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlepage.dart';

class SearchResultsPage extends StatelessWidget implements PreferredSizeWidget {
  const SearchResultsPage({super.key});

  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                       leading: Icon(Icons.search,color: Colors.grey,),
                       elevation: WidgetStatePropertyAll(0),
                       hintText: 'Search articles, topics, categories...',
                       backgroundColor: WidgetStatePropertyAll(Colors.white),
                       shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))),),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 20), 
              Text('1 result found',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w500)),
              //Articles
              ArticlesWithPic(type: 'Theology', topic: 'The Relevance of God\'s Grace in Our Life', time: '7min read'    )   
              
        
            ],
          )),
        ),
      )
      
    );
  }
}


class ArticlesWithPic extends StatelessWidget {
  final String type;
  final String topic;
  final String time;
  const ArticlesWithPic({super.key, required this.type, required this.topic, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              height: 90,
               width: 90,
               
              child: 
               ClipRRect(
                borderRadius: BorderRadius.circular(50) ,
                child: Image.network('https://images.unsplash.com/photo-1509021436665-8f07dbf5bf1d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YmlibGV8ZW58MHx8MHx8fDA%3D'),
               ) ),
               SizedBox(width: 15),
            Column(
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
          ],
        ),
      )
    );
  }
}