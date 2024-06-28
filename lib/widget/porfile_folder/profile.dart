import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/core/constants/app_colors.dart';
import 'package:task_app/widget/porfile_folder/textBoxPro.dart';
import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';
import 'package:task_app/feature/task/widgets/add_task_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  //editfield
  Future<void> editfield(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('PROFILE', style: TextStyle(color: Colors.black)),
        backgroundColor:AppColors.primary,
      ),
      body: currentUser != null
          ? ListView(
              children: [
                const SizedBox(height: 50),
                // Profile picture
                Center(
                  child: CircleAvatar(
                    radius: 50.0, // Adjust the radius to the desired size
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/avatar/avatar-3.png'),
                    // Ensure the image scales properly within the CircleAvatar
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar/avatar-3.png',
                        fit: BoxFit.cover, // Ensure the image fills the avatar space
                        width: 100.0, // Match width to twice the radius for a proper fit
                        height: 100.0, // Match height to twice the radius for a proper fit
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // User email
                Text(
                  currentUser!.email ?? 'No email available',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
                const SizedBox(height: 20),
                // User details
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                // Text boxes for username and email
                textBOXS(
                  text: 'Username',
                  sectionName: 'username',
                  onPressed: () => editfield('username'),
                ),
                textBOXS(
                  text: 'Email',
                  sectionName: 'email',
                  onPressed: () => editfield('email'),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
