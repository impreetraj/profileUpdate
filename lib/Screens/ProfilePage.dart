import 'package:flutter/material.dart';
import 'package:module/module/profile/UpdateProfile.dart';
import '../module/DBHelper/db_helper.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? number;
  String? email;
  String? address;
  File? photo;

  @override
  void initState() {
    super.initState();
    initDB();
  }

  // Initialize Database
  void initDB() async {
    Map<String, dynamic>? profile =
        await DBHelper.getUser(); // Create an instance of DBHelper
    if (profile != null) {
      setState(() {
        name = profile['name'] ?? '';
        number = profile['phone'] ?? '';
        email = profile['email'] ?? '';
        address = profile['address'] ?? '';
        if (profile['profilePhoto'] != null &&
            profile['profilePhoto'].isNotEmpty) {
          photo = File(profile['profilePhoto']);
        }
      });
    }
  }

  // Method to fetch all notes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Profile"),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Updateprofile(),
                    ));
              },
              icon: Icon(Icons.edit))
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height / 2.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 17,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          blurRadius: 10, // Blur effect
                          spreadRadius: 2, // Spread of shadow
                          offset: const Offset(0, 5), // Shadow position
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: photo != null && photo!.existsSync()
                          ? FileImage(File(photo!.path)) // Ensure valid file
                          : NetworkImage("https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2Fplain-color-background&psig=AOvVaw0T6otMCurdJxCYTxs2KPWz&ust=1739944480365000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCMiArrbEzIsDFQAAAAAdAAAAABAE"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                Center(
                  child: Text(
                    name.toString().toUpperCase(),
                    style:
                        TextStyle(fontSize: 21.0, fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phone No : ",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                      Text(number.toString(),
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("E-mail : ",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                      Text(email.toString(),
                         
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Address : ",
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                      Text(address.toString(),
                          style: TextStyle(
                              fontSize: 17.0, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
