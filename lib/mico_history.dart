


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_index.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';



class History extends StatefulWidget {
  @override
  _HistoryState createState() => new _HistoryState();
}


class _HistoryState extends State<History> with AutomaticKeepAliveClientMixin<History> {
  @override
  bool get wantKeepAlive => true;
  List data;
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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


  Future<List> getData() async {
    http.Response response = await http.get(
        Uri.encodeFull("https://mobile.miracle-clinic.com/api_script.php?do=getdata_recentdokter3&id="+getPhone.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
  }


  Future getData2() async {
    data.clear();
    await Future.delayed(Duration(seconds: 2));
    getData();
  }

  @override
  void initState() {
    super.initState();
    _session();
    //getData();
  }

  @override
  Widget build(BuildContext context) {
    return
      RefreshIndicator(
          onRefresh: getData2,
          child :
          WillPopScope(
            child: new Scaffold(
                body:  Column(
                  children: [
                    Expanded(
                      child: _datafield(),
                    )
                  ],
                )
            ),
          ));

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
          Container()
              : data == null ?
          Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Tidak Ada Appointment",
                    style: new TextStyle(
                        fontFamily: 'VarelaRound', fontSize: 20),
                  ),
                  new Text(
                    "Silahkan melakukan appointment..",
                    style: new TextStyle(
                        fontFamily: 'VarelaRound', fontSize: 16),
                  ),
                ],
              ))
              :
          ListView.builder(
            padding: const EdgeInsets.only(top: 15,bottom: 80),
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
                                      data[i]["k"]+ " - "+ new DateFormat.MMM().format(DateTime.parse(data[i]["l"]))
                                          + " - "+ data[i]["i"] + " | " +data[i]["n"],
                                      style: TextStyle(
                                          fontFamily:
                                          'VarelaRound',
                                          color: Colors.black)),
                                ),
                                Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        2.0)
                                ),
                                Align(
                                  alignment:
                                  Alignment.bottomLeft,
                                  child: Text(
                                      data[i]["m"]+ " Konsultasi",
                                      style: TextStyle(
                                          fontFamily:
                                          'VarelaRound',
                                          fontSize: 12,
                                          color: Colors.black)),
                                )
                              ]
                          ),
                          trailing:
                              data[i]["d"] == 'DECLINE' ?
                              Container(
                                height: 30,
                                child: RaisedButton(
                                  elevation: 0,
                                  color: HexColor("#ef6352"),
                                  child: Text("Batal",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: HexColor("#ffffff")
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  onPressed: ()async {
                                  },
                                ),
                              )
                                  : data[i]["d"] == "DONE" ?
                              Container(
                                height: 30,
                                child: RaisedButton(
                                  elevation: 0,
                                  color: HexColor("#00b24e"),
                                  child: Text("Selesai",
                                      style: TextStyle(
                                          fontFamily: 'VarelaRound',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: HexColor("#ffffff")
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  onPressed: ()async {
                                  },
                                ),
                              )
                                  :
                                  Container()

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