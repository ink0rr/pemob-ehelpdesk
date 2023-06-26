import 'dart:io';

import 'package:ehelpdesk/widgets/labeled_checkbox.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home_page.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useTextEditingController();
    final password = useTextEditingController();
    final loginError = useState('');
    final hidePassword = useState(true);
    final rememberMe = useState(false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
                  const Text(
                    'Login',
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
                      loginError.value = '';
                    },
                    validator: (value) {
                      if (!EmailValidator.validate(value ?? '')) {
                        return 'Please enter a valid email';
                      }
                      if (loginError.value != '') {
                        return loginError.value;
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
                      loginError.value = '';
                    },
                    validator: (value) {
                      if (value == '') {
                        return 'Please enter a password';
                      }
                      if (loginError.value != '') {
                        return loginError.value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabeledCheckbox(
                        label: 'Remember me',
                        value: rememberMe.value,
                        onChanged: (value) {
                          rememberMe.value = value!;
                        },
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFFF52F2F),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () async {
                      try {
                        final credentials = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text,
                        );
                        if (credentials.user != null && context.mounted) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                        }
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case 'user-not-found':
                          case 'wrong-password':
                            loginError.value = 'Incorrect email or password';
                            break;
                          default:
                            rethrow;
                        }
                      }
                    },
                  ),
                  if (Platform.isAndroid)
                    Column(children: [
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
                            child: SvgPicture.asset('assets/icons/google.svg'),
                          ),
                          onTap: () async {
                            final credentials = await FirebaseAuth.instance
                                .signInWithProvider(GoogleAuthProvider());

                            if (credentials.user != null && context.mounted) {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ));
                            }
                          },
                        ),
                      )
                    ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
