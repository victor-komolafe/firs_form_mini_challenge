import 'package:firebase_auth/firebase_auth.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/login_screen.dart';
import 'package:firs_mini_project/widgets/platform_alert_widget.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Future<UserCredential?>? _signUpFuture;
  final _formKey1 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool signUpValidatedwithError =
      false; //to handle scenerios where error happens and prevent constant plaatform alert showing on every UI change

  Future<UserCredential> createUserEmailAndPassword() async {
    // This function will handle the user creation logic
    // For example, using Firebase Auth to create a user with email and password
    // FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      debugPrint('User created successfully: ${userCredential.user?.email}');

      debugPrint(userCredential.user.toString());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // final _alert = PlatformAlert(
      //     title: "Error Signing In!", message: e.message.toString());
      // if (mounted) {
      //   _alert.show(context);
      // }
      // debugPrint('Error creating user: ${e.message}');
      throw e.message.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool showPassword = false;
  void validate() async {
    final form = _formKey1.currentState;

    if (form!.validate() == false) {
      return;
    } else {
      signUpValidatedwithError = false;
      _signUpFuture = createUserEmailAndPassword();

      setState(() {});

      // if (!mounted) return;
      // debugPrint('Sign Up pressed: Navigated to Login screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _signUpFuture == null
            ? _signUpScreen()
            : FutureBuilder(
                future: _signUpFuture,
                builder: (context, snapshot) {
                  {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError &&
                        signUpValidatedwithError == false) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final alert = PlatformAlert(
                            title: "Sign Up Failed",
                            message: snapshot.error.toString());
                        if (mounted) {
                          alert.show(context);
                        }
                        setState(() {
                          signUpValidatedwithError = true;
                        });
                      });
                      return _signUpScreen();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.data != null && mounted) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            const alert = PlatformAlert(
                                title: "User Successfully created",
                                message: "Login to fill the form");
                            _emailController.clear();
                            _passwordController.clear();
                            alert.show(context);
                            DefaultTabController.of(context).animateTo(0);
                          }
                        });
                        return const SizedBox.shrink();
                      } else {
                        // Login failed (no user returned)
                        return _signUpScreen();
                      }
                    }
                    return _signUpScreen();
                  }
                }));
  }

  Widget _signUpScreen() {
    return Form(
        key: _formKey1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _nameController,
              formTitleText: 'Name',
              hintText: 'Enter your Name',
              validator: (text) =>
                  text!.isEmpty ? 'Name cannot be empty' : null,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                controller: _emailController,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Email cannot be empty';
                  } else {
                    final regex = RegExp('[^@]+@[^.]+..+');
                    if (!regex.hasMatch(text)) {
                      return 'Enter a valid Email';
                    }
                    return null;
                  }
                },
                formTitleText: 'Your Email',
                hintText: 'Enter your email'),
            const SizedBox(
              height: 20,
            ),
            Text('Password', style: ConstantFonts.inter),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              obscureText: showPassword == false ? true : false,
              decoration: InputDecoration(
                suffixIcon: InkWell(
                    onTap: () {
                      showPassword = !showPassword;
                      setState(() {});
                    },
                    child: showPassword == false
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors.black12,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors.black12,
                          )),
                errorBorder: Constants.globalOnErrorBorderStyle,
                focusedBorder: Constants.globalOnSelectedBorderStyle,
                focusedErrorBorder: Constants.globalOnErrorBorderStyle,
                hintText: 'Enter your password',
                enabledBorder: Constants.globalFormBorderStyle,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),

                // label: Text('Your Email'),
              ),
              validator: (text) {
                if (text!.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
                child: InkWell(
              onTap: validate,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: Constants.globalBorderRadius),
                  child: Text(
                    'Sign Up',
                    style: ConstantFonts.inter.copyWith(color: Colors.white),
                  )),
            )),
            Row(
              children: [
                Text('Already registered ?',
                    style: ConstantFonts.inter.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54)),
                // const SizedBox(width: 10),
                Builder(
                  builder: (tabContext) => TextButton(
                    onPressed: () {
                      debugPrint('Login pressed: Navigated to Sign Up screen');
                      DefaultTabController.of(tabContext).animateTo(0);
                    },
                    child: Text('Login',
                        style: ConstantFonts.inter.copyWith(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
