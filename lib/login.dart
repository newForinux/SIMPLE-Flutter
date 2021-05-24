import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appState/app_state.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, user, child) {
          return Scaffold(
            body: SafeArea (
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: <Widget> [
                      Text('심플'),
                      SizedBox(height:10),
                      RaisedButton(
                          child:Text('anonymous log in'),
                          onPressed: () async {
                            Provider.of<ApplicationState>(context, listen: false).signInAnonymously();
                            await Navigator.popAndPushNamed(context, '/home');
                          }
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}