import 'package:agenda_contatos/screens/Main.dart';
import 'package:agenda_contatos/utils/error.dart';
import 'package:agenda_contatos/utils/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  bool hidePassword = true;
  bool buttonEnabled = false;
  String screenStatus = 'email';

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
                style: defaultColorTextStyle,
                textInputAction: screenStatus != 'email' ? TextInputAction.next : TextInputAction.done,
                onChanged: (value) {
                  setState(() {
                    screenStatus = 'email';
                    passwordController.clear();
                    repeatPasswordController.clear();
                    nameController.clear();
                  });
                },
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
              screenStatus == 'email'
                  ? Container(height: 0)
                  : TextFormField(
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
                      onFieldSubmitted: (value) {
                        do {
                          FocusScope.of(context).nextFocus();
                        } while (FocusScope.of(context).focusedChild.context.widget is! EditableText);
                      },
                      style: defaultColorTextStyle,
                      textInputAction: screenStatus == 'signup' ? TextInputAction.next : TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Digite a senha";
                        }

                        return null;
                      },
                    ),
              // repeat password
              screenStatus != 'signup'
                  ? Container(height: 0)
                  : TextFormField(
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
                      onFieldSubmitted: (value) {
                        do {
                          FocusScope.of(context).nextFocus();
                        } while (FocusScope.of(context).focusedChild.context.widget is! EditableText);
                      },
                      style: defaultColorTextStyle,
                      textInputAction: TextInputAction.next,
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
              // name
              screenStatus != 'signup'
                  ? Container(height: 0)
                  : TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        labelText: "Nome",
                      ),
                      keyboardType: TextInputType.name,
                      style: defaultColorTextStyle,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Digite o nome";
                        }

                        return null;
                      },
                    ),
              SizedBox(height: 10.0),
              // botão entrar
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !buttonEnabled
                        ? null
                        : screenStatus == 'email'
                            ? () async {
                                try {
                                  List<String> methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.value.text);
                                  String newStatus = 'login';
                                  if (methods.isEmpty) {
                                    newStatus = 'signup';
                                  }

                                  setState(() {
                                    screenStatus = newStatus;
                                  });
                                } on FirebaseAuthException catch (e) {
                                  return showError(context, e.code);
                                }
                              }
                            : () async {
                                try {
                                  if (screenStatus == 'signup') {
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: emailController.value.text,
                                      password: passwordController.value.text,
                                    );
                                    await FirebaseAuth.instance.currentUser.updateProfile(displayName: nameController.value.text);
                                    FirebaseFirestore.instance
                                        .collection("usuarios")
                                        .doc(FirebaseAuth.instance.currentUser.uid)
                                        .set({"id": FirebaseAuth.instance.currentUser.uid, "ultimo_id": 0});
                                  } else {
                                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                                      email: emailController.value.text,
                                      password: passwordController.value.text,
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  return showError(context, e.code);
                                }

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Main(),
                                  ),
                                );
                              },
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 15.0)),
                    child: Text(
                      screenStatus != 'signup' ? "Entrar" : "Cadastrar",
                      style: defaultColorTextStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
