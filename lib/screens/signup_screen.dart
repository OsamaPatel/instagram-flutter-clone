import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/utils.dart';
import '../utils/colors.dart';
import '../widgets/text_input_field.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _img;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _img = img;
    });
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().signUpUser(
        username: _usernameController.text,
        bio: _bioController.text,
        email: _emailController.text,
        password: _passController.text,
        file: _img!);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      showSnackBar('Account Created Successfully', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 85,
              ),
              Stack(
                children: [
                  _img != null
                      ? CircleAvatar(
                          radius: 9.h,
                          backgroundImage: MemoryImage(_img!),
                        )
                      : CircleAvatar(
                          radius: 9.h,
                          backgroundImage: const NetworkImage(
                              'https://www.kindpng.com/picc/m/52-526237_avatar-profile-hd-png-download.png'),
                        ),
                  Positioned(
                      bottom: -1.2.h,
                      right: -0.5.h,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              TextInputField(
                  textEditingController: _usernameController,
                  hintText: 'Enter Your Username',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 3.h,
              ),
              TextInputField(
                  textEditingController: _bioController,
                  hintText: 'Enter Your Bio',
                  textInputType: TextInputType.text),
              SizedBox(
                height: 3.h,
              ),
              TextInputField(
                  textEditingController: _emailController,
                  hintText: 'Enter Your Email',
                  textInputType: TextInputType.emailAddress),
              SizedBox(
                height: 3.h,
              ),
              TextInputField(
                textEditingController: _passController,
                hintText: 'Enter Your Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: 3.h),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)))),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign up'),
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: const Text('Already have an account?'),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: const Text(
                        'Log in',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
