


import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_index.dart';
import 'package:mico_app/services/mico_videoroom.dart';

class CekRoomVideo extends StatefulWidget {
  @override
  _CekRoomVideoState createState() => new _CekRoomVideoState();
}

class _CekRoomVideoState extends State<CekRoomVideo> {


  Future<bool> _onWillPop() async {
    //Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
  }


  String getEmail, getPhone = "";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    if (value != 1) {
      Navigator.pushReplacement(context, ExitPage(page: Index()));
    }
  }


  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.pushReplacement(context, ExitPage(page: VideoRoom()));
    });
  }

  @override
  void initState() {
    super.initState();
    _session();
    startSplashScreen();
  }


  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: _onWillPop,
     child: Scaffold(
       body: Container(
         height: double.infinity,
         width: double.infinity,
         color: Colors.white,
         child:             Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             SizedBox(
                 width: 50, height: 50, child: CircularProgressIndicator()),
             Padding(padding: const EdgeInsets.all(25.0)),
             Text(
               "Menyiapkan room konsultasi anda...",
               style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
             ),
             Padding(
               padding: const EdgeInsets.only(top:2),
               child:
               Text(
                 "Mohon menunggu sebentar",
                 style: TextStyle(fontFamily: 'VarelaRound', fontSize: 13),
               ),
             )
           ],
         ),
       ),
     ),
   );

  }
}