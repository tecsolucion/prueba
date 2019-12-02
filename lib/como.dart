import 'package:flutter/material.dart';
import 'package:flutter_beacon_example/addContact.dart';

import 'mensaje.dart';

import 'detectar.dart';

import 'main.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_beacon/flutter_beacon.dart';





class Como extends StatelessWidget {
  final appTitle = '¿Cómo usar?';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: Como2(),
    );
  }
}




class Como2 extends StatefulWidget {

  //final String title;

  // Detectar2({Key key, this.title}) : super(key: key);

  @override
  _Como2State createState() => _Como2State();

}


class _Como2State extends State<Como2> {



  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setString("mensaje", null);
      preferences.setString("celular1",null);
      preferences.setString("celular2",null);
      preferences.setString("celular3",null);

      preferences.commit();
      flutterBeacon.close;

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Login()));

      //_loginStatus = LoginStatus.notSignIn;

      // _loginStatus = LoginStatus.notSignIn;
    });
  }


  String email = "", name = "", id = "",mac="";

  String celular="", mensaje2="";


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
      celular = preferences.getString("celular");
      mac = preferences.getString("mac");
      mensaje2 = preferences.getString("mensaje");

    });


  }



  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('¿Como usar?'),
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

      body:
      new Container(
          padding: EdgeInsets.all(20),
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                new Image.asset("assets/como.png")
              ]
          )
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