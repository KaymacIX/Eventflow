import 'package:eventflow/mainscreen.dart';

import '../../widgets/custom_text_field.dart';
import '../../utils/api_service.dart';
import 'package:flutter/material.dart';
import 'package:eventflow/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isSubmitting = false;

  bool get _isFormFilled =>
      _nameCtrl.text.trim().isNotEmpty &&
      _emailCtrl.text.trim().isNotEmpty &&
      _passwordCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final api = ApiService();
    final response = await api.post(
      '/register', // Replace with your actual register endpoint
      data: {
        'email': _emailCtrl.text.trim(),
        'username': _nameCtrl.text.trim(), // Assuming username is same as name
        'name': _nameCtrl.text.trim(),
        'password': _passwordCtrl.text,
      },
    );

    setState(() => _isSubmitting = false);
    if (response.success) {
      final token = response.responseData?['token'];
      final user = response.responseData?['user'];
      if (token != null) await api.saveToken(token);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', user.toString());
      }
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
    }
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.responseMessage)));
      // TODO: Navigate to login or home page if needed
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          onChanged: () => setState(() {}),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              IconButton(
                onPressed: Navigator.of(context).maybePop,
                icon: const Icon(Icons.arrow_back),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              Text(
                'Create new account',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              CustomTextField(
                label: 'Full name',
                hint: 'Enter your name',
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Full name is required'
                    : null,
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Email address',
                hint: 'name@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final r = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
                  if (!r.hasMatch(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Create password',
                hint: 'Enter your password',
                controller: _passwordCtrl,
                textInputAction: TextInputAction.next,
                isPassword: true,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'At least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Repeat password',
                hint: 'Repeat new password',
                controller: _confirmCtrl,
                textInputAction: TextInputAction.done,
                isPassword: true,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) {
                  if (v == null || v.isEmpty)
                    return 'Please confirm your password';
                  if (v != _passwordCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),

              const SizedBox(height: 48),
              CustomButton(
                text: 'Sign up',
                isLoading: _isSubmitting,
                enabled: _isFormFilled && !_isSubmitting,
                onPressed: _submit,
              ),
              
              const SizedBox(height: 24),
              
              // Sign in link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF13D0A1),
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
