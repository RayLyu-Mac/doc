import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'hive/file_class.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  outputCSVRa(List<List> output) async {
    String csv = const ListToCsvConverter().convert(output);
  }

  List<List<dynamic>> data = [];

  double _screenWidth = 50;
  TextEditingController name = TextEditingController();
  TextEditingController after_namep = TextEditingController();
  TextEditingController after_namer = TextEditingController();
  TextEditingController hist_ind = TextEditingController();
  ScrollController history = ScrollController();
  double _screenH = 50;
  String type = "Monitoring";
  List<int> ravalues = [];
  List<int> prvalues = [];
  List<String> prName = [];
  List<String> raName = [];
  bool validated = true;
  bool del = false;
  String fortime = DateFormat('yMMMMEEEEd j').format(DateTime.now()).toString();
  String SpecNum = "PR";

  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _screenH = MediaQuery.of(context).size.height;
  }

  addPr(String name, String doc_time) {
    final monit_doc = Hive.box('monitor_name');

    int mind = 0;
    if (monit_doc.length == 0) {
      mind = 1;
    } else {
      mind = prvalues[prvalues.length - 1] + 1;
    }

    String docN = "";
    if (mind < 10) {
      docN = "00" + mind.toString();
    } else if (mind < 100 && mind > 9) {
      docN = "0" + mind.toString();
    }

    monit_doc.add(monitoring_doc(name, "CV-PR-$docN-21", doc_time, mind));
    return "CV-PR-$docN-21";
  }

  addRa(String name, String doc_time) {
    final rdh = Hive.box('risk_name');
    int rind = rdh.length + 1;
    String docN = "";
    if (rind < 10) {
      docN = "00" + rind.toString();
    } else if (rind < 100 && rind > 9) {
      docN = "0" + rind.toString();
    }

    rdh.add(rd(name, "CV-RA-$docN-21", doc_time, 2));
    return "CV-RA-$docN-21";
  }

  @override
  Widget build(BuildContext context) {
    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      _screenWidth = MediaQuery.of(context).size.width;
      _screenH = MediaQuery.of(context).size.height;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Documentation Number"),
        ),
        body: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: _screenH / 25, horizontal: _screenWidth / 35),
              padding: EdgeInsets.symmetric(
                  vertical: _screenH / 25, horizontal: _screenWidth / 45),
              decoration: BoxDecoration(
                  border: Border.all(width: 10, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20)),
              width: _screenWidth / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _screenH / 20,
                  ),
                  Text(
                    "Input Area",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _screenH / 20),
                  ),
                  SizedBox(
                    height: _screenH / 20,
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                width: 6, color: Colors.grey.shade300)),
                        errorText: validated
                            ? null
                            : "The input can't be less than 3 character/repeated with one in the database",
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            width: 6,
                            color: Colors.redAccent.shade200,
                          ),
                        ),
                        hintText: "Put the name of the document"),
                  ),
                  SizedBox(
                    height: _screenH / 40,
                  ),
                  Container(
                    width: _screenWidth / 4,
                    child: Row(
                      children: [
                        const Text("Type of report:  "),
                        Container(
                          width: _screenWidth / 6,
                          child: DropdownButton(
                            icon: Icon(Icons.file_copy_outlined),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            isExpanded: true,
                            value: type,
                            onChanged: (values) {
                              setState(() {
                                type = values.toString();
                                switch (values) {
                                  case "Monitoring":
                                    SpecNum = "PR";

                                    break;
                                  case "Risk Assesment":
                                    SpecNum = "RA";
                                    break;
                                }
                              });
                            },
                            items: ["Monitoring", "Risk Assesment"]
                                .toList()
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _screenH / 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RaisedButton(
                          padding: EdgeInsets.symmetric(
                              horizontal: _screenWidth / 40,
                              vertical: _screenH / 40),
                          child: Row(
                            children: [
                              Text("Submit ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _screenH / 35,
                                  )),
                              Icon(Icons.upload)
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              String docN = "";
                              if (SpecNum == "PR") {
                                if (prName.contains(name.text) ||
                                    name.text.length < 3) {
                                  docN =
                                      "Please enter the correct name for the report!";
                                  validated = false;
                                } else {
                                  docN = addPr(name.text, fortime);
                                  validated = true;
                                }
                              } else {
                                if (raName.contains(name.text) ||
                                    name.text == "") {
                                  docN =
                                      "Please enter the correct name for the report!";
                                } else {
                                  docN = addRa(name.text, fortime);
                                }
                              }
                              dialog_mode([
                                Text(
                                  "The documentation number for ${name.text} is:",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _screenH / 20),
                                ),
                                SizedBox(
                                  height: _screenH / 20,
                                ),
                                SelectableText(
                                  docN,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: _screenH / 20,
                                      color: docN !=
                                              "Please enter the correct name for the report!"
                                          ? Colors.greenAccent.shade700
                                          : Colors.redAccent.shade700),
                                ),
                              ]);
                            });
                          }),
                      SizedBox(
                        width: _screenWidth / 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _screenH / 20,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "The history for $type",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _screenH / 30),
                ),
                SizedBox(
                  height: _screenH / 35,
                ),
                Row(
                  children: [
                    Container(
                      width: _screenWidth / 3,
                      child: TextField(
                        controller: hist_ind,
                        decoration: InputDecoration(
                            hintText: "Input either name or the number"),
                      ),
                    ),
                    SizedBox(
                      width: _screenWidth / 35,
                    ),
                    RaisedButton.icon(
                        onPressed: () {
                          int prIndex = 0;
                          if (SpecNum == "PR") {
                            if (int.parse(hist_ind.text) > 0) {
                              prIndex =
                                  prvalues.indexOf(int.parse(hist_ind.text));
                            } else {
                              prIndex = prName.indexOf(hist_ind.text);
                            }

                            if (prIndex != -1) {
                              history.animateTo(prIndex * 70,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            }
                          } else {
                            int raIndex = raName.indexOf(hist_ind.text);
                            if (raIndex != -1) {
                              history.animateTo(raIndex * 70,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            }
                          }
                        },
                        icon: Icon(Icons.search),
                        label: Text("Search History"))
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 3, color: Colors.grey.shade200)),
                  height: _screenH / 1.5,
                  width: _screenWidth / 2,
                  child: switch_case(SpecNum),
                )
              ],
            )
          ],
        ));
  }

  Widget _buildmoni() {
    return WatchBoxBuilder(
      box: Hive.box("monitor_name"),
      builder: (context, contactsBox) {
        return ListView.builder(
          itemCount: contactsBox.length,
          controller: history,
          itemExtent: 70,
          itemBuilder: (BuildContext context, int index) {
            final contact = contactsBox.getAt(index) as monitoring_doc;
            prvalues.add(contact.pr_serial);
            prName.add(contact.name);
            return ListTile(
              title: Row(
                children: [
                  Text("PR Name: " +
                      contact.name +
                      "\nPR Doc: " +
                      contact.mon_docN),
                  IconButton(
                      onPressed: () {
                        dialog_mode([
                          Column(children: [
                            TextField(
                              controller: after_namep,
                              decoration: const InputDecoration(
                                  hintText:
                                      "Please input the change of name here"),
                            ),
                            FlatButton.icon(
                                padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                splashColor: Colors.white.withOpacity(0.7),
                                color: Colors.white.withOpacity(0.1),
                                shape: Border.all(
                                  width: 5,
                                  color: Colors.grey.shade300,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.backspace),
                                label: Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: _screenH / 30),
                                )),
                            SizedBox(
                              width: 50,
                            ),
                            FlatButton.icon(
                                padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                splashColor: Colors.white.withOpacity(0.7),
                                color: Colors.white.withOpacity(0.1),
                                shape: Border.all(
                                  width: 5,
                                  color: Colors.grey.shade300,
                                ),
                                onPressed: () {
                                  setState(() {
                                    String edp = after_namep.text;
                                    if (edp.isNotEmpty && edp != contact.name) {
                                      contactsBox.putAt(
                                          index,
                                          rd(edp, contact.mon_docN, fortime,
                                              2));
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(fontSize: _screenH / 30),
                                )),
                          ])
                        ]);
                      },
                      icon: const Icon(Icons.edit_rounded))
                ],
              ),
              subtitle: Text(contact.doc_time.toString()),
              trailing: IconButton(
                  onPressed: () {
                    showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: Duration(milliseconds: 300),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Container();
                        },
                        transitionBuilder: (context, a1, a2, widget) {
                          return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                  opacity: a1.value,
                                  child: SimpleDialog(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.warning),
                                            Text(contact.name)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            FlatButton.icon(
                                                padding: EdgeInsets.fromLTRB(
                                                    48, 15, 48, 15),
                                                splashColor: Colors.white
                                                    .withOpacity(0.7),
                                                color: Colors.white
                                                    .withOpacity(0.1),
                                                shape: Border.all(
                                                  width: 5,
                                                  color: Colors.grey.shade300,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.backspace),
                                                label: Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      fontSize: _screenH / 30),
                                                )),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            FlatButton.icon(
                                                padding: EdgeInsets.fromLTRB(
                                                    48, 15, 48, 15),
                                                splashColor: Colors.white
                                                    .withOpacity(0.7),
                                                color: Colors.white
                                                    .withOpacity(0.1),
                                                shape: Border.all(
                                                  width: 5,
                                                  color: Colors.grey.shade300,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    contactsBox.deleteAt(index);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.delete),
                                                label: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontSize: _screenH / 30),
                                                )),
                                          ],
                                        )
                                      ],
                                      shape: Border.all(
                                        width: 4,
                                        style: BorderStyle.solid,
                                        color: Colors.white,
                                      ))));
                        });
                  },
                  icon: Icon(Icons.delete)),
            );
          },
        );
      },
    );
  }

  Widget _buildrisk() {
    return WatchBoxBuilder(
      box: Hive.box("risk_name"),
      builder: (context, contactsBox) {
        return ListView.builder(
            itemCount: contactsBox.length,
            itemExtent: 70,
            controller: history,
            itemBuilder: (BuildContext context, int index) {
              final contact = contactsBox.getAt(index) as rd;
              ravalues.add(contact.ra_serial);
              raName.add(contact.rname);
              return ListTile(
                title: Row(
                  children: [
                    Text("RA Name: " +
                        contact.rname +
                        "\nRA Num: " +
                        contact.rdoc_num),
                    IconButton(
                        onPressed: () {
                          dialog_mode([
                            Column(children: [
                              TextField(
                                controller: after_namer,
                                decoration: const InputDecoration(
                                    hintText:
                                        "Please input the change of name here"),
                              ),
                              FlatButton.icon(
                                  padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                  splashColor: Colors.white.withOpacity(0.7),
                                  color: Colors.white.withOpacity(0.1),
                                  shape: Border.all(
                                    width: 5,
                                    color: Colors.grey.shade300,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.backspace),
                                  label: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: _screenH / 30),
                                  )),
                              SizedBox(
                                width: 50,
                              ),
                              FlatButton.icon(
                                  padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                  splashColor: Colors.white.withOpacity(0.7),
                                  color: Colors.white.withOpacity(0.1),
                                  shape: Border.all(
                                    width: 5,
                                    color: Colors.grey.shade300,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      String edr = after_namer.text;
                                      if (edr.isNotEmpty &&
                                          edr != contact.rname) {
                                        contactsBox.putAt(
                                            index,
                                            rd(edr, contact.rdoc_num, fortime,
                                                2));
                                      }
                                    });
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.delete),
                                  label: Text(
                                    "Delete",
                                    style: TextStyle(fontSize: _screenH / 30),
                                  )),
                            ])
                          ]);
                        },
                        icon: const Icon(Icons.edit_rounded))
                  ],
                ),
                subtitle: Text(contact.rdoc_time.toString()),
                trailing: IconButton(
                    onPressed: () {
                      dialog_mode([
                        Row(
                          children: [Icon(Icons.warning), Text(contact.rname)],
                        ),
                        Row(
                          children: [
                            FlatButton.icon(
                                padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                splashColor: Colors.white.withOpacity(0.7),
                                color: Colors.white.withOpacity(0.1),
                                shape: Border.all(
                                  width: 5,
                                  color: Colors.grey.shade300,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.backspace),
                                label: Text(
                                  "Cancel",
                                  style: TextStyle(fontSize: _screenH / 30),
                                )),
                            SizedBox(
                              width: 50,
                            ),
                            FlatButton.icon(
                                padding: EdgeInsets.fromLTRB(48, 15, 48, 15),
                                splashColor: Colors.white.withOpacity(0.7),
                                color: Colors.white.withOpacity(0.1),
                                shape: Border.all(
                                  width: 5,
                                  color: Colors.grey.shade300,
                                ),
                                onPressed: () {
                                  setState(() {
                                    contactsBox.deleteAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.delete),
                                label: Text(
                                  "Delete",
                                  style: TextStyle(fontSize: _screenH / 30),
                                )),
                          ],
                        )
                      ]);

                      shape:
                      Border.all(
                        width: 4,
                        style: BorderStyle.solid,
                        color: Colors.white,
                      );
                    },
                    icon: const Icon(Icons.delete)),
              );
            });
      },
    );
  }

  dialog_mode(List<Widget> dia) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: SimpleDialog(
                  contentPadding: EdgeInsets.fromLTRB(40, 30, 40, 30),
                  children: dia,
                ),
              ));
        });
  }

  switch_case(String box_name) {
    if (box_name == "PR") {
      return _buildmoni();
    } else if (box_name == "RA") {
      return _buildrisk();
    }
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
