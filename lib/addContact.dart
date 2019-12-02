import 'package:flutter/material.dart';

import 'como.dart';

import 'mensaje.dart';
import 'detectar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';


import 'package:native_contact_picker/native_contact_picker.dart';
import 'package:flutter_beacon/flutter_beacon.dart';



class addContacto extends StatelessWidget {
  final appTitle = 'Add Contacto';



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: addContacto2(),
    );
  }
}

class addContacto2 extends StatefulWidget {



  @override
  _addContacto2State createState() => _addContacto2State();

}


class _addContacto2State extends State<addContacto2> {

  final NativeContactPicker _contactPicker = new NativeContactPicker();
  String _contact;
  String _nombre;



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


    });
  }



  String email = "", name = "", id_user = "";

  String celular,celular1,celular2,celular3,mac,mensaje,id,message,nombre1,nombre2,nombre3;

  var _celular1Controller = new TextEditingController();
  var _celular2Controller = new TextEditingController();
  var _celular3Controller = new TextEditingController();
  var _nombre1Controller = new TextEditingController();
  var _nombre2Controller = new TextEditingController();
  var _nombre3Controller = new TextEditingController();



  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
      mac = preferences.getString("mac");
      mensaje = preferences.getString("mensaje");

      celular1=preferences.getString("celular1");
      celular2=preferences.getString("celular2");
      celular3=preferences.getString("celular3");
      nombre1=preferences.getString("nombre1");
      nombre2=preferences.getString("nombre2");
      nombre3=preferences.getString("nombre3");


      _celular1Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$celular1')).value;
      _celular2Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$celular2')).value;
      _celular3Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$celular3')).value;


      _nombre1Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$nombre1')).value;
      _nombre2Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$nombre2')).value;
      _nombre3Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$nombre3')).value;





    });


  }





    _addData(context) async {


      SharedPreferences preferences = await SharedPreferences.getInstance();

      setState(() {

        preferences.setString("celular1",_celular1Controller.text);
        preferences.setString("celular2",_celular2Controller.text);
        preferences.setString("celular3",_celular3Controller.text);

        preferences.setString("nombre1",_nombre1Controller.text);
        preferences.setString("nombre2",_nombre2Controller.text);
        preferences.setString("nombre3",_nombre3Controller.text);




      });



      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Home(signOut)));


        message ="Se guardaron tus contactos";

        print(message);
        registerToast(message);

  }


  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_LONG,
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
      appBar: AppBar(title: Text('Contactos'),
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
      body: new SingleChildScrollView(
       child:
      new Column(

        children: <Widget>[
           /*
           new Row(
             children: <Widget>[
               new SizedBox(
                 width: 25,
               ),

               new Image.asset('assets/CONTACTOS.png',width: 30,
                 height: 30,

               ),
               new SizedBox(
                 width: 25,
               ),
               new Text("Contactos",style: TextStyle(color: Colors.black, fontSize:17, fontWeight: FontWeight.bold)),
             ],
           ),
*/
          new ListTile(
            trailing:


            new IconButton(
                onPressed: () async {

                  Contact contact = await _contactPicker.selectContact();

                  setState(() {
                   _contact = contact.phoneNumber.replaceAll(' ', '');

                   if (_contact.length >10 ) {
                     _contact = _contact.substring(
                         _contact.length - 10, _contact.length);
                   }

                    _celular1Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_contact' )).value;

                   _nombre = contact.fullName.trim();
                   _nombre1Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_nombre' )).value;


                  });
                },
                icon: Icon(Icons.search)
            ),

            title: new TextField(

            controller: _nombre1Controller,
            maxLength: 10,
            decoration: new InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Icon(Icons.person, color: Colors.black),
              ),
              hintText: "Nombre 1",
              filled: true,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(
                ),
              ),
              //fillColor: Colors.green


            ),
          ),             subtitle: new TextField(
            controller: _celular1Controller,
            maxLength: 10,
            decoration: new InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Icon(Icons.phone, color: Colors.black),
              ),
              hintText: "Contacto 1",
              filled: true,
              fillColor: Colors.white,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(25.0),
                borderSide: new BorderSide(
                ),
              ),

            ),
          )

          ),
          new ListTile(
            title: new TextField(
              controller: _nombre2Controller,
              maxLength: 10,
              decoration: new InputDecoration(
                hintText: "Nombre 2",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Icon(Icons.person, color: Colors.black),
                ),
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
            ),
            subtitle: new TextField(
              controller: _celular2Controller,
              maxLength: 10,
              decoration: new InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Icon(Icons.phone, color: Colors.black),
                ),
                hintText: "Contacto 2",
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
            ),



            trailing: new IconButton(
                onPressed: () async {


                  Contact contact = await _contactPicker.selectContact();


                  setState(() {
                  String  _contact2 = contact.phoneNumber.replaceAll(' ', '');

                  if (_contact2.length >10 ) {
                    _contact2 = _contact2.substring(
                        _contact2.length - 10, _contact2.length);
                  }

                  _celular2Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_contact2' )).value;
                  _nombre = contact.fullName.trim();
                  _nombre2Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_nombre' )).value;

                  });
                },
                icon: Icon(Icons.search),

            ),

          ),
          new ListTile(


            title: new TextField(
              controller: _nombre3Controller,
              maxLength: 10,
              decoration: new InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Icon(Icons.person, color: Colors.black),
                ),
                hintText: "Nombre 3",
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
            ),
            subtitle: new TextField(
              controller: _celular3Controller,
              maxLength: 10,
              decoration: new InputDecoration(
                hintText: "Contacto 3",
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Icon(Icons.phone, color: Colors.black),

                ),
                filled: true,
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(
                  ),
                ),
              ),
            ),
            trailing: new IconButton(
                onPressed: () async {


                  Contact contact = await _contactPicker.selectContact();


                  setState(() {
                    String  _contact3 = contact.phoneNumber.replaceAll(' ', '');

                    if (_contact3.length >10 ) {
                      _contact3 = _contact3.substring(
                          _contact3.length - 10, _contact3.length);
                    }


                    _contact3.substring(_contact3.length-10,_contact3.length);
                    _celular3Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_contact3' )).value;
                    _nombre = contact.fullName.trim();
                    _nombre3Controller.value = new TextEditingController.fromValue(new TextEditingValue(text: '$_nombre' )).value;
                  });
                },
                icon: Icon(Icons.search)
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
            _addData(context);
            //print("you clicked my");
          }
          ),
          new Text('Guardar contactos'),
        ],
      )),
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