import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECHome extends StatefulWidget {
  const ECHome({Key? key}) : super(key: key);

  @override
  State<ECHome> createState() => _ECHomeState();
}

class _ECHomeState extends State<ECHome> {
  TextEditingController prevMonthController = TextEditingController();
  TextEditingController currMonthController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();

  bool isResidential = true; // Default to residential

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Electrical Usage Calculator",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: prevMonthController,
                  decoration: InputDecoration(
                    labelText: 'Previous Month Reading(kWh)',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: currMonthController,
                  decoration: InputDecoration(
                    labelText: 'Current Month Reading(kWh)',
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: true,
                    groupValue: isResidential,
                    onChanged: (value) {
                      setState(() {
                        isResidential = value as bool;
                        rateController.text = '0.095';
                      });
                    },
                  ),
                  Text('Residential'),
                  SizedBox(width: 16),
                  Radio(
                    value: false,
                    groupValue: isResidential,
                    onChanged: (value) {
                      setState(() {
                        isResidential = value as bool;
                        rateController.text = '0.125';
                      });
                    },
                  ),
                  Text('Industrial'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  calculateAndSave();
                },
                child: Text('Calculate Charge and Save'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('RM'),
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: TextField(
                      controller: totalAmountController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Total Amount',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> calculateAndSave() async {
    double prevMonth = double.tryParse(prevMonthController.text) ?? 0.0;
    double currMonth = double.tryParse(currMonthController.text) ?? 0.0;
    double rate = double.tryParse(rateController.text) ?? 0.0;

    double totalAmount = (currMonth - prevMonth) * rate;

    // Saved to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('_prevMonth', prevMonth);
    prefs.setDouble('_currMonth', currMonth);
    prefs.setBool('_selectedRate', isResidential);
    prefs.setDouble('_totalAmount', totalAmount);

    // Reload data into necessary editText and radio button
    setState(() {
      rateController.text = rate.toString();
      totalAmountController.text = totalAmount.toString();
    });
  }
}
