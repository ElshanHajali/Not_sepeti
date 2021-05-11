import 'package:flutter/material.dart';
import 'package:flutter_proje_not_sepeti/models/kategory.dart';
import 'package:flutter_proje_not_sepeti/utils/database_helper.dart';
import 'package:flutter_proje_not_sepeti/utils/notlar.dart';

class NotDetay extends StatefulWidget {
  String baslik;
  NotDetay({this.baslik});

  @override
  _NotDetayState createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  List<Kategory> tumKategoriler;
  DatabaseHelper databaseHelper;
  int katogoryID = 1;
  int secilenOncelik = 0;
  String notBaslik, notIcerik;
  static var _oncelik = ["Dusuk", "Orta", "Yuksek"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategory>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoryleriIcerenMapListesi) {
      for (Map okunanMap in kategoryleriIcerenMapListesi) {
        tumKategoriler.add(Kategory.fromMap(okunanMap));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.baslik),
      ),
      body: tumKategoriler.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Kategory",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              items: kategoryItemleriOlustur(),
                              value: katogoryID,
                              onChanged: (secilenKategoryID) {
                                setState(() {
                                  katogoryID = secilenKategoryID;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (text) {
                          if (text.length < 0) {
                            return "En az 3 karakter olmali";
                          }
                        },
                        onSaved: (text) {
                          notBaslik = text;
                        },
                        decoration: InputDecoration(
                            hintText: "Not basligini girin",
                            labelText: "Baslik",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (text) {
                          notIcerik = text;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                            hintText: "Not icerigini girin",
                            labelText: "Icerik",
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Oncelik",
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              items: _oncelik.map((oncelik) {
                                return DropdownMenuItem<int>(
                                    child: Text(
                                      oncelik,
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    value: _oncelik.indexOf(oncelik));
                              }).toList(),
                              value: secilenOncelik,
                              onChanged: (secilenOncelikID) {
                                setState(() {
                                  secilenOncelik = secilenOncelikID;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Vazgec",
                            style: TextStyle(color: Colors.white70),
                          ),
                          color: Colors.brown,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              var indi = DateTime.now();

                              databaseHelper
                                  .notEkle(Not(katogoryID, notBaslik, notIcerik,
                                      indi.toString(), secilenOncelik))
                                  .then((kaydedilenNotID) {
                                print("Indi : ${indi.toString}");
                                print("Method isledi : " +
                                    databaseHelper.dataFormat(indi));
                                if (kaydedilenNotID != 0) {
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: Text(
                            "Kaydet",
                            style: TextStyle(color: Colors.white70),
                          ),
                          color: Colors.deepPurpleAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  List<DropdownMenuItem<int>> kategoryItemleriOlustur() {
    return tumKategoriler
        .map((kategory) => DropdownMenuItem<int>(
              value: kategory.katogoryID,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  kategory.kategoryBaslik,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ))
        .toList();
  }
}
/*Form(
        key: formKey,
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                child: DropdownButtonHideUnderline(
                  child: tumKategoriler.length <= 0
                      ? CircularProgressIndicator()
                      : Container(
                          child: DropdownButton<int>(
                              items: kategoryItemleriOlustur(),
                              value: katogoryID,
                              onChanged: (secilenKategoryID) {
                                setState(() {
                                  katogoryID = secilenKategoryID;
                                });
                              }),
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                          margin: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      )*/
