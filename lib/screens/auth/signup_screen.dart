import 'package:car_sphere/core/utils/custom_msg.dart';
import 'package:car_sphere/widgets/buttons.dart';
import 'package:car_sphere/widgets/text_inputs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSeller = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
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
                'Create Account ✨',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.backgroundDark,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Join CarSphere and start your automotive journey.',
                style: TextStyle(fontSize: 16, color: AppColors.grey),
              ),
              const SizedBox(height: 20),
              const Text(
                'Account Type',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.backgroundDark,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: RoleButton(
                      label: 'Buyer',
                      isSelected: !_isSeller,
                      onTap: () => setState(() => _isSeller = false),
                      icon: Icons.shopping_bag_outlined,
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

              const SizedBox(height: 30),
              AuthTextInput(
                controller: _nameController,
                label: "Full Name",
                hint: "John Doe",
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 15),
              AuthTextInput(
                controller: _emailController,
                label: "Email Address",
                hint: "name@example.com",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 15),
              AuthTextInput(
                controller: _passwordController,
                label: "Password",
                hint: "••••••••",
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 15),

              AuthTextInput(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '+1 234 567 890',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 15),
              AuthTextInput(
                controller: _cityController,
                label: 'City',
                hint: 'New York',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 25),

              const SizedBox(height: 40),
              Consumer<AuthProvider>(
                builder: (context, auth, _) {
                  return PrimaryButton(
                    title: auth.isLoading ? "Please Wait..." : "Sign Up",
                    onPressed: auth.isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await auth.register(
                                username: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                phone: _phoneController.text.trim(),
                                city: _cityController.text.trim(),
                                role: _isSeller ? 'seller' : 'buyer',
                              );
                              if (!context.mounted) return;

                              if (success && mounted) {
                                showCustomMsg(
                                  context: context,
                                  msg:
                                      "Account created successfully! Please Sign In.",
                                );

                                Navigator.pop(context); // Go back to login
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
                    "Already have an account?",
                    style: TextStyle(color: AppColors.grey),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Sign In',
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
