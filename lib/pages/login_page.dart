import 'dart:io';

import 'package:ehelpdesk/pages/register_page.dart';
import 'package:ehelpdesk/widgets/labeled_checkbox.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
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
    final isLoading = useState(false);

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
                        if (isLoading.value)
                          const ElevatedButton(
                            onPressed: null,
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        else
                          ElevatedButton(
                            child: const Text('Login'),
                            onPressed: () async {
                              try {
                                isLoading.value = true;
                                final credentials = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );
                                if (credentials.user != null &&
                                    context.mounted) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (_) => false,
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'user-not-found':
                                  case 'wrong-password':
                                    loginError.value =
                                        'Incorrect email or password';
                                    break;
                                  default:
                                    rethrow;
                                }
                              } finally {
                                isLoading.value = false;
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
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                        (_) => false,
                                      );
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
                                  text: "Don't have an account? ",
                                  children: [
                                    TextSpan(
                                      text: 'Register',
                                      style: const TextStyle(
                                        color: Color(0xFF6AB17E),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage(),
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
