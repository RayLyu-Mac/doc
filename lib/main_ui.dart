import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _screenWidth = 50;
  double _screenH = 50;
  String type = "Monitoring";
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _screenH = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController name = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Documentation Number"),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: _screenH / 20,
              ),
              TextField(
                controller: name,
                decoration: const InputDecoration(
                    hintText: "Put the name of the document"),
              ),
              SizedBox(
                height: _screenH / 40,
              ),
              Row(
                children: [
                  const Text("Type of report"),
                  DropdownButton(
                    value: type,
                    onChanged: (value) {
                      setState(() {
                        type = value;
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
                  )
                ],
              )
            ],
          ),
        ));
  }
}
