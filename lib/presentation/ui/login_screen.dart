import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginScreen({Key? key, required this.onLogin, required this.onRegister})
      : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Screen"),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'password',
                            filled: true,
                            suffixIcon: IconButton(
                                icon: Icon(
                                  context
                                          .watch<AuthProvider>()
                                          .visibilityPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  context.read<AuthProvider>().setVisibility();
                                })),
                      ),
                      const SizedBox(height: 8),
                      context.watch<AuthProvider>().isLoadingLogin
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _handleLogin,
                              child: const Text("LOGIN"),
                            ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => widget.onRegister(),
                        child: const Text("REGISTER"),
                      ),
                    ])),
          ),
        ));
  }
  
  
Future<void> _handleLogin() async {
  if (formKey.currentState!.validate()) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final authRead = context.read<AuthProvider>();
    final isLoggedIn = await authRead.doLogin(
        emailController.text.toString(), passwordController.text.toString());

    if (isLoggedIn) {
      widget.onLogin();
    } else {
      scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text("Invalid username or password")));
    }
  }
}
}
