import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/mico_login.dart';
import 'package:mico_app/mico_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;



class VerifikasiLogin extends StatefulWidget{
  final String phone, email;
  const VerifikasiLogin(this.phone, this.email);

  _VerifikasiLoginState createState() => new _VerifikasiLoginState(
      getPhone : this.phone,
      getEmail : this.email
  );
}

enum LoginStatus { notSignIn, signIn }

class _VerifikasiLoginState extends State<VerifikasiLogin> {
  String getPhone, getEmail;
  int getVal;
  final _tokenVal = TextEditingController();

  _VerifikasiLoginState({this.getPhone, this.getEmail});
  //LoginStatus _loginStatus = LoginStatus.notSignIn;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  login() async {

    if (_tokenVal.text.length < 6) {
      showToast("Token harus 6 angka", gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }
    final response = await http.post("https://mobile.miracle-clinic.com/api_script.php?do=act_ceklogin",
        body: {"phone": getPhone, "email": getEmail, "token": _tokenVal.text});
    Map data = jsonDecode(response.body);
    setState(() {
      int getValue = data["value"];
      String getIDcust = data["idcust"].toString();
      String getAccnumber = getPhone;

      if (getValue == 1) {
        savePref(getValue, getPhone, getEmail, getIDcust, getAccnumber);
        Navigator.push(context, ExitPage(page: Home()));
      } else {
        showToast(getValue.toString(), gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }
      //_loginStatus = LoginStatus.signIn;
      //savePref(value, getPhone, getEmail);
      //Navigator.of(context)
      //.push(new MaterialPageRoute(builder: (BuildContext context) => Home()));
    });
  }

  savePref(int value, String phone, String email, String idcustomer, String getAccnumber) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("phone", getPhone);
      preferences.setString("email", getEmail);
      preferences.setString("idcustomer", idcustomer);
      preferences.setString("accnumber", getAccnumber);
      preferences.setString("basedlogin", "user");
      preferences.commit();
    });
  }

  Future<bool> _onWillPop() async {

  }


  @override
  Widget build(BuildContext context) {
    return new  WillPopScope(
      onWillPop: _onWillPop,
        child: new
        Scaffold(
            body :(
                Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.only(top: 70.0),
                    child :
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                      child :
                      Column(
                        children: <Widget> [
                          ListTile(
                            leading:
                            Container(
                              height: 100,
                              child :
                              RawMaterialButton(
                                onPressed: () {},
                                elevation: 2.0,
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.shield,
                                  color: HexColor("#602d98"),
                                  size: 30.0,
                                ),
                                padding: EdgeInsets.all(10.0),
                                shape: CircleBorder(
                                  side: BorderSide(color: HexColor("#602d98"), width: 1)
                                ),
                              ),
                            ),
                            title: Text("Masukkan 6 angka kode yang telah dikirimkan ke "
                                "email", style: TextStyle(
                                fontFamily: 'VarelaRound',fontSize: 15,)),
                            subtitle: Text(getEmail, style: TextStyle(
                                fontFamily: 'VarelaRound',fontSize: 14)),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top:100.0),
                              child :
                              Container(
                                  width: 170.0,
                                  child :
                                  TextFormField(
                                    maxLength: 6,
                                    style: TextStyle(fontSize: 38,letterSpacing: 5.0),
                                    textAlign: TextAlign.center,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        counterText: ''
                                    ),
                                    keyboardType: TextInputType.number,
                                    controller: _tokenVal,
                                  ))
                          ),

                          Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: ListTile(
                                  title:
                                  Padding (
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child :
                                      Container(
                                          height: 45,
                                          child :
                                      RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50.0),
                                          ),
                                          color: HexColor("#602d98"),
                                          child: Text(
                                            "Verifikasi",
                                            style: TextStyle(

                                                fontFamily: 'VarelaRound',
                                                fontSize: 14,
                                                color: Colors.white
                                            ),
                                          ),
                                          onPressed: () {
                                            login();
                                          }

                                      ))
                                  ),
                                  subtitle:
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                                      child :
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget> [
                                        Text("Salah nomor telpon ?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'VarelaRound', fontSize: 14)),
                                        Padding (
                                            padding: const EdgeInsets.only(left: 10),
                                            child: InkWell(
                                              child: Text("Ganti Nomor",    style: TextStyle(
                                                  fontFamily: 'VarelaRound', fontSize: 14, fontWeight: FontWeight.bold,color: Colors.black)),
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                            ) ,
                                        ),
                                      ])),
                                )
                            ),
                          )


                        ],
                      ),

                    )
                )
            )
        )

    );
  }

}