import 'package:flutter/material.dart';

import 'media_library_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  bool _obscurePassword = true;

  bool get _isEmailValid {
    // print('email ' + email + ' is validating');
    if (email.isEmpty) {
      return false;
    }
    return RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);
  }

  bool get _hasMinLength => password.length >= 8;
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(password);
  bool get _hasLowercase => RegExp(r'[a-z]').hasMatch(password);
  bool get _hasSpecialChar =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

  bool get _isPasswordValid =>
      _hasMinLength && _hasUppercase && _hasLowercase && _hasSpecialChar;

  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    final showEmailError = !_isEmailValid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),

              const Text(
                'Please sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),

              EmailField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                showError: showEmailError,
              ),

              const SizedBox(height: 12),
              PasswordField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                hasMinLength: _hasMinLength,
                hasUppercase: _hasUppercase,
                hasLowercase: _hasLowercase,
                hasSpecialChar: _hasSpecialChar,
                obscure: _obscurePassword,
                toggelObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),

              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: LoginButton(enabled: _isFormValid),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool showError;

  const EmailField({
    super.key,
    required this.onChanged,
    required this.showError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: showError ? Colors.red : Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                // decoration: BoxDecoration(
                //   color: showError ? Colors.red.shade100 : Colors.grey.shade100,
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Icon(
                  Icons.mail,
                  size: 32,
                  color: showError ? Colors.red.shade600 : Colors.black,
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EMAIL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: showError
                            ? Colors.red.shade600
                            : Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'you@company.com',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                      ),
                      onChanged: onChanged,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (showError) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade600, size: 16),
              const SizedBox(width: 8),
              Text(
                'Enter a valid email address',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontSize: 12,
                  letterSpacing: -0.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class PasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasSpecialChar;
  final bool obscure;
  final VoidCallback toggelObscure;

  const PasswordField({
    super.key,
    required this.onChanged,
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasSpecialChar,
    required this.obscure,
    required this.toggelObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                // decoration: BoxDecoration(
                //   color: showError ? Colors.red.shade100 : Colors.grey.shade100,
                //   borderRadius: BorderRadius.circular(10),
                // ),
                child: Icon(Icons.lock, size: 32, color: Colors.black),
              ),

              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'At lease 8 characters',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                      ),
                      onChanged: onChanged,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                      obscureText: obscure,
                    ),
                  ],
                ),
              ),

              // const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey.shade500,
                ),
                onPressed: toggelObscure,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requirementRow('8+ characters', hasMinLength),
                  const SizedBox(height: 8),
                  _requirementRow('Uppercase', hasUppercase),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _requirementRow('Lowercase', hasLowercase),
                  const SizedBox(height: 8),
                  _requirementRow('Special character', hasSpecialChar),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _requirementRow(String label, bool met) {
  return Row(
    children: [
      Icon(
        met ? Icons.check_circle : Icons.circle_outlined,
        size: 18,
        color: met ? Colors.green.shade500 : Colors.grey.shade400,
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: met ? Colors.black87 : Colors.grey.shade500,
        ),
      ),
    ],
  );
}

class LoginButton extends StatelessWidget {
  final bool enabled;

  const LoginButton({super.key, required this.enabled});

  void _openMediaLibraryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const MediaLibraryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled
          ? () {
              _openMediaLibraryScreen(context);
            }
          : null,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'LOGIN',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}

// Widget _buildEmailField(bool showError) {
//   return Container(
//     decoration: BoxDecoration(
//       border: Border.all(
//         color: showError ? Colors.red : Colors.grey,
//         width: 1,
//       ),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Row(
//       children: [
//         Container(
//           width: 34,
//           height: 34,
//           // decoration: BoxDecoration(
//           //   color: showError ? Colors.red.shade100 : Colors.grey.shade100,
//           //   borderRadius: BorderRadius.circular(10),
//           // ),
//           child: Icon(
//             Icons.mail_outline,
//             size: 18,
//             color: showError ? Colors.red.shade600 : Colors.grey.shade600,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'EMAIL',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey.shade600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               TextField(
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                 ),
//                 onChanged: (value) {
//                   setState()
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildPasswordField() {
  return Container();
}
