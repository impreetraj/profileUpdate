import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:module/module/home/HomePage.dart';
import '../DBHelper/db_helper.dart';

class Updateprofile extends StatefulWidget {
  @override
  _UpdateprofileState createState() => _UpdateprofileState();
}

class _UpdateprofileState extends State<Updateprofile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data from database
  void _loadUserData() async {
    Map<String, dynamic>? user = await DBHelper.getUser();
    if (user != null) {
      setState(() {
        nameController.text = user['name'] ?? '';
        phoneController.text = user['phone'] ?? '';
        emailController.text = user['email'] ?? '';
        addressController.text = user['address'] ?? '';
        if (user['profilePhoto'] != null && user['profilePhoto'].isNotEmpty) {
          _imageFile = File(user['profilePhoto']);
        }
      });
    }
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Save user profile
  void _saveProfile() async {
    Map<String, dynamic> user = {
      'id': 1, // Keeping a single user profile, ID fixed
      'name': nameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'address': addressController.text,
      'profilePhoto': _imageFile?.path ?? '',
    };

    await DBHelper.updateUser(user);
   
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
    else{
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Please Fill First")));
    }
    // nameController.clear();
    // phoneController.clear();
    // emailController.clear();
    // addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Health Align")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      _imageFile != null ? FileImage(_imageFile!) : null,
                  child: _imageFile == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Name", nameController),
              _buildTextField("Phone", phoneController),
              _buildTextField("Email", emailController),
              _buildTextField("Address", addressController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text("Save Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
