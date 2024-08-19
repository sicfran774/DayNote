import 'package:day_note/screens/components/firebase/create_login.dart';
import 'package:day_note/screens/components/firebase/upload.dart';
import 'package:day_note/spec/color_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var emailError = "";
  var passwordError = "";
  var userId = "";

  void signIn(String email, String password) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      //If the code reaches here, then the account was successfully signed in. If there were
      //any errors, it would be caught and code would be run in the catch block.
      final user = auth.currentUser;
      if (user != null) {
        userId = user.uid;
      }

      goToUploadScreen(userId);
    } on FirebaseAuthException catch (e) {
      //Reset fields and recheck every error
      setState(() {
        passwordError = "";
        emailError = "";
      });
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        setState(() {
          emailError = 'No user found for that email.';
        });
      }
      if (e.code == 'wrong-password') {
        setState(() {
          passwordError = 'Wrong password provided for that user.';
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

  void goToUploadScreen(String userId) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => UploadScreen(userId: userId)));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return UploadScreen(userId: user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: primaryAppColor,
        elevation: 10,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "E-mail",
                helperText: emailError,
                helperStyle: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                helperText: passwordError,
                helperStyle: const TextStyle(color: Colors.red),
              ),
              obscureText: true,
            ),
          ),
          ElevatedButton(
              onPressed: () =>
                  signIn(emailController.text, passwordController.text),
              child: const Text("Login")),
          const SizedBox(height: 10),
          TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateLoginPage())),
              child: const Text("Create an account")),
        ],
      ),
    );
  }
}
