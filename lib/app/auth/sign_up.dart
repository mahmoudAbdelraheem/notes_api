import 'package:flutter/material.dart';
import 'package:notes_api/app/compnants/crud.dart';
import 'package:notes_api/app/compnants/custom_text_form.dart';
import 'package:notes_api/app/compnants/cutom_button.dart';
import 'package:notes_api/app/compnants/show_snack_bar.dart';
import 'package:notes_api/app/compnants/valid_input.dart';
import 'package:notes_api/constant/api_link.dart';

import '../../constant/app_color.dart';
import '../../constant/massage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  final Crud _crud = Crud();
  bool isLoading = false;

  Future<void> signUpFunc() async {
    if (formState.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var response = await _crud.postRequest(signUpLink, {
        "u_name": nameController.text,
        "u_email": emailController.text,
        "u_pass": passwordController.text,
      });

      if (response["status"] == "success") {
        setState(() {
          isLoading = false;
        });

        print("====================== response = ${response['status']}");
        print("====================== response = $response");

        if (context.mounted) {
          showSnackBar(context, signUpMsg);
          Navigator.of(context)
              .pushNamedAndRemoveUntil("login", (route) => false);
        }
      } else {
        print("Sign Up faild...");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formState,
          child: ListView(
            children: [
              Column(
                children: [
                  const SizedBox(height: 100),
                  Image.asset(
                    "images/logo.png",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 50),
                  CustomTextForm(
                    valid: (val) {
                      return validInput(val!, 3, 10);
                    },
                    hint: 'name',
                    controller: nameController,
                    keyType: TextInputType.name,
                    isPassword: false,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    hint: 'email',
                    controller: emailController,
                    keyType: TextInputType.emailAddress,
                    isPassword: false,
                    valid: (val) {
                      return validInput(val!, 5, 30);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    hint: 'password',
                    controller: passwordController,
                    keyType: TextInputType.text,
                    isPassword: true,
                    valid: (val) {
                      return validInput(val!, 5, 20);
                    },
                  ),
                  const SizedBox(height: 50),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : CustomBotton(
                          txt: "Sign Up",
                          color: Colors.black,
                          pressed: () async {
                            await signUpFunc();
                          },
                          txtColor: Colors.white,
                        ),
                  const SizedBox(height: 10),
                  CustomBotton(
                    txt: "Login",
                    color: Colors.yellow,
                    pressed: () {
                      Navigator.of(context).pushReplacementNamed("login");
                    },
                    txtColor: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
