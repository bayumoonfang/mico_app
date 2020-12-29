

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mico_app/helper/page_route.dart';
import 'package:mico_app/helper/session.dart';
import 'package:mico_app/mico_index.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class Appointment extends StatefulWidget{
  @override
  _AppointmentState createState() => _AppointmentState();
}


class _AppointmentState extends State<Appointment> {
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
        Uri.encodeFull("https://mobile.miracle-clinic.com/api_script.php?do=getdata_recentdokter&id="+getPhone.toString()),
        headers: {"Accept":"application/json"}
    );
    setState((){
      data = json.decode(response.body);
    });
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
              Expanded(
                child: _datafield(),
              )
            ],
          )
      ),
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
                                  //_addfavorite(data[i]["a"].toString());
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