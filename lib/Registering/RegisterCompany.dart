import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RegisterCompany extends StatefulWidget {
  const RegisterCompany({super.key});

  @override
  State<RegisterCompany> createState() => _RegisterCompanyState();
}

class _RegisterCompanyState extends State<RegisterCompany> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation, delayedAnimation, muchDelayedAnimation, muchMuchDelayedAnimation;
  final _formKey = GlobalKey<FormState>();

  String? _incorporationFileName;
  String? _insuranceFileName;
  String? _aadhaarFileName;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn));
    delayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.2, 1.0, curve: Curves.fastOutSlowIn)));
    muchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));
    muchMuchDelayedAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(CurvedAnimation(parent: animationController, curve: const Interval(0.8, 1.0, curve: Curves.fastOutSlowIn)));

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
            if (fileType == 'incorporation') {
              _incorporationFileName = result.files.single.name;
            } else if (fileType == 'insurance') {
              _insuranceFileName = result.files.single.name;
            } else if (fileType == 'aadhaar') {
              _aadhaarFileName = result.files.single.name;
            }
          });
        } else {
          print('User canceled the picker');
        }
      } catch (e) {
        print('Error picking file: $e');
      }
    } else {
      print('Permission not granted');
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform(
                      transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
                      child: const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Transform(
                      transform: Matrix4.translationValues(delayedAnimation.value * width, 0.0, 0.0),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTextFormField('Company Name', 'Enter company name', Icons.business, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Business Type', 'Enter business type', Icons.category, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Registration Number', 'Enter registration number', Icons.numbers, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Tax ID', 'Enter tax identification number', Icons.description, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Year of Establishment', 'Enter year of establishment', Icons.calendar_today, TextInputType.number),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Company Address', 'Enter company address', Icons.location_city, TextInputType.streetAddress),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Email', 'Enter company email', Icons.email, TextInputType.emailAddress),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Phone Number', 'Enter company phone number', Icons.phone, TextInputType.phone),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Website', 'Enter company website', Icons.web, TextInputType.url),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Authorized Representative Name', 'Enter representative name', Icons.person, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Position', 'Enter representative position', Icons.work, TextInputType.text),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Representative Email', 'Enter representative email', Icons.email, TextInputType.emailAddress),
                              const SizedBox(height: 20.0,),
                              _buildTextFormField('Representative Phone Number', 'Enter representative phone number', Icons.phone, TextInputType.phone),
                              const SizedBox(height: 20.0,),

                              // File pickers
                              _buildFilePicker('Company Incorporation Certificate', _incorporationFileName, () => _pickFile('incorporation')),
                              const SizedBox(height: 20.0,),
                              _buildFilePicker('Company Insurance Certificate', _insuranceFileName, () => _pickFile('insurance')),
                              const SizedBox(height: 20.0,),
                              _buildFilePicker('Representative Aadhaar Card', _aadhaarFileName, () => _pickFile('aadhaar')),

                              const SizedBox(height: 20.0,),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle form submission
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
                              const SizedBox(height: 20,),
                              RichText(
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  TextFormField _buildTextFormField(String labelText, String hintText, IconData icon, TextInputType keyboardType) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(
          icon,
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Pick File', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Text(
                fileName ?? 'No file selected',
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
