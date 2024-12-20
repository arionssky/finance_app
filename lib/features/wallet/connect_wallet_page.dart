import 'package:flutter/material.dart';
import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/extensions/sizes.dart';

class ConnectWalletPage extends StatelessWidget {
  const ConnectWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Түрийвч цэнэглэх',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tab Bar for Cards/Accounts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                TabButton(text: 'Картууд', isActive: true),
                TabButton(text: 'Аккаунт', isActive: false),
              ],
            ),
            const SizedBox(height: 16.0),
            const InputField(
                label: 'КАРТ ДЭЭРХ НЭР', placeholder: 'Davaasuren Nyamjav'),
            const SizedBox(height: 8.0),
            Row(
              children: const [
                Expanded(
                    child: InputField(
                        label: 'КАРТЫН ДУГААР',
                        placeholder: '6219 8610 2888 8075')),
                SizedBox(width: 8.0),
                Expanded(child: InputField(label: 'CVC', placeholder: '***')),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: const [
                Expanded(
                    child: InputField(
                        label: 'ДУУССАН ХУГАЦАА', placeholder: 'MM/YY')),
                SizedBox(width: 8.0),
                Expanded(child: InputField(label: 'ZIP', placeholder: '0000')),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                // Add your card submission logic here
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'КАРТ НЭМЭХ',
                  style: AppTextStyles.mediumText36.apply(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isActive;

  const TabButton({
    Key? key,
    required this.text,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tab switching logic
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isActive ? AppColors.iceWhite : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          text,
          style: AppTextStyles.mediumText36.apply(
            color: isActive ? AppColors.green : AppColors.darkGrey,
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String label;
  final String placeholder;

  const InputField({
    Key? key,
    required this.label,
    required this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.smallText13.apply(color: AppColors.grey)),
        const SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: AppColors.iceWhite,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
