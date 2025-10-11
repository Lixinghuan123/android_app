import 'package:flutter/material.dart';
import 'package:my_flutter_app/styled_body_text.dart';
import 'package:my_flutter_app/styled_button.dart';

class CoffeePrefs extends StatefulWidget {
  const CoffeePrefs({super.key});

  @override
  State<CoffeePrefs> createState() => _CoffeePrefsState();
}
int strength=1;
int sugar=1;
class _CoffeePrefsState extends State<CoffeePrefs> {
   void increaseStrength(){
    setState(() {
       strength=strength<5?strength+1:1;
    });
   
  }

  void increaseSugar(){
    setState(() {
      sugar=sugar<5?sugar+1:0;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Strength:'),
             Text('$strength'),
             for(int i=0;i<strength;i++)
              Image.asset('assets/img/阿莫西林.jpg',
              width: 25,),
            Expanded(child:  SizedBox()),
            StyledButton(     
              onPressed: increaseStrength,
            child: const Text('+')
            ),
            
          ],
        ),
        Row(
          children: [
            const StyledBodyText('Sugars:'),
             Text('$sugar'),
             if(sugar==0)
              const StyledBodyText('No sugar...'),
             for(int i=0;i<sugar;i++)
              Image.asset('assets/img/双黄连.jpg',
              width: 25,),
            Expanded(child:  SizedBox()),
            StyledButton(
              
              onPressed: increaseSugar,
            child: const Text('+'))
           
          ],
        )
      ],
    );
  }
}