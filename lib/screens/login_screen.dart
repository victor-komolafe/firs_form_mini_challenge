import 'package:firs_mini_project/constants.dart';
import 'package:firs_mini_project/screens/farmer_form_screen.dart';
import 'package:firs_mini_project/screens/sign_up_screen.dart';
import 'package:firs_mini_project/widgets/pressable_button.dart';
import 'package:firs_mini_project/widgets/text_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _passwordController = TextEditingController();
final _emailController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool showPassword = false;

class _LoginScreenState extends State<LoginScreen> {
  void _validate() {
    final form = _formKey.currentState;
    if (form!.validate() == false) {
      return;
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FarmerFormScreen()));
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
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
                Column(
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
                    // Text('Your Email',
                    //     style: GoogleFonts.inter(
                    //         fontWeight: FontWeight.w400, fontSize: 16)),
                    // TextFormField(
                    //   controller: _nameController,
                    //   decoration: const InputDecoration(
                    //       focusedBorder: Constants.globalOnSelectedBorderStyle,
                    //       errorBorder: Constants.globalOnErrorBorderStyle,
                    //       focusedErrorBorder:
                    //           Constants.globalOnErrorBorderStyle,
                    //       hintText: 'Enter your mail',
                    //       // focusedErrorBorder: ,
                    //       enabledBorder: Constants.globalFormBorderStyle),
                    //   validator: (text) {
                    //     return (text!.isEmpty) ? 'Email cannot be empty' : null;
                    //   },
                    // ),
                    // const SizedBox(height: 20),
                    // // gaa

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
                            borderSide:
                                BorderSide(width: 1, color: Colors.black12),
                            borderRadius: Constants.globalBorderRadius),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),

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
                      child: PressableButton(
                          text: 'Continue', onPressed: _validate),
                    )
                  ],
                ),
                const SignUpScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// return SafeArea(
//   child: Scaffold(
//     appBar: AppBar(
//       toolbarHeight: 150,
//       flexibleSpace: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 30),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             TextButton(
//                 onPressed: () {
//                   setState(() {
//                     isSelected = true;
//                   });
//                 },
//                 child: Text('Log In',
//                     style: isSelected == true
//                         ? Constants.onAppBarSelectedStlye
//                         : Constants.onAppBarUnSelectedStyle)),
//             TextButton(
//                 onPressed: () {
//                   setState(() {
//                     isSelected = true;
//                   });
//                 },
//                 child: Text('Log In',
//                     style: isSelected == true
//                         ? Constants.onAppBarSelectedStlye
//                         : Constants.onAppBarUnSelectedStyle)),
//           ],
//         ),
//       ),
//     ),
//     body: const Padding(
//       padding: EdgeInsets.all(26.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [],
//         // textForm(),
//       ),
//     ),
//   ),
// );
