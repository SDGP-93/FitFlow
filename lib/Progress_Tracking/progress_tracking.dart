import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//import 'package:firebase_core/firebase_core.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(MaterialApp(
    home: WeightSetPage(),
  ));
}

class WeightSetPage extends StatefulWidget {
  const WeightSetPage({Key? key}) : super(key: key);

  @override
  _WeightSetPageState createState() => _WeightSetPageState();
}

class _WeightSetPageState extends State<WeightSetPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController weekController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  List<Map<String, String>> weightData = [];

  @override
  void initState() {
    super.initState();
  }

  void showGraph() {
    String week = weekController.text;
    String weight = weightController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Weight and Week'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
              keyboardType: TextInputType.phone,
            ),
            /*ElevatedButton(
              onPressed:() {
                //CollectionReference collRef = FirebaseFirestore.instance.collection('client');
                collRef.add({
                  'name' : nameController.text,
                  'email' : emailController.text,
                  'mobile' : mobileController.text,
                }
                );
              },
                child: const Text('Add Client'),
              ),*/
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weekController,
              decoration: InputDecoration(labelText: 'Week'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showGraph,
              child: Text('Show Graph'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: WeightGraph(weightData),
            ),
          ],
        ),
      ),
    );
  }
}

class WeightGraph extends StatelessWidget {
  final List<Map<String, String>> weightData;

  WeightGraph(this.weightData);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Map<String, String>, int>> seriesList = [
      charts.Series<Map<String, String>, int>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (datum, _) => int.parse(datum['week']!),
        measureFn: (datum, _) => int.parse(datum['weight']!),
        data: weightData,
      )
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: charts.LineChart(
        seriesList,
        animate: true,
      ),
    );
  }
}
