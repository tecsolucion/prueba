import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon_example/addContact.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';



import 'package:location/location.dart';


import 'detectar.dart';
import 'como.dart';
import 'mensaje.dart';
import 'addContact.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:move_to_background/move_to_background.dart';

import 'dart:isolate';


import 'package:permission_handler/permission_handler.dart';

import 'package:temp_alarm_manager/android_alarm_manager.dart';


void printHello() {
  final DateTime now = new DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}


main() async {




  await PermissionHandler().requestPermissions([
    PermissionGroup.location,PermissionGroup.contacts, PermissionGroup.locationAlways
  ]);


  final int helloAlarmID = 0;


  await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);

  return runApp(new MaterialApp(
    home: Login(),
  ));








}





class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }


class _LoginState extends State<Login> {



  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http
        .post("http://matli.aplicacionesgis.xyz/api/api.php", body: {
      "flag": 1.toString(),
      "username": email,
      "password": password
      // "fcm_token": "test_fcm_token"
    });


    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String emailAPI = data['username'];
    String nameAPI = data['nombre'];
    String id = data['id'];
    String mac = data['mac'];
    String mensaje=data['mensaje'];

    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, emailAPI, nameAPI, id, mac, mensaje);
      });
      print(message);
      loginToast(message);
    } else {
      print("fail");
      print(message);
      loginToast(message);
    }

  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(int value, String email, String name, String id,String mac,String mensaje) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.setString("mac",mac);
      preferences.setString("mensaje",mensaje);
      preferences.setString("password", password);

      preferences.commit();
    });
  }

  var value;


  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      password = preferences.getString("password");


      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
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

      _loginStatus = LoginStatus.notSignIn;

      flutterBeacon.close;

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Login()));

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          backgroundColor: Color.fromRGBO(244,215,215, 1),
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                    color: Color.fromRGBO(244,215,215, 1),
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/MATLI.png',width: 70,
                            height: 70,),

                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 50,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Color.fromRGBO(0,170,136, 1), fontSize: 30.0),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),

                          //card for Email TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {


                                    return "Por favor introduce tu Email";


                                  }
                                  if (EmailValidator.validate(e) == !true){

                                    return "No tiene el formato correcto";
                                  }
                                },
                                onSaved: (e) => email = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding:
                                      EdgeInsets.only(left: 20, right: 15),
                                      child:
                                      Icon(Icons.person, color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Email"),
                                keyboardType: TextInputType.emailAddress
                            ),
                          ),

                          // Card for password TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "El password no puede ser vacio";
                                }
                              },
                              obscureText: _secureText,
                              onSaved: (e) => password = e,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                contentPadding: EdgeInsets.all(18),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),



                          Padding(
                            padding: EdgeInsets.all(14.0),
                          ),

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: 44.0,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0)),
                                    child: Text(
                                      "Entrar",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    textColor: Colors.white,
                                    color: Color.fromRGBO(0,170,136, 1),
                                    onPressed: () {
                                      check();
                                    }),
                              )
                            ],
                          ),
                          FlatButton(
                            onPressed: () {  Navigator.push( context, MaterialPageRoute( builder: (context) => Register()),); },
                            child: Text(
                              "Registrate",
                              style: TextStyle(
                                  color: Color.fromRGBO(0,170,136, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FlatButton(
                            onPressed: null,
                            child: Text(
                              "Olvidaste tu password",
                              style: TextStyle(
                                  color: Color.fromRGBO(0,170,136, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;

      case LoginStatus.signIn:
        return Home(signOut);
//        return ProfilePage(signOut);
        break;
    }
  }
}

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name, email, mobile, password,cp;

  bool _termsChecked = false;

  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _termsChecked==true) {
      form.save();
      save();
    }
  }

  save() async {
    final response = await http
        .post("http://matli.aplicacionesgis.xyz/principal/saveRegistro2", body: {
      //  "flag": 2.toString(),
      "nombre": name,
      "username": email,
      "celular": mobile,
      "cp": cp,
      "password": password
      //"fcm_token": "test_fcm_token"
    });

    final data = json.decode(response.body);

    print(data);


    int value = data['value'];
    String message = data['message'];
    if (value == 1) {

      print(value);
      setState(() {
        Navigator.pop(context);
      });
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
      backgroundColor: Color.fromRGBO(244,215,215, 1),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Color.fromRGBO(244,215,215, 1),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/MATLI.png',width: 70,
                        height: 70,),
                      SizedBox(
                        height: 50,
                        child: Text(

                          "Registro",
                          style: TextStyle(color: Color.fromRGBO(0,170,136, 1), fontSize: 30.0),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      //card for Fullname TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Por favor introduce tu nombre";
                            }
                          },
                          onSaved: (e) => name = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.person, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Nombre"),
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Por favor introduce tu correo";
                              }
                              if (EmailValidator.validate(e) == !true){

                                return "No tiene el formato correcto";
                              }
                            },
                            onSaved: (e) => email = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.email, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Email"),
                            keyboardType: TextInputType.emailAddress
                        ),

                      ),

                      //card for Mobile TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Por favor inserta tu telefono";
                            }
                          },
                          onSaved: (e) => mobile = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.phone, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Telefono",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Por favor inserta tu CP";
                            }
                          },
                          onSaved: (e) => cp = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.home, color: Colors.black),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "CP",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),


                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      CheckboxListTile(

                        title: Text('Acepto terminos y condiciones'),

                        value: _termsChecked,
                        onChanged: (bool value) => setState(() => _termsChecked = value),
                        subtitle: !_termsChecked
                            ? Padding(
                          padding: EdgeInsets.all(5),
                          child: Text('Requerido', style: TextStyle(color: Color(0xFFe53935), fontSize: 12),),)
                            : null,
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Registrarse",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: Color.fromRGBO(0,170,136, 1),
                                onPressed: () {
                                  check();
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





class Home extends StatefulWidget  {



  final VoidCallback signOut;

  Home(this.signOut);

  @override
  _HomeState createState() => _HomeState();





}



class _HomeState extends State<Home> {



  signOut() {
    setState(() {
      widget.signOut();
    });
  }


  StreamSubscription<RangingResult> _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};



  String beacon ="";

  int contador=0;

  String email = "", name = "", id = "",mac="";

  String celular1="", mensaje2="", celular2="",celular3="",celular4="",celular5="",password="";


  getPref() async {

    // var stream = await ping("google.com", times: 5);


    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");

      celular1=preferences.getString("celular1");
      celular2=preferences.getString("celular2");
      celular3=preferences.getString("celular3");
      celular4=preferences.getString("celular4");
      celular5=preferences.getString("celular4");
      mensaje2 = preferences.getString("mensaje");
      mac = preferences.getString("mac");
      password = preferences.getString("password");

    });


    if (mac=="" || mac=="null"){

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Detectar()));

    }
    else if (mensaje2==""  || mensaje2=="null"){

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Mensaje()));
    }

    else if ( (celular1=="" || celular1=="null" || celular1==null) && (celular2=="" || celular2=="null" || celular2==null) && (celular3=="" || celular3=="null" || celular3==null) ){

      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new addContacto()));
    }


    print(id);
    print(email);
    print(name);
    print(celular1);
    print(celular2);
    print(mac);
    print(mensaje2);
    print(password);
  }










  @override
  void initState() {
    super.initState();

    initBeacon();


    /*
    Future.delayed(Duration(seconds: 300)).then((res) {

      initBeacon();

      print("hola");

    });
*/


    Timer.periodic(Duration(seconds: 300), (timer) {


      initBeacon();

      print("hola");

    });




    getPref();



  }







  initBeacon() async {


    try {
      await flutterBeacon.initializeScanning;
      print('Beacon scanner initialized');
    } on PlatformException catch (e) {
      print(e);
    }

    final regions = <Region>[];

    if (Platform.isIOS) {
      regions.add(Region(
          identifier: 'Apple Airlocate',
          proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
    } else {
      // android platform, it can ranging out of beacon that filter all of Proximity UUID
      regions.add(Region(identifier: 'com.beacon'));
    }





    _streamRanging = flutterBeacon.ranging(regions).listen((result) {
      if (result != null && mounted) {
        setState(() {

          if (result.beacons.length > 0) {

            //   print(result.beacons);

            result.beacons.first.macAddress;


            beacon = result.beacons.first.macAddress;

            String MAC2 = result.beacons.first.macAddress;

            if (MAC2==mac){

              contador++;

              print(contador);

              if (contador==1){

                _database();

                Future.delayed(Duration(seconds: 30)).then((res) {
                  contador = 0;


                });


              }

            }

            print(MAC2);


            /*
            result.beacons.forEach((Beacon){



            });
            */




          }



        });
      }
    });
  }



  @override
  void dispose() {
    if (_streamRanging != null) {
      _streamRanging.cancel();
    }
    super.dispose();
  }
/*
  void enviaMensaje (String celular, String body ){

    if (celular !=null) {
      SmsSender smsSender = new SmsSender();
      smsSender.sendSms(
          new SmsMessage(celular, body)); //instead xxx... to receiver phone
    }
  }
  */


  void _database() async {
    LocationData currentLocation;

    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      double lat = currentLocation.latitude;
      double lng = currentLocation.longitude;


      String lats = lat.toStringAsFixed(4);
      String lngs = lng.toStringAsFixed(4);




      String url = "https://maps.google.com/?q="+lats+","+lngs+"";


      String mensaje=mensaje2;

      String smsBody = "Soy "+name+" "+ mensaje + " " + url;
/*
      SmsSender smsSender = new SmsSender();

      if ( celular1 !=null) {

        //      String contacto=celular1;
        SmsSender smsSender = new SmsSender();
        smsSender.sendSms(new SmsMessage(celular1, smsBody)); //instead xxx... to receiver phone

      }

      if ( celular2 !=null) {

        //      String contacto=celular1;
        SmsSender smsSender = new SmsSender();
        smsSender.sendSms(new SmsMessage(celular2, smsBody)); //instead xxx... to receiver phone

      }

      if ( celular3 !=null) {

        //      String contacto=celular1;
        SmsSender smsSender = new SmsSender();
        smsSender.sendSms(new SmsMessage(celular3, smsBody)); //instead xxx... to receiver phone

      }


*/

      final response = await http.post(
          "http://matli.aplicacionesgis.xyz/eventos/save",
          body: {
            "lat": lat.toString(),
            "lng": lng.toString(),
            "usuario": id,
            "mensaje": smsBody,
            "celular1":celular1,
            "celular2":celular2,
            "celular3":celular3,

          });







      /*
      List<String> celulares = [celular1, celular2, celular3];


      celulares.forEach((cel) =>

          enviaMensaje(cel,smsBody)

      );
*/


      deteccion("Detección");

    } catch (e) {
      print("error");
      print(e);
    }



  }


  deteccion(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black);
  }

