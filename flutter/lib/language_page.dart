import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('selectLanguage'.tr)),
      body: Column(
        children: [
          languageButton('English', 'en'),
          languageButton('हिन्दी', 'hi'),
          languageButton('اردو', 'ur'),
          languageButton('বাংলা', 'bn'),
          languageButton('தமிழ்', 'ta'),
        ],
      ),
    );
  }

  Widget languageButton(String label, String localeCode) {
    return ElevatedButton(
      onPressed: () {
        Get.updateLocale(Locale(localeCode));
      },
      child: Text(label),
    );
  }
}
