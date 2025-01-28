import 'package:business_assistant/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_assistant/cubits/Authentification/auth_cubit.dart';
import '../../style/colors.dart';
import '../../widget/back_arrow.dart';

class CheckEmail extends StatefulWidget {
  late List<TextEditingController> controllers;

  CheckEmail({super.key}) {
    controllers = List.generate(5, (index) => TextEditingController());
  }

  @override
  State<CheckEmail> createState() => _CheckEmailState();
}

class _CheckEmailState extends State<CheckEmail> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)!.settings.arguments as String?;
    if (email == null) {
      // Handle the case where email is null
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('No email provided.'),
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: BackArrow(title: ""),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Check your email',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 19),
                Text.rich(
                  TextSpan(
                    text: 'We sent a reset code to ',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: email,
                        style: const TextStyle(
                          color: Color.fromARGB(195, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' enter the 5-digit code that is mentioned in the email',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.01),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: SizedBox(
                              width: screenWidth * 0.16,
                              child: TextFormField(
                                controller: widget.controllers[i],
                                validator: (value) {
                                  if (widget.controllers[i].text.isEmpty) {
                                    return "Please fill";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 24),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: widget.controllers[i].text.isEmpty
                                          ? Colors.grey
                                          : AppColors.darkGreen,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.darkGreen,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: widget.controllers[i].text.isEmpty
                                          ? Colors.grey
                                          : AppColors.darkGreen,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 33),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   // Combine the code from the text fields
                      //   String code = widget.controllers.map((controller) => controller.text).join();
                      //   context.read<AuthCubit>().verifyResetCode(
                      //     email,
                      //     code,
                      //   ).then((isVerified) {
                      //     if (isVerified) {
                      //       Navigator.pushReplacementNamed(context, '/ResetPassword', arguments: email);
                      //     } else {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(content: Text('Invalid code. Please try again.')),
                      //       );
                      //     }
                      //   });
                      // }
                    },
                    style: button,
                    child: const Text(
                      "Verify Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Haven't got the email yet?",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          // // Resend password logic
                          // String code = widget.controllers.map((controller) => controller.text).join();
                          // context.read<AuthCubit>().verifyResetCode(
                          //       email,
                          //       code,
                          //     );
                        },
                        child: const Text(
                          'Resend Code',
                          style: TextStyle(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
      ),
    );
  }
}