/*
  void _showDialog() {
    // flutter defined function
    showDialog <void>(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alerta"),
          content: new Text("Se detecto"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
*/

  List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[

    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 2),

  ];

  List<Widget> _tiles = const <Widget>[

    const _Deteccion(Color.fromRGBO(244,215,215,1), Icons.settings),
    const _Mensaje(Color.fromRGBO(244,215,215,1), Icons.message),
    const _Contactos(Color.fromRGBO(244,215,215,1), Icons.contacts),
    const _Como(Color.fromRGBO(244,215,215,1), Icons.help),
    const _Alerta(Color.fromRGBO(244,215,215,1), Icons.add_alert),
    const _Salir(Color.fromRGBO(244,215,215,1), Icons.close),


  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },

      child: MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Inicio '+'$contador'),
              backgroundColor: Color.fromRGBO(0,170,136, 1),

              actions: <Widget>[

              ],
            ),


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
                  ),
                  IconButton(icon: Icon(Icons.arrow_downward), onPressed: () {
                    MoveToBackground.moveTaskToBack();

                  },

                    color: Colors.white,
                  )
                ],
              ),

            ),

            // ,
            body: new Container(

              child: new Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: new StaggeredGridView.count(
                  crossAxisCount: 4,
                  staggeredTiles: _staggeredTiles,
                  children: _tiles,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  padding: const EdgeInsets.all(4.0),


                ),
              ),

            )

        ),
      ),
    );
  }





}


