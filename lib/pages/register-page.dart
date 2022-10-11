import 'package:flutter_client_for_api_example/data/custom-claims.dart';
import 'package:flutter_client_for_api_example/main.dart';
import 'package:flutter_client_for_api_example/pages/dashboard-page.dart';
import 'package:flutter_client_for_api_example/widgets/example-app-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/api.dart';
import '../widgets/button-solid.dart';
import '../widgets/snackbar.dart';
import '../widgets/text-input-form-field.dart';
import 'loading-page.dart';
import 'login-page.dart';




class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  CustomClaims selectedRole = CustomClaims.storeOwner;
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(55),
        child: ExampleAppBar(title: 'Register Page', icon: Icons.app_registration),
      ),
      body: Container(
        color: Color(0xff0068e6).withOpacity(0.02),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment(0,-1),
            child: Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.app_registration_rounded, size: 75, color: Color(0xff0068e6)),
                  TextInputFormField(
                    title: 'Name',
                    controller: nameController,
                  ),
                  TextInputFormField(
                    title: 'Email',
                    controller: emailController,
                  ),
                  TextInputFormField(
                    title: 'Password',
                    controller: passwordController1,
                    obscureText: true,
                  ),
                  TextInputFormField(
                    title: 'Insert the password again',
                    controller: passwordController2,
                    obscureText: true,
                  ),
                  const SizedBox(height: 10,),
                  FormFieldWithTitle(
                    title: 'Custom Claims on Firebase Authentication',
                    child: Column(
                      children: CustomClaims.values.map(
                              (customClaim) => RadioListTile<CustomClaims>(
                              title: Text(customClaimsToPlainText(customClaim), style: const TextStyle(color: Color(0xff0068e6)), ),
                              value: customClaim,
                              groupValue: selectedRole,
                              onChanged: (v){
                                setState(() {
                                  if(v!=null) {
                                    selectedRole = v;
                                  }
                                });
                              }
                          )
                      ).toList(),
                    ),
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
                        text: 'Register',
                        width: 250,
                        onTap: () {
                          setState(() {
                            error = null;
                          });

                          if(passwordController1.text != passwordController2.text){
                            setState(() {
                              error = 'The passwords doesn\'t match';
                            });
                            return;
                          }

                          setState(() {
                            loading = true;
                          });

                          Api().createAccount(name: nameController.text, email: emailController.text, password: passwordController1.text, role: selectedRole)
                              .then((res) {
                            res.fold((httpError) {
                              setState(() {
                                error = httpError.description;
                                loading = false;
                              });
                            }, (r) {
                              FirebaseAuth.instance
                                  .signInWithEmailAndPassword(email: emailController.text, password: passwordController1.text)
                                  .then((_) {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DashboardPage(),),(_) => false,);
                                  });
                            });
                          });
                        },
                      ),
                      const SizedBox(height: 16,),
                      ButtonSolid(
                        text: 'Login instead',
                        bgColor: Color(0xff0068e6).withOpacity(.5),
                        width: 250,
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
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
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    super.dispose();
  }
}
