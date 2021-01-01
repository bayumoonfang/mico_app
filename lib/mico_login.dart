

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/mico_loginverifikasi.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => new _LoginState();

}


class _LoginState extends State<Login> {
  //LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, phone;
  final _key = new GlobalKey<FormState>();
  final _phonecontrol = TextEditingController();
  final _emailcontroller = TextEditingController();
  String getMessage, getTextToast;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void verifikasi() async {
    if (_phonecontrol.text.isEmpty && _emailcontroller.text.isEmpty) {
      showToast("Form tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_emailcontroller.text.isEmpty) {
      showToast("Email tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_phonecontrol.text.isEmpty) {
      showToast("Telpon tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    final response = await http.post("https://mobile.miracle-clinic.com/api_script.php?do=act_gettoken",
        body: {"phone": _phonecontrol.text.toString(), "email": _emailcontroller.text.toString()});
    Map showdata = jsonDecode(response.body);
    setState(() {
      getMessage = showdata["message"].toString();
      if (getMessage == '1') {
        showToast("Data anda tidak ditemukan", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else{
        Navigator.push(context, ExitPage(page: VerifikasiLogin(_phonecontrol.text.toString(),
            _emailcontroller.text.toString())));
        return;
      }
    });
    //myFocusNode.requestFocus()}
  }


  void _validateForm() {
    if (_phonecontrol.text.isEmpty && _emailcontroller.text.isEmpty) {
      showToast("Form tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_emailcontroller.text.isEmpty) {
      showToast("Email tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    if (_phonecontrol.text.isEmpty) {
      showToast("Telpon tidak boleh kosong", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        new Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.only(top: 70.0),
          child :
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 30.0),
            child :
            Column(
              children: <Widget> [
                Align(
                    alignment: Alignment.centerLeft,
                    child :
                    Text("Masukkan nomor telpon dan email untuk memulai",textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'VarelaRound',fontSize: 14))),

                Padding(
                    padding: const EdgeInsets.only(top: 20.0)),

                TextFormField(
                  style: TextStyle(
                      fontFamily: 'VarelaRound', fontSize: 17),
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please insert phone number";
                    }
                  },
                  controller: _phonecontrol,
                  maxLength: 13,
                  keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(Icons.phone,color: Colors.black,),
                        hintText: "Nomor Handphone anda",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: HexColor("#602d98"),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: HexColor("#dbd0ea"),
                          width: 1.0,
                        ),
                      ),

                    ),
                ),
                TextFormField(
                  style: TextStyle(
                      fontFamily: 'VarelaRound', fontSize: 18),
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please insert email";
                    }
                  },
                  //validator: _validateEmail,
                  controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    prefixIcon: Icon(Icons.mail,color: Colors.black,),
                    hintText: "Email anda",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: HexColor("#602d98"),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(
                        color: HexColor("#dbd0ea"),
                        width: 1.0,
                      ),
                    ),

                  ),
                )

                ,
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ListTile(
                        title: Text("Dengan mendaftar, saya akan menerima Syarat dan Ketentuan Pengguna yang berlaku di aplikasi mico ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'VarelaRound', fontSize: 12)),
                        subtitle:
                        Padding (
                            padding: const EdgeInsets.only(top:15.0,bottom: 15.0),
                            child :
                            Container(
                                height: 45,
                                width: double.infinity,
                                child :
                            RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                color: HexColor("#602d98"),
                                child: Text(
                                  "Selanjutnya",
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      fontSize: 14.5,
                                      color: Colors.white
                                  ),
                                ),
                                onPressed: () {
                                  verifikasi();
                                }
                              )
                            )
                        ),
                      )
                  ),
                )

              ],
            ),
          ),

        )

    );

  }

}