import 'package:flutter/material.dart';
import 'package:flutter_proje_not_sepeti/models/kategory.dart';
import 'package:flutter_proje_not_sepeti/not_detay.dart';
import 'package:flutter_proje_not_sepeti/utils/database_helper.dart';
import 'package:flutter_proje_not_sepeti/utils/notlar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotListesi(),
    );
  }
}

class NotListesi extends StatelessWidget {
  //const NotListesi({Key key}) : super(key: key);
  DatabaseHelper databaseHelper = DatabaseHelper();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Center(child: Text("Not sepeti"))),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              kategoryEkleDialog(context);
            },
            tooltip: "Kategory Ekle",
            heroTag: "Kategory Ekle",
            child: Icon(Icons.add_circle),
            mini: true,
          ),
          FloatingActionButton(
            onPressed: () => _detaySayfasinaGit(context),
            tooltip: "Not Ekle",
            heroTag: "Not Ekle",
            child: Icon(Icons.add_circle),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  void kategoryEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    String yeniKategoryAdi;
    showDialog(
        //barrierDismissible:false, //--sadece buttonlara basarsa sehve baglanir bosh sahelerde ishe yaramir.
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "kategory Ekle",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            children: <Widget>[
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (yeniDeger) {
                      yeniKategoryAdi = yeniDeger;
                    },
                    decoration: InputDecoration(
                      labelText: "Kategory name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenKategoryAdi) {
                      if (girilenKategoryAdi.length < 3) {
                        return "En az 3 karakter giriniz";
                      } else
                        return null;
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.blueGrey,
                    child: Text(
                      "Vazgec",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        databaseHelper
                            .kategoryEkle(Kategory(yeniKategoryAdi))
                            .then((katogoryID) {
                          if (katogoryID > 0) {
                            _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Kategory Eklendi"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            //debugPrint("Kategory eklendi + $katogoryID");
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.teal,
                    child: Text(
                      "Kaydet",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotDetay(
                  baslik: "Yeni not",
                )));
  }
}

class Notlar extends StatefulWidget {
  @override
  _NotlarState createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  List<Not> tumNotlar;
  DatabaseHelper databaseHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumNotlar = List<Not>();
    databaseHelper = DatabaseHelper();
    databaseHelper.notlariGetir().then((notlariIcerenMapListesi) {
      for (Map map in notlariIcerenMapListesi) {
        tumNotlar.add(Not.fromMap(map));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return tumNotlar.length <= 0
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: tumNotlar.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tumNotlar[index].notBaslik),
              );
            });
  }
}
