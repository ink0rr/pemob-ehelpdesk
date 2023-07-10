import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../models/user_data.dart';
import '../theme.dart';
import '../widgets/async_button.dart';
import '../widgets/intrinsic_layout.dart';
import 'home/home_page.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useMemoized(() => GlobalKey<FormState>(), []);
    final username = useTextEditingController();
    final email = useTextEditingController();
    final password = useTextEditingController();
    final confirmPassword = useTextEditingController();
    final usernameError = useState('');
    final emailError = useState('');
    final passwordError = useState('');
    final hidePassword = useState(true);
    final hideConfirmPassword = useState(true);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: IntrinsicLayout(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.72,
                  ),
                ),
                const SizedBox(height: 32),
                Form(
                  key: form,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        autofillHints: const [AutofillHints.username],
                        controller: username,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9_\.]')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Username',
                        ),
                        onChanged: (_) {
                          usernameError.value = '';
                        },
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please enter a username';
                          }
                          if (value.length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          if (value.length > 20) {
                            return 'Username must be less than 20 characters';
                          }
                          if (usernameError.value != '') {
                            return usernameError.value;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
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
                              hidePassword.value ? Icons.visibility : Icons.visibility_off,
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
                              hideConfirmPassword.value ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              hideConfirmPassword.value = !hideConfirmPassword.value;
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
                            if (form.currentState?.validate() != true) return;

                            await users.where('username', isEqualTo: username.text).get().then((value) {
                              if (value.docs.isNotEmpty) {
                                throw FirebaseAuthException(code: 'username-already-in-use');
                              }
                            });

                            final credentials = await auth.createUserWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );

                            final user = credentials.user;
                            if (user == null) {
                              throw Exception('Failed to register user');
                            }

                            await users.doc(user.uid).set(UserData(
                                  username: username.text,
                                  photoURL:
                                      'https://ui-avatars.com/api/?background=random&name=${username.text.replaceAll(' ', '+')}&size=128&format=png',
                                  role: 'member',
                                  createdAt: DateTime.now(),
                                ));

                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                                (_) => false,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case 'username-already-in-use':
                                usernameError.value = 'Username is already taken';
                              case 'email-already-in-use':
                                emailError.value = 'Email address is already taken';
                                break;
                              case 'invalid-email':
                                emailError.value = 'Please enter a valid email';
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
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Row(
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
                                color: AppTheme.primaryColor,
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
    );
  }
}
