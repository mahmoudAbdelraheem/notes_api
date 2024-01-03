import 'package:flutter/material.dart';
import 'package:notes_api/app/compnants/crud.dart';
import 'package:notes_api/app/compnants/custom_password_field.dart';
import 'package:notes_api/app/compnants/custom_text_form.dart';
import 'package:notes_api/app/compnants/cutom_button.dart';
import 'package:notes_api/app/compnants/show_snack_bar.dart';
import 'package:notes_api/constant/api_link.dart';
import 'package:notes_api/constant/app_color.dart';
import 'package:notes_api/constant/massage.dart';
import 'package:notes_api/main.dart';

import 'compnants/valid_input.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final Crud _crud = Crud();
  bool _isLoading = false;
  // simple function if the users update the data it will return true
  bool isDataUpdate() {
    if (name.text != shardPref.getString('name') ||
        email.text != shardPref.getString('email') ||
        pass.text != shardPref.getString('password')) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateUsreData(BuildContext newContext) async {
    if (isDataUpdate()) {
      setState(() {
        _isLoading = true;
      });
      var response = await _crud.postRequest(updateUserLink, {
        'user_id': shardPref.getString('id'),
        'new_name': name.text,
        'new_email': email.text,
        'new_pass': pass.text,
      });

      if (response != null && response['status'] == "success") {
        _isLoading = false;
        if (newContext.mounted) {
          showSnackBar(newContext, updateUserDateMsg);
          shardPref.clear();
          Navigator.of(newContext).pushNamedAndRemoveUntil(
            "login",
            (route) => false,
          );
        }
      } else {
        if (newContext.mounted) {
          showSnackBar(newContext, "error in update data");
        }
      }
    } else {
      showSnackBar(newContext, "Enter New Data");
    }
  }

  @override
  void initState() {
    name.text = shardPref.getString('name')!;
    email.text = shardPref.getString('email')!;
    pass.text = shardPref.getString('password')!;
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        elevation: 0.0,
        title: const Text("Setting Page"),
        actions: [
          IconButton(
              onPressed: () {
                shardPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      backgroundColor: appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: buttonBackgrounColor,
                  child: Icon(
                    Icons.person,
                    color: appBackgroundColor,
                    size: 80,
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextForm(
                  hint: 'name',
                  controller: name,
                  keyType: TextInputType.name,
                  valid: (val) {
                    return validInput(val!, 3, 10);
                  },
                ),
                const SizedBox(height: 5),
                CustomTextForm(
                  hint: 'email',
                  controller: email,
                  keyType: TextInputType.emailAddress,
                  valid: (val) {
                    return validInput(val!, 5, 30);
                  },
                ),
                const SizedBox(height: 5),
                CustomPassowrdField(
                  hint: "password",
                  controller: pass,
                  keyType: TextInputType.visiblePassword,
                  valid: (val) {
                    return validInput(val!, 5, 20);
                  },
                ),
                const SizedBox(height: 15),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: indicatorColor,
                        ),
                      )
                    : CustomBotton(
                        txt: 'Update Data',
                        buttonColor: buttonBackgrounColor!,
                        pressed: () {
                          updateUsreData(context);
                        },
                        txtColor: textButtonColor!,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
