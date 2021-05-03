import 'package:controle_contas/entity/bill.dart';
import 'package:controle_contas/entity/user.dart';
import 'package:controle_contas/repository/bill.dart';
import 'package:controle_contas/repository/user.dart';
import 'package:controle_contas/screens/Login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final User user;
  final UserRepository userRepository;
  final BillRepository billRepository;
  Home({this.user, this.userRepository, this.billRepository});

  @override
  _HomeState createState() => _HomeState(
        user: this.user,
        userRepository: this.userRepository,
        billRepository: this.billRepository,
      );
}

class _HomeState extends State<Home> {
  User user;
  final UserRepository userRepository;
  final BillRepository billRepository;
  _HomeState({this.user, this.userRepository, this.billRepository});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MoneyMaskedTextController valueController = MoneyMaskedTextController(leftSymbol: "R\$ ", thousandSeparator: " ");

  bool buttonEnabled = false;
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              this.user = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Login(
                    userRepository: this.userRepository,
                    billRepository: this.billRepository,
                  ),
                ),
              );
            },
          ),
        ],
        title: Text("Controle de Contas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Inserir nova conta"),
                content: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height * .5,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: formKey,
                    onChanged: () => setState(() => buttonEnabled = formKey.currentState.validate()),
                    child: ListView(
                      children: [
                        // nome
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nome",
                          ),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "A conta deve ter um nome";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        // descrição
                        TextFormField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                            labelText: "Descrição",
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 15.0),
                        // valor
                        TextFormField(
                          controller: valueController,
                          decoration: InputDecoration(
                            labelText: "Valor",
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "A conta deve ter um valor";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 15.0),
                        // data de vencimento
                        TextFormField(
                          // textAlign: TextAlign.center,
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: "Data de Vencimento",
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());

                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 10),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                                dateController.value = TextEditingValue(text: DateFormat("dd/MMM/yyyy").format(picked).toUpperCase());
                              });
                            }
                          },
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Colors.red,
                    ),
                    child: Text('CANCELAR'),
                    onPressed: () {
                      setState(() {
                        nameController.clear();
                        descriptionController.clear();
                        valueController.updateValue(0);
                        dateController.clear();
                        Navigator.pop(context);
                      });
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: Text('CRIAR'),
                    onPressed: buttonEnabled
                        ? () async {
                            Bill bill = new Bill(
                              name: nameController.value.text,
                              description: descriptionController.value.text,
                              value: valueController.numberValue,
                              expirationDate: selectedDate,
                            );

                            await this.billRepository.create(bill, this.user.id);
                            setState(() {
                              nameController.clear();
                              descriptionController.clear();
                              valueController.updateValue(0);
                              dateController.clear();
                              Navigator.pop(context);
                            });
                          }
                        : null,
                  ),
                ],
              );
            },
          );
        },
        tooltip: "Adicionar nova conta",
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: this.billRepository.getManyByUserID(this.user.id),
        builder: (BuildContext context, AsyncSnapshot<List<Bill>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text("Sem contas cadastradas"),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => await this.refresh(),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return BillCard(
                  user: this.user,
                  bill: snapshot.data[index],
                  userRepository: this.userRepository,
                  billRepository: this.billRepository,
                  refresh: refresh,
                );
              },
              itemCount: snapshot.data.length,
            ),
          );
        },
      ),
    );
  }
}

class BillCard extends StatefulWidget {
  final User user;
  final Bill bill;
  final UserRepository userRepository;
  final BillRepository billRepository;
  final Function refresh;
  BillCard({this.user, this.bill, this.userRepository, this.billRepository, this.refresh});

  @override
  _BillCardState createState() => _BillCardState(
        user: this.user,
        bill: this.bill,
        userRepository: this.userRepository,
        billRepository: this.billRepository,
        refresh: this.refresh,
      );
}

class _BillCardState extends State<BillCard> {
  final User user;
  final Bill bill;
  final UserRepository userRepository;
  final BillRepository billRepository;
  final Function refresh;
  _BillCardState({this.user, this.bill, this.userRepository, this.billRepository, this.refresh});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime selectedDate;
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MoneyMaskedTextController valueController = MoneyMaskedTextController(leftSymbol: "R\$ ", thousandSeparator: " ");

  bool buttonEnabled = false;
  bool showDescription = false;

