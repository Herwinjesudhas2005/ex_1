import 'package:flutter/material.dart';
import 'student.dart';
import 'database_helper.dart';

void main() {
  runApp(MaterialApp(
    title: "Students Info Management",
    debugShowCheckedModeBanner: false,
    home: StudentsADD(),
  ));
}

class StudentsADD extends StatefulWidget {
  const StudentsADD({super.key});

  @override
  State<StudentsADD> createState() => _StudentsADDState();
}

class _StudentsADDState extends State<StudentsADD> {
  final _formkey = GlobalKey<FormState>();
  final _namecontroller = TextEditingController();
  final _regnocontroller = TextEditingController();
  final _cgpacontroller = TextEditingController();

  List<Student> _students = [];

  void _showAllStudents() async {
    final students = await DatabaseHelper.instance.readAllStudents();
    setState(() {
      _students = students;
    });
  }

  @override
  void initState() {
    super.initState();
    _showAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Information Management"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _namecontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Student Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Student Name!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _regnocontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Student Reg No",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Student Reg No!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cgpacontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Student CGPA",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter CGPA!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    String name = _namecontroller.text;
                    String regno = _regnocontroller.text;
                    double cgpa = double.parse(_cgpacontroller.text);

                    Student student =
                        Student(name: name, regno: regno, cgpa: cgpa);

                    await DatabaseHelper.instance.insertStudent(student);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data Saved Successfully")),
                    );

                    _namecontroller.clear();
                    _regnocontroller.clear();
                    _cgpacontroller.clear();
                    _showAllStudents();
                  }
                },
                child: const Text("Save Details"),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(student.name[0].toUpperCase()),
                        ),
                        title: Text(student.name),
                        subtitle: Text(
                            "Reg No: ${student.regno} | CGPA: ${student.cgpa.toStringAsFixed(2)}"),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
