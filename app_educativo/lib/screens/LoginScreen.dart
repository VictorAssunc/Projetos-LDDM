import 'package:app_educativo/screens/HomeScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  bool remember = false;
  bool buttonEnabled = false;

  void checkboxTap(bool value) {
    setState(() {
      remember = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: formKey,
        onChanged: () => setState(() => buttonEnabled = formKey.currentState.validate()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite o email";
                  }

                  if (!EmailValidator.validate(value)) {
                    return "Email inválido";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite a senha";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10.0),
              InkWell(
                onTap: () => checkboxTap(!remember),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO: só queria que o shape já estivesse no stable :(
                      Checkbox(
                        activeColor: Colors.green,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) => checkboxTap(value),
                        value: remember,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        "Lembrar-me",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: buttonEnabled ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home())) : null,
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.0)),
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
              // TODO: remover depois da valdiação de login
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home())),
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.0)),
                    child: Text(
                      "[DEBUG] Entrar sem login",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
