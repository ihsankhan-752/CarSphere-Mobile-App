import 'package:car_sphere/core/utils/custom_msg.dart';
import 'package:car_sphere/widgets/buttons.dart';
import 'package:car_sphere/widgets/text_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSeller = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(backgroundColor: AppColors.white, elevation: 0),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundDark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sign in to continue exploring your dream cars.',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 30),
              const Text(
                'Login As',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundDark,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: RoleButton(
                      label: "Buyer",
                      isSelected: !_isSeller,
                      onTap: () => setState(() => _isSeller = false),
                      icon: Icons.person_outline,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: RoleButton(
                      label: 'Seller',
                      isSelected: _isSeller,
                      onTap: () => setState(() => _isSeller = true),
                      icon: Icons.storefront_outlined,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AuthTextInput(
                controller: _emailController,
                label: "Email",
                hint: "name@gmail.com",
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              AuthTextInput(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return PrimaryButton(
                    title: auth.isLoading ? "Please Wait...." : "Login",
                    onPressed: auth.isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await auth.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                _isSeller ? 'seller' : 'buyer',
                              );

                              if (!context.mounted) return;
                              if (success) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.home,
                                );
                              } else {
                                if (auth.error != null) {
                                  showCustomMsg(
                                    context: context,
                                    msg: auth.error!,
                                    bgColor: Colors.red,
                                  );
                                }
                              }
                            }
                          },
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: AppColors.grey),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
