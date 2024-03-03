import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText:
                      !context.watch<AuthProvider>().visibilityPassword,
                  decoration: InputDecoration(
                      hintText: "Password",
                      suffixIcon: IconButton(
                          icon: Icon(
                            context.watch<AuthProvider>().visibilityPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            context.read<AuthProvider>().setVisibility();
                          })),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoadingRegister
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final authRead = context.read<AuthProvider>();
                            if (emailController.text.contains("@")) {
                              if (passwordController.text.length >= 6) {
                                authRead
                                    .doRegister(
                                        nameController.text.toString(),
                                        emailController.text.toString(),
                                        passwordController.text.toString())
                                    .then((value) => {
                                      
                                      if (value) {
                                        widget.onRegister(),
                                        scaffoldMessengerState.showSnackBar(
                                            const SnackBar(
                                                content:
                                                    Text("Register Successfully"),
                                                )),
                                        print("success")
                                      }else{
                                        
                                      }
                                    });
                              } else {
                                scaffoldMessengerState.showSnackBar(const SnackBar(
                                    content: Text(
                                        "Passoword must be at least 6 character"),
                                    margin: EdgeInsets.all(15.0)));
                              }
                            }else {
                              scaffoldMessengerState.showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("please enter a valid email"),
                                      margin: EdgeInsets.all(15.0)));
                            }
                          }
                        },
                        child: const Text("REGISTER"),
                      ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onLogin(),
                  child: const Text("LOGIN"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
