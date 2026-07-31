import 'package:flutter/material.dart';

void main() {
  runApp(const E7POTALogger());
}

class E7POTALogger extends StatelessWidget {
  const E7POTALogger({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E7POTA Logger',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const QSOPage(),
    );
  }
}


class QSOPage extends StatefulWidget {
  const QSOPage({super.key});

  @override
  State<QSOPage> createState() => _QSOPageState();
}


class _QSOPageState extends State<QSOPage> {

  final callsign = TextEditingController();
  final myRef = TextEditingController();
  final p2pRef = TextEditingController();
  final notes = TextEditingController();

  String band = "20m";
  String mode = "SSB";

  bool park2park = false;


  final bands = [
    "160m",
    "80m",
    "40m",
    "30m",
    "20m",
    "17m",
    "15m",
    "12m",
    "10m",
    "6m",
    "2m"
  ];


  final modes = [
    "SSB",
    "CW",
    "FT8",
    "FM",
    "DIGI"
  ];


  void saveQSO(){

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Saved: ${callsign.text} ${band} ${mode}"
        ),
      )
    );

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

    appBar: AppBar(
  title: Row(
    children: [

      Image.asset(
        'assets/e7pota_logo.png',
        height: 45,
      ),

      const SizedBox(width: 10),

      const Expanded(
        child: Text(
          "E7POTA LOGGER 📻",
          overflow: TextOverflow.ellipsis,
        ),
      ),

    ],
  ),
),


      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),


        child: Column(

          children: [


            const Text(
              "Operator: E75HZ",
              style: TextStyle(
                fontSize:22,
                fontWeight: FontWeight.bold
              ),
            ),


            const SizedBox(height:20),


            TextField(
              controller:callsign,
              decoration: const InputDecoration(
                labelText:"CALLSIGN",
                border:OutlineInputBorder(),
              ),
            ),


            const SizedBox(height:15),


            DropdownButtonFormField(
              value:band,
              decoration: const InputDecoration(
                labelText:"BAND",
                border:OutlineInputBorder(),
              ),

              items: bands.map((b){

                return DropdownMenuItem(
                  value:b,
                  child:Text(b),
                );

              }).toList(),

              onChanged:(value){

                setState(() {
                  band=value!;
                });

              },

            ),


            const SizedBox(height:15),


            DropdownButtonFormField(
              value:mode,

              decoration: const InputDecoration(
                labelText:"MODE",
                border:OutlineInputBorder(),
              ),


              items:modes.map((m){

                return DropdownMenuItem(
                  value:m,
                  child:Text(m),
                );

              }).toList(),


              onChanged:(value){

                setState(() {
                  mode=value!;
                });

              },

            ),



            const SizedBox(height:15),


            TextField(
              controller:myRef,

              decoration:const InputDecoration(
                labelText:"MY POTA REFERENCE",
                hintText:"BA-0145",
                border:OutlineInputBorder(),
              ),

            ),



            CheckboxListTile(

              title:const Text(
                "Park2Park"
              ),

              value:park2park,

              onChanged:(value){

                setState(() {
                  park2park=value!;
                });

              },

            ),



            if(park2park)

            TextField(

              controller:p2pRef,

              decoration:const InputDecoration(

                labelText:
                "CORRESPONDENT POTA REFERENCE",

                hintText:
                "DL-1234",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:15),



            TextField(

              controller:notes,

              maxLines:3,

              decoration:const InputDecoration(

                labelText:"NOTES",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:25),



            SizedBox(

              width:double.infinity,

              child:ElevatedButton(

                onPressed:saveQSO,

                child:const Text(
                  "SAVE QSO"
                ),

              ),

            )


          ],

        ),

      ),

    );

  }

}