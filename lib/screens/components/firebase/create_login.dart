import 'package:day_note/spec/color_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateLoginPage extends StatefulWidget {
  const CreateLoginPage({super.key});

  @override
  State<CreateLoginPage> createState() => _CreateLoginPageState();
}

class _CreateLoginPageState extends State<CreateLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var emailError = "";
  var passwordError = "";

  void createAccount(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      //If the code reaches here, then the account was successfully created. If there were
      //any errors, it would be caught and code would be run in the catch below this comment.
      result("Account successfully created! Returning to login screen", true);
    } on FirebaseAuthException catch (e) {
      //Reset fields and recheck every error
      setState(() {
        passwordError = "";
        emailError = "";
      });
      if (e.code == 'weak-password') {
        setState(() {
          passwordError = "Password is too weak";
        });
      }
      if (e.code == 'email-already-in-use') {
        setState(() {
          emailError = "E-mail is already in use, please use another";
        });
      }
      if (e.code == 'invalid-email') {
        setState(() {
          emailError = "E-mail must be in format of name@email.xyz";
        });
      }
      if (email.isEmpty) {
        setState(() {
          emailError = "Please type an e-mail";
        });
      }
      if (password.isEmpty) {
        setState(() {
          passwordError = "Please type a password";
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void result(String message, bool success) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (success) {
                Navigator.pop(context, 'Continue');
              }
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: primaryAppColor,
        elevation: 10,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            "Create an account",
            style: TextStyle(fontSize: 30),
          )),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              style: const TextStyle(color: white),
              decoration: InputDecoration(
                labelText: "E-mail",
                hintText: "user@email.xyz",
                helperText: emailError,
                helperStyle: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Must be at least 6 characters long",
                helperText: passwordError,
                helperStyle: const TextStyle(color: Colors.red),
              ),
              obscureText: true,
            ),
          ),
          ElevatedButton(
              onPressed: () =>
                  createAccount(emailController.text, passwordController.text),
              child: const Text("Create")),
        ],
      ),
    );
  }
}
