import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                title: Text(notification['title']),
                subtitle: Text(notification['body']),
                trailing: Text(notification['time']),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';

// import 'package:task_app/widget/common/custom_bottom_navigation_bar.dart';
// import 'package:task_app/widget/task/add_task_button.dart';



// class InboxPage extends StatelessWidget {
//   const InboxPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Inbox'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Handle search icon pressed
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () {
//               // Handle filter icon pressed
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.inbox,
//               size: 120,
//               color: Colors.blue,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'No notifications yet',
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//       //floatingActionButton: const AddTaskButton(), // Add the floating action button
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       bottomNavigationBar: const CustomBottomNavigationBar(), // Add the custom bottom navigation bar
//     );
//   }
// }
