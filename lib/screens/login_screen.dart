import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  bool get _isEmailValid {
    print('email ' + email + ' is validating');
    if (email.isEmpty) {
      return false;
    }
    return RegExp(r'^[\w.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);

  }

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
                  color: showError ? Colors.red.shade600 : Colors.grey.shade600,
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
