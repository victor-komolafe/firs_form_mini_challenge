import 'package:firebase_auth/firebase_auth.dart';
import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/sign_up_screen.dart';
import 'package:firs_mini_project/widgets/platform_alert_widget.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;

  // Future<bool> signInUserEmailAndPassword() async {
  //   try {
  //     final userCredential = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: _emailController.text.trim(),
  //             password: _passwordController.text.trim());
  //     debugPrint('User successfully logged in: ${userCredential.user?.email}');
  //     debugPrint(userCredential.user.toString());
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     final alert =
  //         PlatformAlert(title: "Login Failed", message: e.message.toString());
  //     if (mounted) {
  //       alert.show(context);
  //     }
  //     debugPrint('Error creating user: ${e.message}');
  //     return false;
  //   }
  // }

  Future<bool> signInUserEmailAndPassword() async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      debugPrint('User successfully logged in: ${userCredential.user?.email}');
      debugPrint(userCredential.user.toString());
      return true;
    } on FirebaseAuthException catch (e) {
      final alert =
          PlatformAlert(title: "Login Failed", message: e.message.toString());
      if (mounted) {
        alert.show(context);
      }
      debugPrint('Error creating user: ${e.message}');
      return false;
    }
  }

  // void _validate() async {
  //   final form = _formKey.currentState;
  //   if (form!.validate() == false) {
  //     return;
  //   } else {
  //     bool value = await signInUserEmailAndPassword();
  //     if (value == false) {
  //       return;
  //     }
  //     if (!mounted) return;
  //     debugPrint('Successfully logged in');
  //     Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const FarmerFormScreen()));
  //   }
  // }

  void _validate() async {
    final form = _formKey.currentState;
    if (form!.validate() == false) {
      return;
    }
    setState(() {
      _loginFuture = signInUserEmailAndPassword();
    });
  }

  Future<bool>? _loginFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      debugPrint("cleared email and password");
      _passwordController.clear();
      _emailController.clear();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // _emailController.clear();
    // _passwordController.clear();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            onTap: (_) {
              // _tabController.addListener(() {
              debugPrint("cleared email and password");
              _passwordController.clear();
              _emailController.clear();
              // });
            },
            // controller: _tabController,
            dividerHeight: 0,
            indicatorColor: theme.primaryColor,
            labelColor: theme.primaryColor,
            labelStyle: Constants.onAppBarSelectedStlye,
            unselectedLabelStyle: Constants.onAppBarUnSelectedStyle,
            tabs: const [
              Tab(
                text: ('Log In'),
              ),
              Tab(text: 'Sign Up'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: TabBarView(
              children: [
                _loginFuture == null
                    ? _LoginScreen()
                    : FutureBuilder<bool>(
                        future: _loginFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            // Using addPostFrameCallback to navigate after build
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (snapshot.data == true && mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FarmerFormScreen(),
                                  ),
                                );
                              }
                            });
                          } else if (snapshot.hasError) {
                            final alert = PlatformAlert(
                                title: "Login Failed",
                                message: snapshot.error.toString());
                            if (mounted) {
                              alert.show(context);
                            }
                            // Show the login form again so the user can retry
                            return _LoginScreen();
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return _LoginScreen();
                        },
                      ),

                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     CustomTextField(
                //         controller: _emailController,
                //         keyboardType: TextInputType.emailAddress,
                //         validator: (text) {
                //           if (text!.isEmpty) {
                //             return 'Email cannot be empty';
                //           } else {
                //             final regex = RegExp('[^@]+@[^.]+..+');
                //             if (!regex.hasMatch(text)) {
                //               return 'Enter a valid Email';
                //             }
                //             return null;
                //           }
                //         },
                //         formTitleText: 'Your Email',
                //         hintText: 'Enter your email'),
                //     const SizedBox(height: 20),
                //     Text('Password', style: ConstantFonts.inter),
                //     TextFormField(
                //       controller: _passwordController,
                //       keyboardType: TextInputType.text,
                //       obscureText: showPassword == false ? true : false,
                //       decoration: InputDecoration(
                //         suffixIcon: InkWell(
                //             onTap: () {
                //               showPassword = !showPassword;
                //               setState(() {});
                //             },
                //             child: showPassword == false
                //                 ? const Icon(
                //                     Icons.visibility_off,
                //                     color: Colors.black12,
                //                   )
                //                 : const Icon(
                //                     Icons.visibility,
                //                     color: Colors.black12,
                //                   )),
                //         errorBorder: Constants.globalOnErrorBorderStyle,
                //         focusedBorder: Constants.globalOnSelectedBorderStyle,
                //         focusedErrorBorder: Constants.globalOnErrorBorderStyle,
                //         hintText: 'Enter your password',
                //         enabledBorder: const OutlineInputBorder(
                //             borderSide:
                //                 BorderSide(width: 1, color: Colors.black12),
                //             borderRadius: Constants.globalBorderRadius),
                //         contentPadding: const EdgeInsets.symmetric(
                //             vertical: 20, horizontal: 20),

                //         // label: Text('Your Email'),
                //       ),
                //       validator: (text) {
                //         if (text!.isEmpty) {
                //           return 'Password cannot be empty';
                //         }
                //         return null;
                //       },
                //     ),
                //     const SizedBox(height: 50),
                //     Center(
                //       child: PressableButton(
                //           text: 'Continue', onPressed: _validate),
                //     ),
                //     const SizedBox(height: 5),
                //     Row(
                //       children: [
                //         Text('Not registered ?',
                //             style: ConstantFonts.inter.copyWith(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: Colors.black54)),
                //         // const SizedBox(width: 10),
                //         Builder(
                //           builder: (tabContext) => TextButton(
                //             onPressed: () {
                //               debugPrint(
                //                   'Sign Up pressed: Navigated to Sign Up screen');
                //               _emailController.clear();
                //               _passwordController.clear();
                //               DefaultTabController.of(tabContext).animateTo(1);
                //             },
                //             child: Text('Sign Up',
                //                 style: ConstantFonts.inter.copyWith(
                //                     fontSize: 14,
                //                     color: Colors.blue,
                //                     fontWeight: FontWeight.w600)),
                //           ),
                //         )
                //       ],
                //     )
                //   ],
                // ),

                const SignUpScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _LoginScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
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
        const SizedBox(height: 20),
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
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black12),
                borderRadius: Constants.globalBorderRadius),
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
        const SizedBox(height: 50),
        Center(
          child: PressableButton(text: 'Continue', onPressed: _validate),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text('Not registered ?',
                style: ConstantFonts.inter.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54)),
            // const SizedBox(width: 10),
            Builder(
              builder: (tabContext) => TextButton(
                onPressed: () {
                  debugPrint('Sign Up pressed: Navigated to Sign Up screen');
                  _emailController.clear();
                  _passwordController.clear();
                  DefaultTabController.of(tabContext).animateTo(1);
                },
                child: Text('Sign Up',
                    style: ConstantFonts.inter.copyWith(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        )
      ],
    );
  }
}
