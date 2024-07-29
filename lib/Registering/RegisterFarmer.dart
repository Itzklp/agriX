import 'package:agrix/Registering/SignIn.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'Redirect.dart';

class RegisterFarmer extends StatefulWidget {
  const RegisterFarmer({super.key});

  @override
  State<RegisterFarmer> createState() => _RegisterFarmerState();
}

class _RegisterFarmerState extends State<RegisterFarmer> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation, delayedAnimation, muchDelayedAnimation, muchMuchDelayedAnimation;
  final _formKey = GlobalKey<FormState>();

  String? _aadhaarFileName;
  String? _panFileName;
  String? _landformFileName;
  String? _soilDnaFileName;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    delayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: const Interval(0.2, 1.0, curve: Curves.easeInOut)),
    );
    muchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: const Interval(0.5, 1.0, curve: Curves.easeInOut)),
    );
    muchMuchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: const Interval(0.8, 1.0, curve: Curves.easeInOut)),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String fileType) async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null && result.files.isNotEmpty) {
          setState(() {
            switch (fileType) {
              case 'aadhaar':
                _aadhaarFileName = result.files.single.name;
                break;
              case 'pan':
                _panFileName = result.files.single.name;
                break;
              case 'landform':
                _landformFileName = result.files.single.name;
                break;
              case 'soildna':
                _soilDnaFileName = result.files.single.name;
                break;
              default:
                break;
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User canceled the picker')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50),
                  Transform(
                    transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
                    child: const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Transform(
                    transform: Matrix4.translationValues(delayedAnimation.value * width, 0.0, 0.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildTextFormField('First Name', 'Enter first name', Icons.person, TextInputType.text),
                          const SizedBox(height: 20.0),
                          _buildTextFormField('Last Name', 'Enter last name', Icons.person, TextInputType.text),
                          const SizedBox(height: 20.0),
                          _buildTextFormField('E-mail', 'Enter e-mail', Icons.email, TextInputType.emailAddress),
                          const SizedBox(height: 20.0),
                          _buildTextFormField('Phone', 'Enter phone number', Icons.call, TextInputType.phone),
                          const SizedBox(height: 20.0),
                          _buildTextFormField('Aadhaar No', 'Enter Aadhaar number', Icons.perm_identity, TextInputType.number),
                          const SizedBox(height: 20.0),
                          _buildTextFormField('Soil Type', 'Enter soil type', Icons.location_city, TextInputType.text),
                          const SizedBox(height: 20.0),

                          // File pickers
                          _buildFilePicker('Aadhaar Card', _aadhaarFileName, () => _pickFile('aadhaar')),
                          const SizedBox(height: 20.0),
                          _buildFilePicker('Pan Card', _panFileName, () => _pickFile('pan')),
                          const SizedBox(height: 20.0),
                          _buildFilePicker('Form 7/12/8A', _landformFileName, () => _pickFile('landform')),
                          const SizedBox(height: 20.0),
                          _buildFilePicker('Soil DNA', _soilDnaFileName, () => _pickFile('soildna')),

                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle form submission
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Form submitted successfully')),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
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
                                  text: 'Already have an account? ',
                                  style: TextStyle(color: Colors.black87, fontSize: 15),
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                      ),
                                    ),
                                ),
                              ],
                            ),
                          )
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

  TextFormField _buildTextFormField(String labelText, String hintText, IconData icon, TextInputType keyboardType) {
    return TextFormField(
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
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildFilePicker(String labelText, String? fileName, VoidCallback onPressed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: const Text('Pick File', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                fileName ?? 'No file selected',
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black54),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
