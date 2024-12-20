// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:finance_app/common/constants/routes.dart';
import 'package:finance_app/common/utils/validator.dart';
import 'package:finance_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:finance_app/common/widgets/password_form_field.dart';
import 'package:finance_app/locator.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/widgets/custom_bottom_sheet.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/multi_text_button.dart';
import '../../common/widgets/primary_button.dart';
import 'sign_in_controller.dart';
import 'sign_in_state.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with CustomModalSheetMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInController = locator.get<SignInController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signInController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _signInController.addListener(
      () {
        if (_signInController.state is SignInStateLoading) {
          showDialog(
            context: context,
            builder: (context) => const CustomCircularProgressIndicator(),
          );
        }
        if (_signInController.state is SignInStateSuccess) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            NamedRoute.home,
          );
        }

        if (_signInController.state is SignInStateError) {
          final error = _signInController.state as SignInStateError;
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
            'Тавтай морилно уу',
            textAlign: TextAlign.center,
            style: AppTextStyles.mediumText36.copyWith(
              color: AppColors.greenOne,
            ),
          ),
          Image.asset(
            'assets/images/sign_in_image.png',
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                      "8 үсэгтэй байх. 1 тоо оруулсан байх",
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
              text: 'Нэвтрэх',
              onPressed: () {
                final valid = _formKey.currentState != null &&
                    _formKey.currentState!.validate();
                if (valid) {
                  _signInController.signIn(
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
              NamedRoute.signUp,
            ),
            children: [
              Text(
                'Бүртгэлгүй юу?  ',
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.grey,
                ),
              ),
              Text(
                'Бүртгүүлэх',
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
