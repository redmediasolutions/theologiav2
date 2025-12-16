import 'package:flutter/material.dart';

class DevotionMenu extends StatelessWidget {
  const DevotionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 65,
        leading:Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back)),
            Icon(Icons.mic_none,color: const Color.fromARGB(255, 215, 166, 105))]),
        title: Text('Theologia: Devotions',
                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
        centerTitle: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 15,
              children: [
                DevotionContainer2(title: 'Endure People', epnumber: 'Ep.021', speaker: 'Joshua Paul', daysago: '23 days ago'),
                DevotionContainer(title: 'Endure Failures', epnumber: 'Ep.021', speaker: 'Joshua Paul', daysago: '23 days ago'),
                DevotionContainer(title: 'You will see the Goodness of God', epnumber: 'Ep.020', speaker: 'Joshua Paul', daysago: 'about a month ago'),
                DevotionContainer(title: 'Jesus will hold you close', epnumber: 'Ep.020', speaker: 'Joshua Paul', daysago: 'about a month ago'),
                DevotionContainer(title: 'God will take care of you', epnumber: 'Ep.018', speaker: 'Joshua Paul', daysago: 'about a month ago'),
                DevotionContainer(title: 'Walk in the Spirit', epnumber: 'Ep.017', speaker: 'Joshua Paul', daysago: 'about a month ago')
              ],
            ),
          ),
        ),
    );
  }
}


class DevotionContainer extends StatelessWidget {
  final String title;
  final String epnumber;
  final String speaker;
  final String daysago;
  const DevotionContainer({super.key, required this.title, required this.epnumber, required this.speaker, required this.daysago});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(255, 197, 17, 229),const Color.fromARGB(255, 118, 77, 239)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
                ),
              borderRadius: BorderRadius.circular(20),
            ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30,25,40,20),
        child: Row(
          children: [
            Column( 
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,           
              children: [
                Text(title,
                       style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18,color: Colors.white)),
                Row(
                    spacing: 10,
                    children: [
                      Text(epnumber,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 12)),
                      Icon(Icons.circle,size:5,color: Colors.white,),
                      Container(
                        width: 60,
                        height: 30,
                        child: Text(speaker,style: TextStyle(color: Colors.white,fontSize: 12))),
                      Icon(Icons.circle,size:5,color: Colors.white),
                      Container(
                        width: 60,
                        child: Text(daysago,style: TextStyle(color: Colors.white,fontSize: 12)))
               ]),
              ]),
              Spacer(),
            
              
              IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow_rounded,color: Colors.white,size: 35),style: IconButton.styleFrom(backgroundColor:Colors.white.withValues(alpha: 0.2),)),
            
          ]
        ),
      )
    );
  }
}

class DevotionContainer2 extends StatelessWidget {
  final String title;
  final String epnumber;
  final String speaker;
  final String daysago;
  const DevotionContainer2({super.key, required this.title, required this.epnumber, required this.speaker, required this.daysago});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 202, 2, 242),
         width:2 ),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          border: Border.all(
            
           color: Colors.white,
           width: 2.5),
                gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 197, 17, 229),const Color.fromARGB(255, 118, 77, 239)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
                  ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(
                  color: Colors.white,
                  blurRadius: 2,
                  spreadRadius: 1,
                )]
              ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30,25,40,20),
          child: Row(
            children: [
              Column( 
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,           
                children: [
                  Text(title,
                         style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18,color: Colors.white)),
                  Row(
                      spacing: 10,
                      children: [
                        Text(epnumber,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w100,fontSize: 12)),
                        Icon(Icons.circle,size:5,color: Colors.white,),
                        Container(
                          width: 60,
                          child: Text(speaker,style: TextStyle(color: Colors.white,fontSize: 12))),
                        Icon(Icons.circle,size:5,color: Colors.white),
                        Container(
                          width: 60,
                          child: Text(daysago,style: TextStyle(color: Colors.white,fontSize: 12)))
                 ]),
                ]),
                Spacer(),
              
                
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.play_arrow_rounded,color: Colors.white,size: 35),style: IconButton.styleFrom(backgroundColor:Colors.white.withValues(alpha: 0.2),)),
                  Positioned(
                    top: -15,
                    child: Container(
                      height: 20,
                      width: 60,
                      decoration: 
                       BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withValues(alpha: 0.2)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,0,0,0),
                        child: Text('Latest',style: TextStyle(color: Colors.white,fontSize: 12)),
                      )),
                  ),
                    
            ]),
            ]
          ),
        )
      ),
    );
  }
}