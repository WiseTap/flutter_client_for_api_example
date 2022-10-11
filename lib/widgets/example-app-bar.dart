import 'package:flutter_client_for_api_example/pages/login-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ExampleAppBar extends StatelessWidget {
  final String title;
  final IconData icon;

  const ExampleAppBar({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xff92B4EC),
      // backgroundColor: Color(0xffFFBC80),
      elevation: 0,
      shadowColor: Color(0xff92B4EC),
      centerTitle: true,
      actions: [
        if(FirebaseAuth.instance.currentUser != null)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              child: Ink(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.logout),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut()
                  .then((_) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                  });
              },
            ),
          )
      ],
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white,),
          const SizedBox(width: 15,),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
