import 'dart:io';

import 'package:ehelpdesk/widgets/async_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_page.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final emailError = useState('');
    final passwordError = useState('');
    final hidePassword = useState(true);
    final hideConfirmPassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 64),
                        const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.72),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          autofillHints: const [AutofillHints.email],
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          onChanged: (_) {
                            emailError.value = '';
                          },
                          validator: (value) {
                            if (!EmailValidator.validate(value ?? '')) {
                              return 'Please enter a valid email';
                            }
                            if (emailError.value != '') {
                              return emailError.value;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          autofillHints: const [AutofillHints.password],
                          controller: password,
                          obscureText: hidePassword.value,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIconColor: Colors.grey,
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                hidePassword.value = !hidePassword.value;
                              },
                            ),
                          ),
                          onChanged: (_) {
                            passwordError.value = '';
                          },
                          validator: (value) {
                            if (value == null || value == '') {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (passwordError.value != '') {
                              return passwordError.value;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          autofillHints: const [AutofillHints.password],
                          controller: confirmPassword,
                          obscureText: hideConfirmPassword.value,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIconColor: Colors.grey,
                            suffixIcon: IconButton(
                              icon: Icon(
                                hideConfirmPassword.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                hideConfirmPassword.value =
                                    !hideConfirmPassword.value;
                              },
                            ),
                          ),
                          onChanged: (_) {
                            passwordError.value = '';
                          },
                          validator: (value) {
                            if (value == '') {
                              return 'Please enter a password';
                            }
                            if (value != password.text) {
                              return 'Passwords do not match';
                            }
                            if (passwordError.value != '') {
                              return passwordError.value;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        AsyncButton(
                          child: const Text('Register'),
                          onPressed: () async {
                            try {
                              final credentials = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              if (credentials.user != null && context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (_) => false,
                                );
                              }
                            } on FirebaseAuthException catch (e) {
                              switch (e.code) {
                                case 'email-already-in-use':
                                  emailError.value =
                                      'Email address is already taken';
                                  break;
                                case 'invalid-email':
                                  emailError.value =
                                      'Please enter a valid email';
                                  break;
                                case 'weak-password':
                                  passwordError.value = 'Password is too weak';
                                  break;
                                default:
                                  rethrow;
                              }
                            }
                          },
                        ),
                        if (Platform.isAndroid)
                          Column(
                            children: [
                              const SizedBox(height: 24),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      endIndent: 12,
                                      thickness: 2,
                                    ),
                                  ),
                                  Text('or continue with'),
                                  Expanded(
                                    child: Divider(
                                      indent: 12,
                                      thickness: 2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Ink(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: SvgPicture.asset(
                                        'assets/icons/google.svg'),
                                  ),
                                  onTap: () async {
                                    final credentials = await FirebaseAuth
                                        .instance
                                        .signInWithProvider(
                                            GoogleAuthProvider());

                                    if (credentials.user != null &&
                                        context.mounted) {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) => const HomePage(),
                                      ));
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  text: 'Already have an account? ',
                                  children: [
                                    TextSpan(
                                      text: 'Login',
                                      style: const TextStyle(
                                        color: Color(0xFF6AB17E),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).pop();
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
