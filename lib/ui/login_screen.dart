import 'package:flutter/material.dart';
import 'package:resepmakanan_5b/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final FormKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  String? emailerror;

  String? passworderror;

  void login(context) async {
    if (FormKey.currentState!.validate()) {
        try {
          final Response = await authService.login(
              emailController.text, passwordController.text);
          if (Response["status"]) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("message")));
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(Response["message"])));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: FormKey,
          child: Column(
            children: [
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
              ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: Text("login")),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  }, child: Text("TIdak punya akun? silahkan register"))
            ],
          ),
        ),
      ),
    );
  }
}

