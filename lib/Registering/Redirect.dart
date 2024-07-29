import 'package:agrix/Registering/RegisterCompany.dart';
import 'package:agrix/Registering/RegisterFarmer.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart';

class Redirect extends StatefulWidget {
  const Redirect({Key? key}) : super(key: key);

  @override
  State<Redirect> createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation, delayedAnimation, muchDelayedAnimation, muchMuchDelayedAnimation;
  bool isFarmerSelected = true;
  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    delayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeInOut),
      ),
    );
    muchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
    muchMuchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
      ),
    );

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Transform(
                    transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Welcome to agriX!',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(delayedAnimation.value * width, 0.0, 0.0),
                    child: const Text(
                      'We\'re excited to have you on board. At agriX, we connect farmers and partners for successful, contract-based farming.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(muchDelayedAnimation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Manage your contracts, connect with reliable partners, and access valuable resources—all in one place.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Transform(
                    transform: Matrix4.translationValues(muchMuchDelayedAnimation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Here\'s to your success!',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Transform(
                    transform: Matrix4.translationValues(muchMuchDelayedAnimation.value * width, 0.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFarmerSelected = true;
                              buttonPressed = true;
                            });

                            Future.delayed(const Duration(milliseconds: 300), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterFarmer(),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFarmerSelected && buttonPressed ? Colors.green : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          ),
                          child: const Text(
                            'I am Farmer',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFarmerSelected = false;
                              buttonPressed = true;
                            });

                            Future.delayed(const Duration(milliseconds: 300), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterCompany(),
                                ),
                              );
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isFarmerSelected && buttonPressed ? Colors.green : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          ),
                          child: const Text(
                            'I am Company',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
