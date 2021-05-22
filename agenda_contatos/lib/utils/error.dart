import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String ErrEmailNotRegistered = "Email não cadastrado";
const String ErrWrongPassword = "Senha incorreta";
const String ErrEmailAlreadyRegistered = "Email já cadastrado";
const String ErrWeakPassword = "Senha fraca";
const String ErrInvalidEmail = "Email inválido";

const Map<String, String> errors = {
  "user-not-found": ErrEmailNotRegistered,
  "wrong-password": ErrWrongPassword,
  "email-already-in-use": ErrEmailAlreadyRegistered,
  "weak-password": ErrWeakPassword,
  "invalid-email": ErrInvalidEmail,
};

Future<dynamic> showError(BuildContext context, String error) {
  String errMessage = errors[error];
  if (errMessage == null) {
    errMessage = "Erro desconhecido, tente novamente!";
  }

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          errMessage,
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
