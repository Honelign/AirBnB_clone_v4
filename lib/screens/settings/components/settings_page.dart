//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
  String currentcurrency = 'ETB';
  var possiblecurrencies = ['ETB', 'USD'];
  String currentquality = 'HIGH';
  var possiblequalities = ['HIGH', 'MEDIUM','LOW'];

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
  
  String title = 'ETB';
    return Scaffold(
      appBar: AppBar(
        
   
        backgroundColor: const Color(0xFF052C54),
        title: Text('Settings'),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Container(
        width: double.infinity,
        decoration: linearGradientDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'Payment currency',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Choose your preferred currency for purchases',style: TextStyle(color: Colors.white,fontSize: 13),),
              SizedBox(height: 20,),
                 Center(
                   child: Container(
                            decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFD9D9D9).withOpacity(0.7),
                            ),
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.28,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton(
                                dropdownColor: const Color(0xFFD9D9D9),
                                underline: Container(),
                                value: currentcurrency,
                                style: TextStyle(
                                    color: Colors.red,
                                    overflow: TextOverflow.ellipsis),
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                // Array list of items
                                items: possiblecurrencies.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentcurrency = newValue!;
                                  
                                  });
                                },
                              ),
                            ),
                          ),
                 ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Download quality',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Choose your preferred audio quality for downloads',style: TextStyle(color: Colors.white,fontSize: 13)),
              SizedBox(height: 20,),
                Center(
                   child: Container(
                            decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFD9D9D9).withOpacity(0.7),
                            ),
                            height: 30,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButton(
                                dropdownColor:  const Color(0xFFD9D9D9),
                                underline: Container(),
                                value: currentquality,
                                style: TextStyle(
                                    color: Colors.red,
                                    overflow: TextOverflow.ellipsis),
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                // Array list of items
                                items: possiblequalities.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentquality = newValue!;
                                  
                                  });
                                },
                              ),
                            ),
                          ),
                 ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Rate our App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Rate us on Google Play Store or App Store',style: TextStyle(color: Colors.white,fontSize: 13)),
              SizedBox(
                height: 30,
              ),
              Text(
                'Help & Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Contact our team for support',style: TextStyle(color: Colors.white,fontSize: 13)),
              SizedBox(
                height: 30,
              ),
              Text(
                'Terms & Conditions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Read our terms and conditions for usage terms',style: TextStyle(color: Colors.white,fontSize: 13)),
              SizedBox(
                height: 30,
              ),
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              Text('Read our privacy policy',style: TextStyle(color: Colors.white,fontSize: 13)),
              SizedBox(height: 120,),
              Center(
                child: Text(
                  "Version 1.0",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.95),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
