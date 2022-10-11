import 'package:flutter_client_for_api_example/pages/dashboard-page.dart';
import 'package:flutter_client_for_api_example/pages/register-page.dart';
import 'package:flutter_client_for_api_example/widgets/example-app-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/button-solid.dart';
import '../widgets/text-input-form-field.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LogInPagState();
}

class _LogInPagState extends State<LoginPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;
  bool loading = false;
  final emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ExampleAppBar(title: 'Login Page', icon: Icons.login),
      ),
      body: Container(
        color: Color(0xff0068e6).withOpacity(0.02),
        child: SingleChildScrollView(
          child: Align(
            alignment: const Alignment(0,-1),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.login, size: 75, color: Color(0xff0068e6)),
                    TextInputFormField(
                      title: 'Email',
                      controller: emailController,
                      key: emailKey,
                    ),
                    TextInputFormField(
                      title: 'Password',
                      controller: passwordController,
                      obscureText: true,
                    ),

                    if(error?.isNotEmpty == true)
                      Container(
                        margin: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(error!, style: const TextStyle(color: Colors.white),),
                      ),

                    if(loading)
                      const CircularProgressIndicator(color: Color(0xff0068e6)),

                    if(!loading)
                      ...[
                        const SizedBox(height: 16,),
                        ButtonSolid(
                          text: 'Login',
                          width: 250,
                          onTap: () {
                            setState(() {
                              error = null;
                            });

                            setState(() {
                              loading = true;
                            });

                            FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                                .then((credential) {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardPage()), (_) => false);
                            }).catchError((error) {
                              setState(() {
                                print(error.toString());
                                loading = false;
                                this.error = 'Please, check your email and password';
                              });
                            });
                          },
                        ),
                        const SizedBox(height: 16,),
                        ButtonSolid(
                          text: 'Register instead',
                          bgColor: Color(0xff0068e6).withOpacity(.5),
                          width: 250,
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ), (_) => false);
                          },
                        ),
                      ],
                    const SizedBox(height: 140,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
