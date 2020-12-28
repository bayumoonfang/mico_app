

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List data;
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
        Uri.encodeFull("https://duakata-dev.com/miracle/api_script.php?"
            "do=getdata_dokter"),
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
    getData();
  }


  @override
  Widget build(BuildContext context) {
        return WillPopScope(
          child: new Scaffold(
            body:  Container(
                child :
                Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      /* child: Divider(
                              height: 3,
                            ),*/
                    ),
                    Expanded(
                        child :
                        _datafield()
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:10),
                    )
                  ],
                )
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
                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
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
                                CachedNetworkImageProvider("https://duakata-dev.com/miracle/media/photo/"+data[i]["e"],
                                ),
                                backgroundColor: Colors.white,
                                radius: 28,
                              ),
                              title:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  data[i]["b"],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: 'VarelaRound'),
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
                                    ),
                                    data[i]["j"] == 100 ?
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text("Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(decoration: TextDecoration.lineThrough,fontFamily:
                                                'VarelaRound'),),
                                              Padding(
                                                  padding: const EdgeInsets.only(left:10),
                                                  child :
                                                  Text("FREE",
                                                      style: new TextStyle(color: HexColor("#2ECC40"),fontWeight: FontWeight.bold, fontFamily:
                                                      'VarelaRound',)))
                                            ])
                                    )

                                        : (data[i]["j"] != 100 && data[i]["j"] != 0 ) ?
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text("Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(decoration: TextDecoration.lineThrough, fontFamily:
                                                'VarelaRound'),),
                                              Padding(
                                                  padding: const EdgeInsets.only(left:10),
                                                  child :
                                                  Text( "Rp "+
                                                      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"] - data[i]["j"]),
                                                    style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily:
                                                    'VarelaRound'),)),
                                            ]))
                                        :
                                    Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child :
                                        Row(
                                            children: [
                                              Text( "Rp "+
                                                  NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: '').format(data[i]["i"]),
                                                style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily:
                                                'VarelaRound'),),
                                            ])
                                    ),


                                  ]),
                              trailing:

                              data[i]["l"] == getPhone ?
                              Builder(
                                builder: (context) => IconButton(
                                    icon: new Icon(Icons.favorite,color: Colors.red,),
                                    color: Colors.black,
                                    onPressed: () {
                                      //_deletefavorite(data[i]["a"].toString());
                                    }
                                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => DokterSearch())),
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
                                  //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => DokterSearch())),
                                ),
                              )


                          )
                      ),



                      Padding(
                          padding: const EdgeInsets.only(
                              left: 95, right: 15,bottom: 10,top: 10),
                          child: Divider(
                            height: 3.0,
                          )),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 2, bottom: 5),
                      ),
                    ],
                  );
                },
              );
        }
      },
    );
  }



}