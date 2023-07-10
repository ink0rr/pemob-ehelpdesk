import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../constants.dart';
import '../theme.dart';
import '../widgets/async_button.dart';
import '../widgets/intrinsic_layout.dart';
import '../widgets/labeled_checkbox.dart';
import 'home/home_page.dart';
import 'register_page.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useMemoized(() => GlobalKey<FormState>(), []);
    final email = useTextEditingController();
    final password = useTextEditingController();
    final loginError = useState('');
    final hidePassword = useState(true);
    final rememberMe = useState(false);

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
                  'Login',
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
                        autofillHints: const [AutofillHints.email],
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
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
                              hidePassword.value ? Icons.visibility : Icons.visibility_off,
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
                              rememberMe.value = value;
                            },
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.red.shade400,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      AsyncButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          try {
                            if (form.currentState?.validate() != true) return;

                            final credentials = await auth.signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            final user = credentials.user;
                            if (user == null) {
                              throw FirebaseAuthException(code: 'user-not-found');
                            }
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
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: 'Register',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
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
    );
  }
}
