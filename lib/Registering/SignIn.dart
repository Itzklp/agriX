import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin{
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  late AnimationController animationController;
  late Animation<double> animation, delayedAnimation, muchDelayedAnimation, muchMuchDelayedAnimation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5));

    animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));
    delayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));
    muchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
  }
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey();
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
                  child: const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20.0),
                Transform(
                  transform: Matrix4.translationValues(delayedAnimation.value * width, 0.0, 0.0),
                  child: const Text(
                    'Whether you\'re here to grow your farm or find fresh produce, sign in to continue. Manage your contracts, track your harvest, or discover the best local produce with ease.',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Transform(
                  transform: Matrix4.translationValues(delayedAnimation.value *width, 0.0, 0.0),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                              labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_rounded,
                                color: Colors.black87,
                              ),
                              errorStyle: const TextStyle(fontSize: 18.0),
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
                            validator: (value){
                              if (value == null || value.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter your email')),
                                );
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            autofocus: true,
                          ),
                          const SizedBox(height: 20.0,),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                              labelText: 'Password',
                              prefixIcon: const Icon(
                                Icons.password_rounded,
                                color: Colors.black87,
                              ),
                              errorStyle: const TextStyle(fontSize: 18.0),
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
                          ),
                          const SizedBox(height: 20.0,),
                          Container(
                            margin: const EdgeInsets.only(left: 250),
                            child: InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              onTap: () => launchUrlString(''),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Transform(
                  transform: Matrix4.translationValues(muchMuchDelayedAnimation.value * width, 0.0, 0.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // Button padding
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.black87,fontSize: 15),
                            ),
                            TextSpan(
                              text: 'Register Now',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.bold
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrlString('https://www.example.com'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }
}
