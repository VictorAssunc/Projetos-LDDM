import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  final billValueController = new MoneyMaskedTextController(leftSymbol: "R\$ ", thousandSeparator: " ");
  final alcoholicBillValueController = new MoneyMaskedTextController(leftSymbol: "R\$ ", thousandSeparator: " ");
  final peopleAmountController = new TextEditingController()..text = "1";
  final alcoholicPeopleAmountController = new TextEditingController()..text = "1";
  final waiterPercentageController = new TextEditingController();

  bool showDetails = false;
  bool alcoholDivision = false;
  int peopleAmount = 1;
  int alcoholicPeopleAmount = 1;
  double billValue = 0.0;
  double alcoholicBillValue = 0.0;
  double totalValue = 0.0;
  double waiterValue = 0.0;
  double waiterPercentage = 0.0;

  double individualValue = 0.0;
  double alcoholicIndividualValue = 0.0;

  @override
  void setState(fn) {
    super.setState(fn);
    waiterValue = waiterPercentage * billValue;
    totalValue = billValue + waiterValue;
    individualValue = (totalValue - alcoholicBillValue) / peopleAmount;
    alcoholicIndividualValue = alcoholicBillValue / alcoholicPeopleAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: DefaultTextStyle(
        style: new TextStyle(
          fontSize: 18.0,
          color: Colors.black,
        ),
        child: Center(
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * .05),
              child: ListView(
                children: [
                  TextFormField(
                    controller: billValueController,
                    decoration: InputDecoration(
                      labelText: "Valor total da conta:",
                      labelStyle: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) {
                      setState(() {
                        billValue = billValueController.numberValue;
                      });
                    },
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value.compareTo("R\$ 0,00") <= 0) {
                        return "Insira um valor maior que R\$ 0,00";
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: peopleAmountController,
                    decoration: InputDecoration(
                      labelText: "Quantidade de pessoas:",
                      labelStyle: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        peopleAmount = int.tryParse(value) ?? 1;
                      });
                    },
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value.isEmpty || int.tryParse(value) < 1) {
                        return "Deve ser pelo menos 1";
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: waiterPercentageController,
                    decoration: InputDecoration(
                      labelText: "Porcentagem do garçom:",
                      labelStyle: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9,.]"))],
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (formKey.currentState.validate()) {
                        value = value.replaceAll(",", ".");
                        setState(() {
                          waiterPercentage = (double.tryParse(value) ?? 0.0) / 100;
                        });
                      }
                    },
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        value = value.replaceAll(",", ".");
                        if (value.split(".").length > 2) {
                          return "Excesso de pontuação";
                        }

                        if (double.tryParse(value) > 100) {
                          return "O máximo é 100%";
                        }
                      }

                      return null;
                    },
                  ),
                  SwitchListTile(
                    activeColor: Colors.green,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        alcoholDivision = value;
                        if (!alcoholDivision) {
                          alcoholicBillValue = 0.0;
                          alcoholicPeopleAmount = 1;
                        } else {
                          alcoholicBillValue = alcoholicBillValueController.numberValue;
                          alcoholicPeopleAmount = int.tryParse(alcoholicPeopleAmountController.value.text);
                        }
                      });
                    },
                    title: Text(
                      "Divisão do álcool?",
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    value: alcoholDivision,
                  ),
                  alcoholDivision
                      ? Column(
                          children: [
                            TextFormField(
                              controller: alcoholicBillValueController,
                              decoration: InputDecoration(
                                labelText: "Valor total das bebidas alcoólicas:",
                                labelStyle: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (_) {
                                setState(() {
                                  alcoholicBillValue = alcoholicBillValueController.numberValue;
                                });
                              },
                              style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value.compareTo("R\$ 0,00") <= 0) {
                                  return "Insira um valor maior que R\$ 0,00";
                                }

                                return null;
                              },
                            ),
                            TextFormField(
                              controller: alcoholicPeopleAmountController,
                              decoration: InputDecoration(
                                labelText: "Quantidade de pessoas que beberam:",
                                labelStyle: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  alcoholicPeopleAmount = int.tryParse(value) ?? 1;
                                });
                              },
                              style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value.isEmpty || int.tryParse(value) < 1) {
                                  return "Deve ser pelo menos 1";
                                }

                                return null;
                              },
                            ),
                            SizedBox(height: 15.0),
                          ],
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showDetails = !showDetails;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Detalhes"),
                              Icon(showDetails ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                        showDetails ? SizedBox(height: 15.0) : Container(),
                        showDetails
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Valor do garçom:"),
                                      Text("R\$ ${waiterValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Valor total:"),
                                      Text("R\$ ${totalValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                                    ],
                                  ),
                                  Divider(thickness: 1.0, color: Colors.grey),
                                  Text("Conta sem bebidas alcoólicas"),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Valor total:"),
                                      Text("R\$ ${(totalValue - alcoholicBillValue).toStringAsFixed(2).replaceAll(".", ",")}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Valor individual:"),
                                      Text("R\$ ${individualValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                                    ],
                                  ),
                                  alcoholDivision ? Divider(thickness: 1.0, color: Colors.grey) : Container(),
                                  alcoholDivision ? Text("Conta com bebidas alcoólicas") : Container(),
                                  alcoholDivision ? SizedBox(height: 10.0) : Container(),
                                  alcoholDivision
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Valor total:"),
                                            Text("R\$ ${alcoholicBillValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                                          ],
                                        )
                                      : Container(),
                                  alcoholDivision
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Valor individual:"),
                                            Text("R\$ ${alcoholicIndividualValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                                          ],
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Resumo"),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        alcoholDivision
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Quem bebe paga:"),
                                  Text("R\$ ${(individualValue + alcoholicIndividualValue).toStringAsFixed(2).replaceAll(".", ",")}"),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            alcoholDivision
                                ? RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: "Quem "),
                                        TextSpan(text: "não", style: TextStyle(fontWeight: FontWeight.bold)),
                                        TextSpan(text: " bebe paga:"),
                                      ],
                                    ),
                                  )
                                : Text("Cada um paga:"),
                            Text("R\$ ${individualValue.toStringAsFixed(2).replaceAll(".", ",")}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomRangeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '')
      return TextEditingValue();
    else if (int.parse(newValue.text) < 1) return TextEditingValue().copyWith(text: '1');

    return int.parse(newValue.text) > 20 ? TextEditingValue().copyWith(text: '20') : newValue;
  }
}
