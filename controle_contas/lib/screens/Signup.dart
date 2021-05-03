import 'package:controle_contas/entity/user.dart';
import 'package:controle_contas/repository/user.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:password_strength/password_strength.dart';

class Signup extends StatefulWidget {
  final UserRepository userRepository;
  Signup({this.userRepository});

  @override
  _SignupState createState() => _SignupState(
        userRepository: this.userRepository,
      );
}

class _SignupState extends State<Signup> {
  final UserRepository userRepository;
  _SignupState({this.userRepository});

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController repeatPasswordController = new TextEditingController();

  /*
    0.0 ~ 0.25 : red
    0.26 ~ 0.5 : amber
    0.51 ~ 0.75 : lightGreen
    0.76 ~ 1 : green
  */
  TweenSequence<Color> barColors = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.amber,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.amber,
          end: Colors.lightGreen,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.lightGreen,
          end: Colors.green,
        ),
      ),
    ],
  );

  bool hidePassword = true;
  bool buttonEnabled = false;
  double passwordStrength = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        key: formKey,
        onChanged: () => setState(() => buttonEnabled = formKey.currentState.validate()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // name
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: "Nome",
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite um nome";
                  }

                  return null;
                },
              ),
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
                    return "Digite um email";
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
                onChanged: (value) {
                  setState(() {
                    passwordStrength = estimatePasswordStrength(passwordController.value.text);
                  });
                },
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite uma senha";
                  }

                  if (estimatePasswordStrength(value) < 0.3) {
                    return "Senha muito fraca";
                  }

                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 40.0),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  value: passwordStrength,
                  valueColor: barColors.animate(AlwaysStoppedAnimation(passwordStrength)),
                ),
              ),
              // repeat password
              TextFormField(
                controller: repeatPasswordController,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  labelText: "Repita a senha",
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
                    return "Repita a senha";
                  }

                  if (value != passwordController.value.text) {
                    return "As senhas devem ser iguais";
                  }

                  return null;
                },
              ),
              SizedBox(height: 10.0),
              // botão cadastrar
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !buttonEnabled
                        ? null
                        : () async {
                            try {
                              await this.userRepository.create(User(
                                    name: nameController.value.text,
                                    email: emailController.value.text,
                                    password: passwordController.value.text,
                                  ));
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

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Conta criada com sucesso",
                                    textAlign: TextAlign.center,
                                  ),
                                  contentPadding: EdgeInsets.only(top: 15.0),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          primary: Colors.green,
                                        ),
                                        child: Text(
                                          'OK',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.0)),
                    child: Text(
                      "Cadastrar",
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
