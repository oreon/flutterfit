import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentWeightController =
      TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  String name = '';
  DateTime? dob;
  String gender = '';
  double currentWeight = 0.0;
  double targetWeight = 0.0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != dob) {
      setState(() {
        dob = picked;
      });
    }
  }

  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('dob', dob.toString());
    await prefs.setString('gender', gender);
    await prefs.setDouble('currentWeight', currentWeight);
    await prefs.setDouble('targetWeight', targetWeight);
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      String? dobString = prefs.getString('dob');
      dob = dobString != null ? DateTime.parse(dobString) : null;
      gender = prefs.getString('gender') ?? '';
      currentWeight = prefs.getDouble('currentWeight') ?? 0.0;
      targetWeight = prefs.getDouble('targetWeight') ?? 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = name;
    _currentWeightController.text = currentWeight.toString();
    _targetWeightController.text = targetWeight.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8.0),
                  Text(
                    dob != null
                        ? 'Date of Birth: ${dob!.day}/${dob!.month}/${dob!.year}'
                        : 'Select Date of Birth',
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Gender: '),
                Radio(
                  value: 'Male',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Male'),
                Radio(
                  value: 'Female',
                  groupValue: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value.toString();
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _currentWeightController,
              decoration: InputDecoration(labelText: 'Current Weight'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  currentWeight = double.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _targetWeightController,
              decoration: InputDecoration(labelText: 'Target Weight'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  targetWeight = double.parse(value);
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveProfileData();
                Navigator.pop(context); // Go back to the home screen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
