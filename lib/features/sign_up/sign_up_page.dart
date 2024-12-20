// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:finance_app/common/constants/routes.dart';
import 'package:finance_app/common/utils/uppercase_text_formatter.dart';
import 'package:finance_app/common/utils/validator.dart';
import 'package:finance_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:finance_app/common/widgets/password_form_field.dart';
import 'package:finance_app/features/sign_up/sign_up_controller.dart';
import 'package:finance_app/features/sign_up/sign_up_state.dart';
import 'package:finance_app/locator.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/multi_text_button.dart';
import '../../common/widgets/primary_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with CustomModalSheetMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signUpController = locator.get<SignUpController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _signUpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _signUpController.addListener(
      () {
        if (_signUpController.state is SignUpStateLoading) {
          showDialog(
            context: context,
            builder: (context) => const CustomCircularProgressIndicator(),
          );
        }
        if (_signUpController.state is SignUpStateSuccess) {
          Navigator.pop(context);

          Navigator.pushReplacementNamed(
            context,
            NamedRoute.home,
          );
        }

        if (_signUpController.state is SignUpStateError) {
          final error = _signUpController.state as SignUpStateError;
          Navigator.pop(context);
          showCustomModalBottomSheet(
            context: context,
            content: error.message,
            buttonText: "Дахин оролдно уу",
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Ухаалаг Зарцуулж',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Text(
            'Илүү Хэмнэе',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          // Image.asset(
          //   'assets/images/sign_up_image.png',
          // ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  labelText: "Таны нэр",
                  hintText: "Бүтэн нэрээ оруулна уу?",
                  inputFormatters: [
                    UpperCaseTextInputFormatter(),
                  ],
                  validator: Validator.validateName,
                ),
                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Таны имэйл",
                  hintText: "Имэйлээ оруулна уу?",
                  validator: Validator.validateEmail,
                ),
                PasswordFormField(
                  controller: _passwordController,
                  labelText: "Нууц үг",
                  hintText: "Нууц үгээ оруулаарай",
                  validator: Validator.validatePassword,
                  helperText:
                      "8 үсэгтэй байх.",
                ),
                PasswordFormField(
                  labelText: "Нууц үг давтах",
                  hintText: "Нууц үгээ давтан оруулаарай",
                  validator: (value) => Validator.validateConfirmPassword(
                    _passwordController.text,
                    value,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 32.0,
              right: 32.0,
              top: 16.0,
              bottom: 4.0,
            ),
            child: PrimaryButton(
              text: 'Бүртгүүлэх',
              onPressed: () {
                final valid = _formKey.currentState != null &&
                    _formKey.currentState!.validate();
                if (valid) {
                  _signUpController.signUp(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                } else {
                  log("err");
                }
              },
            ),
          ),
          MultiTextButton(
            onPressed: () => Navigator.popAndPushNamed(
              context,
              NamedRoute.signIn,
            ),
            children: [
              Text(
                'Хэрэглэгчийн эрхтэй юу? ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                'Нэвтрэх ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.greenOne,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}