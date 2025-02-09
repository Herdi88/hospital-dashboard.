import 'package:flutter/material.dart';

void main() {
  runApp(HospitalApp());
}

class HospitalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List appointments = [];
  List patients = [];
  List surgeries = [];
  int nextDayAppointments = 0;
  int emergencyPatients = 0;
  int calls = 0;

  String surgeryFilter = '';
  String patientFilter = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    setState(() {
      appointments = [
        {"Patient Name": "روژين آرام عباس", "Resource": "د. دلمن محمد رؤوف"},
        {"Patient Name": "علي كريم", "Resource": "د. سمير احمد"},
      ];

      patients = [
        {"name": "محمد", "status": "مقبول"},
        {"name": "سارة جمال", "status": "مقبول"},
      ];

      surgeries = [
        {"doctor": "د. احمد", "count": 5},
        {"doctor": "د. سليم", "count": 3},
      ];

      nextDayAppointments = 25;
      emergencyPatients = 10;
      calls = 150;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لوحة بيانات المستشفى"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildOverviewCard("عدد المواعيد", appointments.length.toString()),
              buildOverviewCard(
                  "عدد مواعيد اليوم التالي", nextDayAppointments.toString()),
              buildOverviewCard(
                  "عدد المرضى في الطوارئ", emergencyPatients.toString()),
              buildOverviewCard("عدد المكالمات", calls.toString()),
              buildFilterableSurgeriesCard(),
              buildFilterablePatientsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOverviewCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.info, color: Colors.blue),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget buildFilterableSurgeriesCard() {
    List filteredSurgeries = surgeries.where((surgery) {
      return surgery['doctor'] != null &&
          surgery['doctor'].toLowerCase().contains(surgeryFilter.toLowerCase());
    }).toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.local_hospital, color: Colors.green),
            title: Text("عدد العمليات وأسماء الأطباء"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "فلتر حسب اسم الطبيب",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  surgeryFilter = value;
                });
              },
            ),
          ),
          if (filteredSurgeries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("لا توجد نتائج", style: TextStyle(color: Colors.grey)),
            ),
          ...filteredSurgeries.map((surgery) {
            return ListTile(
              title: Text(surgery['doctor']),
              subtitle: Text("عدد العمليات: ${surgery['count']}"),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildFilterablePatientsCard() {
    List filteredPatients = patients.where((patient) {
      return patient['name'] != null &&
          patient['name'].toLowerCase().contains(patientFilter.toLowerCase());
    }).toList();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.person, color: Colors.purple),
            title: Text("عدد المرضى المقبولين حاليا وأسمائهم"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "فلتر حسب اسم المريض",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  patientFilter = value;
                });
              },
            ),
          ),
          if (filteredPatients.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("لا توجد نتائج", style: TextStyle(color: Colors.grey)),
            ),
          ...filteredPatients.map((patient) {
            return ListTile(
              title: Text(patient['name']),
              subtitle: Text("الحالة: ${patient['status']}"),
            );
          }).toList(),
        ],
      ),
    );
  }
}
