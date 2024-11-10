import 'package:flutter/material.dart';
import 'package:resepmakanan_5b/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final retypepasswordController = TextEditingController();

  final FormKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  String? nameerror;

  String? emailerror;

  String? passworderror;

  void register(context) async {
    if (FormKey.currentState!.validate()) {
      if (passwordController.text == retypepasswordController.text) {
        try {
          final Response = await authService.register(nameController.text,
              emailController.text, passwordController.text);
          if (Response["status"]) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("message")));
                Navigator.pushReplacementNamed(context, '/home');
          } else {
            setState(() {
              nameerror = Response["error"]["name"]?[0];
              emailerror = Response["error"]["email"]?[0];
              passworderror = Response["error"]["password"]?[0];
            });
          }
        } catch (e) {
                  ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: $e")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Password don't match")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: FormKey,
          child: Column(
            children: [
              //name
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
                decoration:
                    InputDecoration(labelText: "Name", errorText: nameerror),
              ),
              //Email
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your Email";
                  }
                  return null;
                },
                decoration:
                    InputDecoration(labelText: "Email", errorText: emailerror),
              ),
              //Password
              TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Password", errorText: passworderror),
                obscureText: true,
              ),
              //Retake Password
              TextFormField(
                controller: retypepasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please retype your password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: "Retype Password", errorText: passworderror),
                obscureText: true,
              ),
              ElevatedButton(
                  onPressed: () {
                    register(context);
                  },
                  child: Text("Register"))
            ],
          ),
        ),
      ),
    );
  }
}
