import 'dart:io';

import 'package:axel/features/Auth/bloc/auth_bloc.dart';
import 'package:axel/features/Auth/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  DateTime? dob;
  String? imagePath;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _isStrongPassword(String p) {
    return p.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(p) &&
        RegExp(r'[0-9]').hasMatch(p);
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );
    if (picked != null) setState(() => dob = picked);
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => imagePath = image.path);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate() ||
        dob == null ||
        imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    final user = User(
      username: _usernameCtrl.text.trim(),
      fullName: _fullNameCtrl.text.trim(),
      password: _passwordCtrl.text,
      imagePath: imagePath!,
      dob: dob!,
    );

    context.read<AuthBloc>().add(RegisterRequested(user));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pop(context);
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                Text(
                  'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Fill in the details to get started',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 32),

                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : null,
                      child: imagePath == null
                          ? Icon(
                              Icons.camera_alt_outlined,
                              size: 28,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Username required' : null,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _fullNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Full name required'
                            : null,
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v != null && _isStrongPassword(v)
                            ? null
                            : 'Min 8 chars, 1 capital, 1 number',
                      ),

                      const SizedBox(height: 16),

                      InkWell(
                        onTap: _pickDob,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.cake_outlined),
                              const SizedBox(width: 12),
                              Text(
                                dob == null
                                    ? 'Select Date of Birth'
                                    : dob!.toLocal().toString().split(' ')[0],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading ? null : _submit,
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Register'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
