// import 'package:flutter/material.dart';

// class InboxPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         backgroundColor: Color.fromARGB(255, 196, 139, 240), // You can customize the AppBar color here
//       ),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'No Notifications Here',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16, // Increase the font size for emphasis
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate back to the home page
//                 Navigator.pop(context);
//               },
//               child: const Text('Return To Home Page',
//               style: TextStyle(
//                 fontSize: 14, // Increase the font size for emphasis
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:task_app/core/constants/app_colors.dart';

import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';



class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black,),
            onPressed: () {
              // Handle search icon pressed
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.black,),
            onPressed: () {
              // Handle filter icon pressed
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/onBoarding/inbox.png',
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'No notifications here',
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    // Navigate back to the home page
    Navigator.pop(context);
  },
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 241, 209, 161)), // Change background color
  ),
  child: Text(
    'Go Back to Home', // Change button text
    style: TextStyle(
      fontSize: 16, // Increase the font size for emphasis
      color: Colors.black, // Change text color
    ),
  ),
),
          ],
        ),
      ),
      //floatingActionButton: const AddTaskButton(), // Add the floating action button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomBottomNavigationBar(), // Add the custom bottom navigation bar
    );
  }
}