class _Deteccion extends StatelessWidget {
  const _Deteccion(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
          onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Detectar())),
          child: new Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[

              Image.asset('assets/MATLI.png',width: 70,
                height: 70,),
              new Text("Vincula",
                  style: TextStyle(color: Colors.black)
              )
            ],
          )
      ),
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
          onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Mensaje())),
          child: new Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[

              Image.asset('assets/BOCINA.png',width: 50,
                height: 50,),
              new Text("Mensaje",
                  style: TextStyle(color: Colors.black)
              )
            ],
          )
      ),
    );
  }
}



class _Contactos extends StatelessWidget {
  const _Contactos(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new addContacto())),
        child: new Center(
          child: new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: <Widget>[

                  Image.asset('assets/CONTACTOS.png',width: 50,
                    height: 50,),
                  new Text("Contactos",
                      style: TextStyle(color: Colors.black)
                  )
                ],
              )




          ),

        ),
      ),
    );
  }
}


class _Alerta extends StatelessWidget {
  const _Alerta(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        // onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new addContacto())),
        child: new Center(
          child: new Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: <Widget>[

                  Image.asset('assets/CORAZON.png',width: 50,
                    height: 50,),
                  new Text("",
                      style: TextStyle(color: Colors.black)
                  )
                ],
              )




          ),

        ),
      ),
    );
  }
}

class _Salir extends StatelessWidget {
  const _Salir(this.backgroundColor, this.iconData);


  signOut(context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
  }

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
          onTap: ()=> signOut(context),
          child: new Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[

              Image.asset('assets/SALIR.png',width: 50,
                height: 50,),
              new Text("Salir",
                  style: TextStyle(color: Colors.black)
              )
            ],
          )
      ),
    );
  }
}






class _Como extends StatelessWidget {
  const _Como(this.backgroundColor, this.iconData);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
          onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>new Como())),
          child: new Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[

              Image.asset('assets/USAR.png',width: 50,
                height: 50,),
              new Text("¿Como usar?",
                  style: TextStyle(color: Colors.black)
              )
            ],
          )
      ),
    );
  }
}