import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon_example/addContact.dart';

import 'como.dart';

import 'package:http/http.dart' as http;


import 'detectar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import 'main.dart';
import 'package:flutter_beacon/flutter_beacon.dart';


class Mensaje extends StatelessWidget {
  final appTitle = 'Add Contacto';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dectectar',
      home: Mensaje2(),
    );
  }
}

class Mensaje2 extends StatefulWidget {

  //final String title;

  // Mensaje2({Key key, this.title}) : super(key: key);

  @override
  _Mensaje2State createState() => _Mensaje2State();

}




class _Mensaje2State extends State<Mensaje2> {

  LoginStatus _loginStatus ;



  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setString("mensaje", null);

      flutterBeacon.close;
      preferences.commit();

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Login()));

       _loginStatus = LoginStatus.notSignIn;


    });
  }


  var  _mensaje = new TextEditingController();


  String email = "", name = "", id_user = "";

  String celular,mac="",id="",mensaje="";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
      celular = preferences.getString("celular");
      mac = preferences.getString("mac");
      mensaje = preferences.getString("mensaje");

    });


    _mensaje.value = new TextEditingController.fromValue(new TextEditingValue(text: '$mensaje')).value;


  }


  _addData() async {


    SharedPreferences preferences = await SharedPreferences.getInstance();

    id_user = preferences.getString("id");
    email = preferences.getString("email");
    name = preferences.getString("name");
    celular = preferences.getString("celular");




    final response = await http.post("http://matli.aplicacionesgis.xyz/principal/saveMensaje", body: {
      "mensaje": _mensaje.text,
      "user_id": id_user,
    });



    print(id_user);

    print(_mensaje.text);

    final data = json.decode(response.body);

    print(data);


    int value = data['value'];

    String message = data['message'];

    if (value == 1) {

      print(value);

      preferences.setString("mensaje",_mensaje.text);


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
  void initState() {
    super.initState();
    getPref();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mensaje"),
        backgroundColor: Color.fromRGBO(0,170,136, 1),
        actions: <Widget>[

        ],),
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
      body:  new Column(
        children: <Widget>[


          new SizedBox(
            height: 15,
          ),

          new Text("Escribe tu mensaje de ayuda",style: TextStyle(color: Colors.black, fontSize:17, fontWeight: FontWeight.bold)),

          new SizedBox(
            height: 15,
          ),
          new ListTile(
            leading: new Image.asset('assets/BOCINA.png',width: 30,
    height: 30,

    ),
            title: new TextFormField(
              controller: _mensaje,
              maxLines: 2,
              maxLength: 120,

              decoration: new InputDecoration(

                hintText: mensaje,
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
          /*new RaisedButton.icon(
              onPressed: () {
                _addData();
              },
              icon: Icon(Icons.add),
              label: Text(
                "Editar mensaje",
                textScaleFactor: 1.2,
              ),
              textColor: Colors.black
          ),*/
          GestureDetector(
              child: Container(
                  width:40,
                  height: 40,
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
          )
         /* new Card(
            child: new Container(
              padding: new EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new Text(
                      'Escribe tu mensaje de ayuda',
                      textScaleFactor: 1.2
                  ),

                  // new Text('tu dispositivo')
                ],
              ),
            ),
          ), */
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(0,170,136, 1),
        child: new Row(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            IconButton(

              icon: Icon(Icons.home),
              
              onPressed: () {
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