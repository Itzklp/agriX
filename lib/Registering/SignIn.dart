import 'package:agrix/Registering/Redirect.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> animation,
      delayedAnimation,
      muchDelayedAnimation,
      muchMuchDelayedAnimation;

  final formKey = GlobalKey<FormState>();

  // Use FocusNode to manage focus
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));

    animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOut));
    delayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)));
    muchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)));
    muchMuchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)));

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, child) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 100.0), // Space from top
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Transform(
                    transform: Matrix4.translationValues(
                        animation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(
                        delayedAnimation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Whether you\'re here to grow your farm or find fresh produce, sign in to continue. Manage your contracts, track your harvest, or discover the best local produce with ease.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(
                        delayedAnimation.value * width, 0.0, 0.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextFormField(
                              'Email',
                              'Enter your email',
                              Icons.email_rounded,
                              TextInputType.emailAddress,
                              emailController,
                              emailFocusNode,
                              passwordFocusNode),
                          const SizedBox(height: 20.0),
                          _buildTextFormField(
                              'Password',
                              'Enter your password',
                              Icons.lock_rounded,
                              TextInputType.text,
                              passwordController,
                              passwordFocusNode,
                              null,
                              obscureText: true),
                          const SizedBox(height: 10.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                              onTap: () async {
                                const url = 'https://your-reset-link.com';
                                if (await canLaunchUrlString(url)) {
                                  await launchUrlString(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Validate form
                                // Proceed with sign-in logic
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sign in successful')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              Colors.green, // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                  vertical: 20.0), // Button padding
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 15),
                                ),
                                TextSpan(
                                  text: 'Register Now',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Redirect(),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextFormField(
      String labelText,
      String hintText,
      IconData icon,
      TextInputType keyboardType,
      TextEditingController controller,
      FocusNode currentFocus,
      FocusNode? nextFocus,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      focusNode: currentFocus,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: Colors.green,
        ),
        errorStyle: const TextStyle(fontSize: 14.0, color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.green),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        if (labelText == 'Email') {
          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
          if (!emailRegex.hasMatch(value)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
      onFieldSubmitted: (_) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    passwordController.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }
}
