import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../app_controller.dart';
import '../../app_module.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  AppController _appController = AppModule.to.get<AppController>();

  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Color.fromRGBO(47, 112, 218, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage("assets/chat.png")),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _builLoginField(),
                          _buildLoginButton()
                        ], // <Widget>[]
                      ), // Column
                    ), //Form
                  ), //Padding
                ), //Container
              ), //Padding
            ],
          ), //Column
        ), //SingleChildScrollView
      ), //Container
    ); //Scanffold
  }

  Widget _builLoginField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        validator: (val) =>
            controller.name == null ? 'Campo Obrigatório' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          labelText: 'Nome',
          errorText: 'Campo Obrigatório',
        ), //InputDecoration
        style: TextStyle(fontSize: 18.0),
        onChanged: (val) {
          setState(() {
            controller.name = val;
          });
        },
      ), //TextFormField
    ); //Padding
  }

  Widget _buildLoginButton() {
    return MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        color: Colors.green,
        child: Text(
          'Login',
          style: TextStyle(fontSize: 21, color: Colors.gray),
        ), //Text
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _login();
          }
        }); //MasterButton
  }

  _sendToChatPage() {
    Navigator.of(context).pushNamed("/chat");
  }

  _login() {
    _appController.login(controller.name);
    _sendToChatPage(); //Scaffold
  }
}
