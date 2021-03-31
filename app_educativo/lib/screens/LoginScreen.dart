import 'package:app_educativo/main.dart';
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
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .10,
            left: MediaQuery.of(context).size.width * .15,
            right: MediaQuery.of(context).size.width * .15,
          ),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(),
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
                style: TextStyle(),
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
                      Checkbox(
                        activeColor: Colors.green,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) => checkboxTap(value),
                        value: remember,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text("Lembrar-me"),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: buttonEnabled ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home(title: "AAA"))) : null,
                child: Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
