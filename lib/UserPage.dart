import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'RegisterPage.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
class UserPage extends StatefulWidget {
  static const String routeName = '/userPage';

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  /*Future<void> loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      setState(() {
        nameController.text = data['name'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        // Load avatar URL if exists
        if (data['avatar_url'] != null) {
          _imageFile = File(data['avatar_url']); // Adjust based on your implementation
        }
      });
    }
    if(user == null)
      {
        print('no user') ;
      }
  }*/


  Future<void> loadUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final data = await Supabase.instance.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .single();

        setState(() {
          nameController.text = data['name'] ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
        });

        // Load avatar URL if it exists
        if (data['avatar_url'] != null) {
          final avatarUrl = data['avatar_url'];
          try {
            final response = await http.get(Uri.parse(avatarUrl));
            final directory = await getTemporaryDirectory();
            final filePath = '${directory.path}/avatar.png';
            final file = File(filePath);
            await file.writeAsBytes(response.bodyBytes);

            setState(() {
              _imageFile = file;
            });
          } catch (e) {
            print('Failed to load avatar: $e');
          }
        }
      } catch (e) {
        print('Failed to load user data: $e');
      }
    } else {
      print('No user');
    }
  }


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
    await supabase.storage
         .from("avatars")
    .upload('${supabase.auth.currentUser!.id}/avatar.png', _imageFile!);
  }


  Future<void> updateProfile() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase.from('profiles').update({
        'name': nameController.text,
        'phone': phoneController.text
      }).eq('id', user.id);

      if (response.error == null) {
        print("Profile updated successfully.");
      } else {
        print("Failed to update profile: ${response.error.message}");
      }
    } else {
      print("No user is currently logged in.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Personal Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Email"),
              SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              Text("Name"),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 16),
              Text("Phone Number"),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                updateProfile();
                  },
                  child: Text("Save Details"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
