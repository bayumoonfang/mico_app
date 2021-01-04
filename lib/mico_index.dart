


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/mico_login.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => new _IndexState();
}

class _IndexState extends State<Index> {
  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                "assets/main_top.png",
                width: size.width * 0.3,
              )
          ),
          Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/main_bottom.png",
                width: size.width * 0.2,
              )
          ),

          Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(opacity: 0.6, child:     Text("SELAMAT DATANG DI MICO", style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Varela",
                        color: Colors.black
                    ),),),
                    SizedBox(height: size.height * 0.03,),
                    SvgPicture.asset("assets/chat.svg",
                    height: size.height * 0.40,),
                    SizedBox(height: size.height * 0.03,),
                    Container(
                        height: 75,
                        width: double.infinity,
                        child :
                        Expanded (
                            child :
                            Padding(
                                padding: const EdgeInsets.only(right: 45.0, left: 45.0, bottom: 15.0, top: 10),
                                child:
                                RaisedButton(
                                    shape: RoundedRectangleBorder(side: BorderSide(
                                        color: Colors.black,
                                        width: 0.1,
                                        style: BorderStyle.solid
                                    ),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    color: HexColor("#602d98"),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        fontFamily: 'VarelaRound',
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, ExitPage(page: Login()));
                                    }
                                )
                            ))),
                    Container(
                      height: 75,
                      width: double.infinity,
                      child :
                    Expanded (
                        child :
                        Padding(
                            padding: const EdgeInsets.only(right: 45.0, left: 45.0, bottom: 15.0, top: 10),
                            child:
                            RaisedButton(
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    color: Colors.black,
                                    width: 0.1,
                                    style: BorderStyle.solid
                                ),
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                color: HexColor("#dbd0ea"),
                                child: Text(
                                  "Daftar",
                                  style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {

                                }
                            )
                        ))),
                  ],
                ),
          )
        ],
      ),
    );
  }
}