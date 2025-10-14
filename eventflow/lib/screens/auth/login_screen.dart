import 'package:eventflow/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/switch_tile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _remember = true;
  bool _isSubmitting = false;

  bool get _isFormFilled =>
      _emailCtrl.text.trim().isNotEmpty && _passwordCtrl.text.isNotEmpty;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    // TODO: replace with real auth call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed in successfully')));
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
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
                'Welcome Back!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),

              CustomTextField(
                label: 'Email address',
                hint: 'name@example.com',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.email,
                  AutofillHints.username,
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  final r = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
                  if (!r.hasMatch(v.trim())) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                controller: _passwordCtrl,
                textInputAction: TextInputAction.done,
                isPassword: true,
                autofillHints: const [AutofillHints.password],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password is required';
                  if (v.length < 6) return 'At least 6 characters';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              SwitchTile(
                label: 'Remember me',
                value: _remember,
                onChanged: (v) => setState(() => _remember = v),
              ),

              const SizedBox(height: 48),
              CustomButton(
                text: 'Sign in',
                isLoading: _isSubmitting,
                enabled: _isFormFilled && !_isSubmitting,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
