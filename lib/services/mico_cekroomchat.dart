




import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mico_app/helper/link_api.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_home.dart';
import 'package:mico_app/mico_index.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:mico_app/services/mico_chatroom.dart';

class CekRoomChat extends StatefulWidget {
  @override
  _CekRoomChatState createState() => new _CekRoomChatState();
}


class _CekRoomChatState extends State<CekRoomChat> {


  String getEmail, getPhone = "";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Index()));
    }
  }

  String cekApp = "";
  _getCekApp() async {
    final response = await http.get(
        applink+"api_script.php?do=getdata_cekapp&id="+getPhone.toString());
    Map data = jsonDecode(response.body);
    setState(() {
      cekApp = data["a"].toString();
    });
  }




  void loadData() async {
    await _session();
    await _getCekApp();
    setState(() {
        if (cekApp == '') {
          Navigator.push(context, EnterPage(page: Home()));
        } else {
          Navigator.pushReplacement(context, ExitPage(page: ChatRoom()));
        }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    //getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }
}