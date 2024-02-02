import 'package:flutter/material.dart';

class ComingSoon extends StatefulWidget {
  const ComingSoon({super.key});

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Comeing", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Colors.blue),)
              ,Text(" Soon..", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, color: Colors.black),)
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Made By", style: TextStyle(fontSize: 15, color: Colors.black),),
              Text(" DaalBati+Rayta YuvaaMandal", style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold))
            ],)
        ],
      ),
    );
  }
}
