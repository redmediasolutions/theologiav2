import 'package:flutter/material.dart';
import 'package:theologia_app_1/articlepage/articlepage.dart';

class SearchPage extends StatelessWidget implements PreferredSizeWidget {
  const SearchPage({super.key});

  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
 
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
                       hintText: 'Search articles, topics, categories...',
                       backgroundColor: WidgetStatePropertyAll(Colors.white),
                       shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15))),),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 20), 

              //Recent Searches  
              Row(
                children: [
                  Icon(Icons.access_time,color: Colors.grey,size: 18),
                  SizedBox(width: 10),
                  Text('Recent Searches',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w500)) ]),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SuggestionButton(topic: 'Grace'),
                      SizedBox(width: 10),
                      SuggestionButton(topic: 'Holy Spirit')]),
                      SizedBox(height: 10),
                  SuggestionButton(topic: 'Biblical Manhood'),
                  SizedBox(height: 30),

                  //Trending Topics
                  Row(
                    children: [
                      Icon(Icons.trending_up,color: const Color.fromARGB(255, 100, 46, 26),),
                      SizedBox(width: 10),
                      Text('Trending Topics',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w500))]),
                  SizedBox(height: 15),
                  Row(
                    spacing: 10,
                    children: [
                      SuggestionButton2(topic: 'Holy Spirit'),
                      SuggestionButton2(topic: 'Grace'),
                      SuggestionButton2(topic: 'Faith')]),
                      SizedBox(height: 15),
                  Row(
                    spacing:10,
                    children:[
                    SuggestionButton2(topic: 'Prayer'),
                    SuggestionButton2(topic: 'Salvation'),
                    SuggestionButton2(topic: 'Trinity')]),
                    SizedBox(height: 20),

                  //Popular Articles
                  Text('Popular Articles',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 15,fontWeight: FontWeight.w500)) ,
                  Column(
                    spacing: 6,
                    children: [
                      Articles(type: 'Theology', topic: 'The Relevance of God\'s Grace in Our Life', time: '7 min read'),
                      Articles(type: 'Decoding Pentecostalism', topic: 'Understanding the Gifts of the Spirit', time: '11 min read'),
                      Articles(type: 'Biblical Manhood', topic: 'The Role of Men in Christian Leadership',time: '8 min read')]),
          
        
            ],
          )),
        ),
      )
      
    );
  }
}



class SuggestionButton2 extends StatelessWidget {
  final String topic;
  const SuggestionButton2({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){},
    style: ButtonStyle(backgroundColor:WidgetStatePropertyAll(Color(0xFFEFEBE6)),
    side: WidgetStatePropertyAll(const BorderSide(color: Color.fromARGB(255, 231, 212, 205))),
     elevation: WidgetStatePropertyAll(0),
     shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius:BorderRadiusGeometry.circular(20)))),
     child: Padding(
       padding: const EdgeInsets.fromLTRB(0,10,0,10),
       child: Text(topic,
       style: TextStyle(
        color: Colors.black,
        fontSize: 13
       ),),
     )
     );
  }
}

class SuggestionButton extends StatelessWidget {
  final String topic;
  const SuggestionButton({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){},
    style: ButtonStyle(backgroundColor:WidgetStatePropertyAll(Colors.white,),
    side: WidgetStatePropertyAll(const BorderSide(color: Color.fromARGB(255, 219, 218, 218))),
     elevation: WidgetStatePropertyAll(0)),
     child: Padding(
       padding: const EdgeInsets.fromLTRB(0,10,0,10),
       child: Text(topic,
       style: TextStyle(
        color: Colors.black,
        fontSize: 13
       ),),
     )
     );
  }
}