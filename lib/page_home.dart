



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_index.dart';
import 'package:mico_app/mico_login.dart';
import 'package:mico_app/page_doktor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
      TabController controller;
      String getEmail, getPhone = "";
      _session() async {
        int value = await Session.getValue();
        getEmail = await Session.getEmail();
        getPhone = await Session.getPhone();
        if (value != 1) {
          Navigator.push(context, ExitPage(page: Index()));
        }
      }


      @override
      void initState() {
        super.initState();
        controller = TabController(vsync: this, length: 3);
        _session();
      }

        @override
        Widget build(BuildContext context) {
              return Scaffold(
                  appBar: new AppBar(
                    backgroundColor: HexColor("#602d98"),
                    automaticallyImplyLeading: false,
                    actions: [
                      Padding(padding: const EdgeInsets.only(top: 19,right: 35), child :
                          FaIcon(FontAwesomeIcons.search, size: 18,)),
                      Padding(padding: const EdgeInsets.only(top: 19,right: 25), child :
                      FaIcon(FontAwesomeIcons.heart, size: 18,)),
                    ],
                    title:
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child:   Text("Mico", style: TextStyle(color: Colors.white,
                          fontFamily: 'VarelaRound', fontSize: 24,
                          fontWeight: FontWeight.bold),)
                    ),
                    elevation: 0.5,
                    centerTitle: false,
                    bottom: TabBar(
                      controller: controller,
                      labelStyle: TextStyle(fontFamily: 'VarelaRound'),
                      unselectedLabelColor: HexColor("#c0c0c0"),
                      labelColor: Colors.white,
                      indicatorWeight: 2,
                      indicatorColor: Colors.white,
                      tabs: <Tab>[
                        Tab(text: "Available"),
                        Tab(text: "On Going",),
                        Tab(text: "History",)
                      ],
                    ),
                  ),
                body:
                TabBarView(
                  controller: controller,
                  children: <Widget>[
                    DoktorList(),
                    Login(),
                    Login()
                    //ChatHistory(getPhoneState),
                    //VideoHistory(getPhoneState)
                  ],
                ),
              );

        }


}