  @override
  Widget build(BuildContext context) {
    if (this.bill.status == Bill.PendingStatus && this.bill.expirationDate.isBefore(DateTime.now())) {
      this.billRepository.updateStatus(this.bill, Bill.ExpiredStatus, this.user.id);
      this.bill.status = Bill.ExpiredStatus;
    }
    return GestureDetector(
      onTap: () => setState(() => showDescription = !showDescription),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      this.bill.name,
                      style: TextStyle(
                        color: this.bill.status == Bill.PendingStatus ? null : (this.bill.status == Bill.ExpiredStatus ? Colors.red : Colors.green),
                        fontSize: 25.0,
                      ),
                    ),
                    Text(
                      "R\$ ${this.bill.value.toStringAsFixed(2).replaceAll(".", ",")}",
                      style: TextStyle(
                        color: this.bill.status == Bill.PendingStatus ? null : (this.bill.status == Bill.ExpiredStatus ? Colors.red : Colors.green),
                        fontSize: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Vencimento: ${DateFormat("dd/MMM/yyyy").format(this.bill.expirationDate).toUpperCase()}",
                    style: TextStyle(
                      color: this.bill.status == Bill.PendingStatus ? null : (this.bill.status == Bill.ExpiredStatus ? Colors.red : Colors.green),
                    ),
                  ),
                  Text(
                    this.bill.status == Bill.PendingStatus ? "Pendente" : (this.bill.status == Bill.ExpiredStatus ? "Vencido" : "Pago"),
                    style: TextStyle(
                      color: this.bill.status == Bill.PendingStatus ? null : (this.bill.status == Bill.ExpiredStatus ? Colors.red : Colors.green),
                    ),
                  ),
                ],
              ),
              if (showDescription)
                Column(
                  children: [
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(this.bill.description),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    selectedDate = this.bill.expirationDate;
                                    nameController.value = TextEditingValue(text: this.bill.name);
                                    descriptionController.value = TextEditingValue(text: this.bill.description);
                                    valueController.updateValue(this.bill.value);
                                    dateController.value = TextEditingValue(text: DateFormat("dd/MMM/yyyy").format(selectedDate).toUpperCase());
                                    return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Editar conta"),
                                          content: Container(
                                            width: double.maxFinite,
                                            height: MediaQuery.of(context).size.height * .5,
                                            child: Form(
                                              autovalidateMode: AutovalidateMode.always,
                                              key: formKey,
                                              onChanged: () => setState(() => buttonEnabled = formKey.currentState.validate()),
                                              child: ListView(
                                                children: [
                                                  // nome
                                                  TextFormField(
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                      labelText: "Nome",
                                                    ),
                                                    textCapitalization: TextCapitalization.words,
                                                    textInputAction: TextInputAction.next,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return "A conta deve ter um nome";
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  // descrição
                                                  TextFormField(
                                                    controller: descriptionController,
                                                    decoration: InputDecoration(
                                                      labelText: "Descrição",
                                                    ),
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: null,
                                                    textCapitalization: TextCapitalization.sentences,
                                                    textInputAction: TextInputAction.next,
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  // valor
                                                  TextFormField(
                                                    controller: valueController,
                                                    decoration: InputDecoration(
                                                      labelText: "Valor",
                                                    ),
                                                    keyboardType: TextInputType.number,
                                                    textInputAction: TextInputAction.next,
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return "A conta deve ter um valor";
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  // data de vencimento
                                                  TextFormField(
                                                    // textAlign: TextAlign.center,
                                                    controller: dateController,
                                                    decoration: InputDecoration(
                                                      labelText: "Data de Vencimento",
                                                    ),
                                                    onTap: () async {
                                                      FocusScope.of(context).requestFocus(new FocusNode());

                                                      final picked = await showDatePicker(
                                                        context: context,
                                                        initialDate: selectedDate,
                                                        firstDate: DateTime(DateTime.now().year),
                                                        lastDate: DateTime(DateTime.now().year + 10),
                                                      );
                                                      if (picked != null) {
                                                        setState(() {
                                                          selectedDate = picked;
                                                          dateController.value = TextEditingValue(text: DateFormat("dd/MMM/yyyy").format(picked).toUpperCase());
                                                        });
                                                      }
                                                    },
                                                    textCapitalization: TextCapitalization.characters,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                primary: Colors.red,
                                              ),
                                              child: Text('CANCELAR'),
                                              onPressed: () {
                                                setState(() {
                                                  nameController.clear();
                                                  descriptionController.clear();
                                                  valueController.updateValue(0);
                                                  dateController.clear();
                                                  Navigator.pop(context);
                                                });
                                                this.refresh();
                                              },
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.white,
                                              ),
                                              child: Text('SALVAR'),
                                              onPressed: buttonEnabled
                                                  ? () async {
                                                      this.bill.name = nameController.value.text;
                                                      this.bill.description = descriptionController.value.text;
                                                      this.bill.value = valueController.numberValue;
                                                      this.bill.expirationDate = selectedDate;
                                                      this.bill.status = selectedDate.isBefore(DateTime.now()) ? Bill.ExpiredStatus : Bill.PendingStatus;

                                                      await this.billRepository.update(bill, this.user.id);
                                                      setState(() {
                                                        nameController.clear();
                                                        descriptionController.clear();
                                                        valueController.updateValue(0);
                                                        dateController.clear();
                                                        Navigator.pop(context);
                                                      });
                                                      this.refresh();
                                                    }
                                                  : null,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      await this.billRepository.delete(this.bill, this.user.id);
                                      this.refresh();
                                    }),
                              ],
                            ),
                            if (this.bill.status != Bill.PaidStatus)
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await this.billRepository.updateStatus(this.bill, Bill.PaidStatus, this.user.id);
                                  } catch (_) {
                                    return;
                                  }

                                  setState(() => this.bill.status = Bill.PaidStatus);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green[50],
                                ),
                                child: Text("JÁ PAGUEI"),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
