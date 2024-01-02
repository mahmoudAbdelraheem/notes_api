import 'package:flutter/material.dart';
import 'package:notes_api/app/compnants/crud.dart';
import 'package:notes_api/app/compnants/custom_text_form.dart';
import 'package:notes_api/app/compnants/cutom_button.dart';
import 'package:notes_api/app/compnants/valid_input.dart';
import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool _isLoading = false;
  final Crud _crud = Crud();

  Future<void> logInFunc() async {
    if (formState.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      var response = await _crud.postRequest(loginLink, {
        "u_email": emailController.text,
        "u_pass": passwordController.text,
      });

      if (response['status'] == "success") {
        setState(() {
          _isLoading = false;
        });

        shardPref.setString("id", response['data']['u_id'].toString());
        shardPref.setString("name", response['data']['u_name']);
        shardPref.setString("email", response['data']['u_email']);
        shardPref.setString("password", response['data']['u_pass']);
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homePage", (route) => false);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        print("login faild=============");
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow[200],
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
                      return validInput(val!, 5, 30);
                    },
                    hint: 'email',
                    controller: emailController,
                    keyType: TextInputType.emailAddress,
                    isPassword: false,
                  ),
                  const SizedBox(height: 10),
                  CustomTextForm(
                    valid: (val) {
                      return validInput(val!, 5, 20);
                    },
                    hint: 'password',
                    controller: passwordController,
                    keyType: TextInputType.text,
                    isPassword: true,
                  ),
                  const SizedBox(height: 50),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.orange,
                        )
                      : CustomBotton(
                          txt: "Login",
                          color: Colors.black,
                          pressed: () async {
                            await logInFunc();
                          },
                          txtColor: Colors.white,
                        ),
                  const SizedBox(height: 10),
                  CustomBotton(
                    txt: "Sign Up?",
                    color: Colors.yellow,
                    pressed: () {
                      Navigator.of(context).pushReplacementNamed("signUp");
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
