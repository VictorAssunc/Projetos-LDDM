import 'package:controle_contas/entity/user.dart';
import 'package:controle_contas/repository/bill.dart';
import 'package:controle_contas/repository/user.dart';
import 'package:controle_contas/screens/Home.dart';
import 'package:controle_contas/screens/Signup.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  final UserRepository userRepository;
  final BillRepository billRepository;
  Login({this.userRepository, this.billRepository});

  @override
  _LoginState createState() => _LoginState(
        userRepository: this.userRepository,
        billRepository: this.billRepository,
      );
}

class _LoginState extends State<Login> {
  final UserRepository userRepository;
  final BillRepository billRepository;
  _LoginState({this.userRepository, this.billRepository});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool remember = false;
  bool hidePassword = true;
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
              // email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email),
                  labelText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textInputAction: TextInputAction.next,
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
              // password
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                obscureText: hidePassword,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite a senha";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10.0),
              // checkbox lembrar-me
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
                        "Lembrar-me [WIP]",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // botão entrar
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !buttonEnabled
                        ? null
                        : () async {
                            User user;
                            try {
                              user = await this.userRepository.auth(emailController.value.text, passwordController.value.text);
                            } catch (e) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      e,
                                      textAlign: TextAlign.center,
                                    ),
                                    contentPadding: EdgeInsets.only(top: 15.0),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            primary: Colors.red,
                                          ),
                                          child: Text(
                                            'OK',
                                            style: TextStyle(fontSize: 18.0),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              return;
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Home(
                                  user: user,
                                  userRepository: this.userRepository,
                                  billRepository: this.billRepository,
                                ),
                              ),
                            );
                          },
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
              SizedBox(height: 30.0),
              // texto cadastro
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      style: new TextStyle(color: Colors.black),
                      text: "Ainda não tem conta? ",
                    ),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Signup(
                                userRepository: this.userRepository,
                              ),
                            ),
                          );
                        },
                      style: new TextStyle(color: Colors.green),
                      text: "Cadastre-se!",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
