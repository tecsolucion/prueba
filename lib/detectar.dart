import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon_example/addContact.dart';

import 'como.dart';

import 'main.dart';

import 'package:http/http.dart' as http;

import 'mensaje.dart';

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';



class Detectar extends StatelessWidget {
  final appTitle = 'Add Contacto';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dectectar',
      home: Detectar2(),
    );
  }
}

class Detectar2 extends StatefulWidget {

  //final String title;

  // Detectar2({Key key, this.title}) : super(key: key);

  @override
  _Detectar2State createState() => _Detectar2State();

}




class _Detectar2State extends State<Detectar2> {

  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _regionBeacons2 = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];


  String email = "", name = "", id_user = "";

  String celular, mac,mensaje2,id;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
      mac = preferences.getString("mac");
      mensaje2 = preferences.getString("mensaje");

    });


  }

  @override
  void initState(){

    super.initState();
    initBeacon();
    getPref();

    Future.delayed(Duration(seconds: 30)).then((res) {

      initBeacon();

    });

  }



  initBeacon() async {


    try {
      await flutterBeacon.initializeScanning;
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];

    regions.add(Region(identifier: 'com.beacon'));

    flutterBeacon.ranging(regions).listen((res){

    });



    _streamRanging = flutterBeacon.ranging(regions).listen((result) {


      if (result != null && mounted) {
        setState(() {

          _regionBeacons[result.region] = result.beacons;

          if (result.beacons.length > 0) {

            result.beacons.first.macAddress;

            String MAC2 = result.beacons.first.macAddress;

            _mac.value = new TextEditingController.fromValue(new TextEditingValue(text: '$MAC2')).value;



            /*
            result.beacons.forEach((Beacon){
              String MAC = Beacon.macAddress;
                _macRead=MAC;
              print(MAC);
            });
           */

          }



        });
      }
    });
  }





  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setString("mensaje", null);

      preferences.commit();

      flutterBeacon.close;
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Login()));

      //_loginStatus = LoginStatus.notSignIn;

      // _loginStatus = LoginStatus.notSignIn;
    });
  }


  var _mac = new TextEditingController();


  editar() async {

    setState(() {

      mac="";
    });


  }

  _addData() async {


    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {

      id_user = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");

    });



    final response = await http.post("http://matli.aplicacionesgis.xyz/principal/saveMac", body: {
      "mac": _mac.text,
      "user_id": id_user,
    });



    final data = json.decode(response.body);

    print(data);


    int value = data['value'];

    String message = data['message'];

    if (value == 1) {

      print(value);




      preferences.setString("mac",_mac.text);


      print(message);
      registerToast(message);

    } else if (value == 2) {

      print(value);

      print(message);
      registerToast(message);
    } else {
      print(message);
      registerToast(message);
    }

    //prefix0.LoginStatus.signIn;

    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Home(signOut)));

  }


  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detectar"),
        backgroundColor: Color.fromRGBO(0,170,136, 1),
        actions: <Widget>[

        ],
      ),
      backgroundColor: Color.fromRGBO(244,215,215 , 1),
      drawer: Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text('$name'),
                accountEmail: new Text('$email'),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: new Text('M'),
                ),
                decoration: new BoxDecoration(color: Color.fromRGBO(244,215,215, 1)),
              ),
              new ListTile(
                title: new Text('Inicio'),
                trailing: new Icon(Icons.home),
                onTap: ()=>  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Home(signOut))),

              ),
              new ListTile(
                title: new Text('Detectar'),
                trailing: new Icon(Icons.settings_applications),
                onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Detectar())),

              ),
              new ListTile(
                title: new Text('Mensaje'),
                trailing: new Icon(Icons.message),
                onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Mensaje())),

              ),

              new ListTile(
                title: new Text('Contactos'),
                trailing: new Icon(Icons.contacts),
                onTap: ()=> Navigator.push(context, new MaterialPageRoute( builder: (context) => new addContacto(),)),

              ),
              new ListTile(
                title: new Text('¿Cómo usar?'),
                trailing: new Icon(Icons.help),
                onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Como())),

              ),


              new ListTile(
                title: new Text('Close'),
                trailing: new Icon(Icons.close),
                onTap: (){

                  signOut();

                },
              ),
            ],
          )
      ),
      body:  mac != "" ?


      new Column(


        children: <Widget>[

          new SizedBox(
            height: 20,
          ),
          new Text("Ya tienes vinculado tu dispositivo a tu celular",style: TextStyle(color: Colors.black, fontSize:17, fontWeight: FontWeight.bold)),

          new SizedBox(
            height: 20,
          ),

          new Row(

            children: <Widget>[
              new SizedBox(
                width: 25,
              ),
              new Image.asset('assets/MATLI.png',width: 30,
                height: 30,),
              new SizedBox(
                width: 20,
              ),
              Text('$mac'),

              new SizedBox(
                width: 20,
              ),
              new IconButton(
                  onPressed: () {
                    editar();
                  },
                  icon: Icon(Icons.edit),

              ),

            ],
          ),



        ],

      ):



      new Column(

        children: <Widget>[

          new SizedBox(
            height: 25,
          ),
          new Text("Vincula tu botón con tu celular",style: TextStyle(color: Colors.black, fontSize:17, fontWeight: FontWeight.bold)),
          
          new ListTile(
            leading: new Image.asset('assets/MATLI.png',width: 30,
              height: 30,),
            title: new TextField(
              controller: _mac,

              decoration: new InputDecoration(
                  hintText: '',
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
                // hintText: "MAC_ADRESS",

              ),
            ),
          ),
          GestureDetector(
              child: Container(
                  width:30,
                  height: 30,
                  decoration: BoxDecoration(
                    // color: Colors.black,
                    image: DecorationImage(
                        image:AssetImage("assets/GUARDAR.png"),
                        fit:BoxFit.cover
                    ),

                  )
              ),onTap:(){
            _addData();
            //print("you clicked my");
          }
          ),
          new Text('Guardar'),

          new Card(
            child: new Container(
              padding: new EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Text(
                      'En tu dispositivo has doble click para detectar la dirección MAC',
                      textScaleFactor: 1
                  ),

                  // new Text('tu dispositivo')
                ],
              ),
            ),
          ),
          new Card(
            child: new Container(
              padding: new EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Text(
                      'o escribir tu dirección MAC y depues dar click en registrar',
                      textScaleFactor: 1
                  ),

                  // new Text('tu dispositivo')
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(0,170,136, 1),
        child: new Row(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Home(signOut)));

            },
              color: Colors.white,
            )
          ],
        ),

      ),
    );
  }
}
