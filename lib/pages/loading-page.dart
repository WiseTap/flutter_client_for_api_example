import 'package:flutter_client_for_api_example/pages/dashboard-page.dart';
import 'package:flutter_client_for_api_example/pages/login-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(FirebaseAuth.instance.currentUser == null) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (_) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardPage()), (_) => false);
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Color(0xff0068e6)),
      ),
    );
  }
}
