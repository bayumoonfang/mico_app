

import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_index.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;


class DoktorList extends StatefulWidget {
  @override
  _DoktorListState createState() => new _DoktorListState();
}



class _DoktorListState extends State<DoktorList> {
  List data, data2;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }


  String getEmail, getPhone = "";
  _session() async {
    int value = await Session.getValue();
    getEmail = await Session.getEmail();
    getPhone = await Session.getPhone();
    if (value != 1) {
      Navigator.push(context, ExitPage(page: Index()));
    }
  }


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://mobile.miracle-clinic.com/api_script.php?do=getdata_dokter"),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }


  Future<List> getDataRecent() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://mobile.miracle-clinic.com/api_script.php?do=getdata_recentdokter&id="+getPhone.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data2 = json.decode(response.body);
    });
  }




  void _addfavorite(String iddokter) {
    var url = "https://mobile.miracle-clinic.com/api_script.php?do=action_addfavorite";
    http.post(url,
        body: {
          "iduser": getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil ditambahkan", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }

  void _deletefavorite(String iddokter) {
    var url = "https://mobile.miracle-clinic.com/api_script.php?do=action_deletefavorite";
    http.post(url,
        body: {
          "iduser": getPhone,
          "iddokter" : iddokter
        });
    showToast("Favorite berhasil dihapus", gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
    return;
  }



  @override
  void initState() {
    super.initState();
    _session();
    //getData();
  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          child: new Scaffold(
            body:  Column(
              children: [

                _datarecent(),
                Expanded(
                  child: _datafield(),
                )
              ],
            )
          ),
        );
  }

  Widget _datarecent() {
    return FutureBuilder<List>(
      future: getDataRecent(),
      builder: (context, snapshot) {
        if (data2 == null || data2.isEmpty) {
          return Container(width: 0,height: 0,);
        } else {
           return  Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
                child:
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Recent Appointment",
                      style: TextStyle(color: Colors.black,
                          fontFamily: 'VarelaRound', fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),),
              Container(
                height: 85,
                child:
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(top: 5, left: 15),
                  itemCount: data2 == null ? 0 : data2.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 5), child:
                    Column(
                      children: [
                        CircleAvatar(
                            radius: 30,
                            backgroundColor: HexColor("#602d98"),
                            child:
                            CircleAvatar(
                              backgroundImage:
                              data2[i]["e"] == '' ? AssetImage(
                                  "assets/mira-ico.png") :
                              CachedNetworkImageProvider(
                                "https://mobile.miracle-clinic.com/media/photo/" +
                                    data2[i]["e"],
                              ),
                              backgroundColor: Colors.white,
                              radius: 29,
                            )),
                        Container(
                          width: 75,
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            data2[i]["b"], style: TextStyle(color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'VarelaRound',),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,),
                        )
                      ],
                    ),)
                    ;
                  },
                ),
              ),
              Padding(padding: const EdgeInsets.only(top: 5),
                child: Divider(height: 5,),)
            ],
          );
        }
      },
    );
  }


  Widget _datafield() {
    return FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
        if (data == null) {
          return Center(
              child: Image.asset(
                "assets/loadingq.gif",
                width: 110.0,
              )
          );
        } else {
          return data.isEmpty ?
            Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Dokter tidak ditemukan",
                      style: new TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 20),
                    ),
                    new Text(
                      "Silahkan coba beberapa saat lagi..",
                      style: new TextStyle(
                          fontFamily: 'VarelaRound', fontSize: 16),
                    ),
                  ],
                ))
              :
                ListView.builder(
                padding: const EdgeInsets.only(top: 5,bottom: 80),
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                           /* Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => Pembayaran(
                                        data[i]["f"],
                                        widget.namaklinik,
                                        data[i]["b"])));*/
                          },
                          child:

                          data[i]["g"] == 'Offline' ?
                              Opacity (
                                opacity: 0.3,
                                child :
                                ListTile(
                                    leading:
                                    CircleAvatar(
                                      backgroundImage:
                                      data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                                      CachedNetworkImageProvider("https://mobile.miracle-clinic.com/media/photo/"+data[i]["e"],
                                      ),
                                      backgroundColor: Colors.white,
                                      radius: 28,
                                    ),
                                    title:  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        data[i]["b"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'VarelaRound'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    subtitle:  Column(
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  2.0)
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.bottomLeft,
                                            child: Text(
                                                data[i]["c"],
                                                style: TextStyle(
                                                    fontFamily:
                                                    'VarelaRound')),
                                          )
                                        ]
                                    ),
                                    trailing:
                                    data[i]["l"] == getPhone ?
                                    Builder(
                                      builder: (context) => IconButton(
                                          icon: new Icon(Icons.favorite,color: Colors.red,),
                                          color: Colors.black,
                                          onPressed: () {
                                           // _deletefavorite(data[i]["a"].toString());
                                          }
                                      ),
                                    )
                                        :
                                    Builder(
                                      builder: (context) => IconButton(
                                          icon: new Icon(Icons.favorite_border_outlined),
                                          color: Colors.black,
                                          onPressed: () {
                                            //(data[i]["a"].toString());
                                          }
                                      ),
                                    )
                                )
                              )
                          :
                            ListTile(
                              leading:
                                  CircleAvatar(
                                    backgroundImage:
                                    data[i]["e"] == '' ? AssetImage("assets/mira-ico.png") :
                                    CachedNetworkImageProvider("https://mobile.miracle-clinic.com/media/photo/"+data[i]["e"],
                                    ),
                                    backgroundColor: Colors.white,
                                    radius: 28,
                                  ),
                              title:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data[i]["b"],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'VarelaRound'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            subtitle:  Column(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                        const EdgeInsets.all(
                                            2.0)
                                    ),
                                    Align(
                                      alignment:
                                      Alignment.bottomLeft,
                                      child: Text(
                                          data[i]["c"],
                                          style: TextStyle(
                                              fontFamily:
                                              'VarelaRound')),
                                    )
                                  ]
                            ),
                              trailing:
                              data[i]["l"] == getPhone ?
                              Builder(
                                builder: (context) => IconButton(
                                    icon: new Icon(Icons.favorite,color: Colors.red,),
                                    color: Colors.black,
                                    onPressed: () {
                                      _deletefavorite(data[i]["a"].toString());
                                    }
                                ),
                              )
                                  :
                              Builder(
                                builder: (context) => IconButton(
                                    icon: new Icon(Icons.favorite_border_outlined),
                                    color: Colors.black,
                                    onPressed: () {
                                      _addfavorite(data[i]["a"].toString());
                                    }
                                ),
                              )
                          )



                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 95, right: 15,bottom: 0),
                          child: Divider(
                            height: 3.0,
                          )),
                  /*    Container(
                        margin: const EdgeInsets.only(
                            top: 0, bottom: 0),
                      ),*/
                    ],
                  );
                },
              );
        }
      },
    );
  }



}