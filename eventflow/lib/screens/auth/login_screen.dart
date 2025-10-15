import 'package:provider/provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/switch_tile.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:eventflow/widgets/custom_button.dart';
import 'register_screen.dart';
import '../../mainscreen.dart';

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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
      remember: _remember,
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Force navigation to home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials.')),
      );
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
              
              const SizedBox(height: 24),
              
              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign up',
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
