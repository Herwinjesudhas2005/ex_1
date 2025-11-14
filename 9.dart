import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const UpdateApp());
}

class UpdateApp extends StatelessWidget {
  const UpdateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Firestore Update Example",
      debugShowCheckedModeBanner: false,
      home: UpdatePage(),
    );
  }
}

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _regController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // ✅ Update student using register number (NOT document ID)
  Future<void> updateStudent() async {
    try {
      String regNo = _regController.text.trim();

      // STEP 1: Search for student with matching register number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("students")
          .where("regNo", isEqualTo: regNo)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No student found with this Register Number!")),
        );
        return;
      }

      // STEP 2: Get matched document ID
      String docId = querySnapshot.docs.first.id;

      // STEP 3: Update the document
      await FirebaseFirestore.instance
          .collection("students")
          .doc(docId)
          .update({
        "name": _nameController.text.trim(),
        "dept": _deptController.text.trim(),
        "age": int.parse(_ageController.text.trim()),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Student Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _regController,
              decoration: const InputDecoration(
                labelText: "Register No",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _deptController,
              decoration: const InputDecoration(
                labelText: "Department",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: updateStudent,
              child: const Text("UPDATE"),
            ),
          ],
        ),
      ),
    );
  }
}
