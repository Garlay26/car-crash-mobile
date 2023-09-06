import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppLanguage { mm, en }

class NumberNormalization {
  static final Map<String, dynamic> _numbersMap = {
    '0': {
      AppLanguage.en: '0',
      AppLanguage.mm: '၀',
    },
    '1': {
      AppLanguage.en: '1',
      AppLanguage.mm: '၁',
    },
    '2': {
      AppLanguage.en: '2',
      AppLanguage.mm: '၂',
    },
    '3': {
      AppLanguage.en: '3',
      AppLanguage.mm: '၃',
    },
    '4': {
      AppLanguage.en: '4',
      AppLanguage.mm: '၄',
    },
    '5': {
      AppLanguage.en: '5',
      AppLanguage.mm: '၅',
    },
    '6': {
      AppLanguage.en: '6',
      AppLanguage.mm: '၆',
    },
    '7': {
      AppLanguage.en: '7',
      AppLanguage.mm: '၇',
    },
    '8': {
      AppLanguage.en: '8',
      AppLanguage.mm: '၈',
    },
    '9': {
      AppLanguage.en: '9',
      AppLanguage.mm: '၉',
    },
  };

  static final Map<String, dynamic> _monthMap = {
    '01': {
      AppLanguage.en: '1',
      AppLanguage.mm: 'ဇန်နဝါရီ',
    },
    '02': {
      AppLanguage.en: '2',
      AppLanguage.mm: '​ဖေ​ဖော်ဝါရီ',
    },
    '03': {
      AppLanguage.en: '3',
      AppLanguage.mm: 'မတ်',
    },
    '04': {
      AppLanguage.en: '4',
      AppLanguage.mm: 'ဧပြီ',
    },
    '05': {
      AppLanguage.en: '5',
      AppLanguage.mm: '​မေ',
    },
    '06': {
      AppLanguage.en: '6',
      AppLanguage.mm: 'ဇွန်',
    },
    '07': {
      AppLanguage.en: '7',
      AppLanguage.mm: 'ဇူလိုင်',
    },
    '08': {
      AppLanguage.en: '8',
      AppLanguage.mm: '​သြဂုတ်',
    },
    '09': {
      AppLanguage.en: '9',
      AppLanguage.mm: 'စက်တင်ဘာ',
    },
    '10': {
      AppLanguage.en: '10',
      AppLanguage.mm: '​အောက်တိုဘာ',
    },
    '11': {
      AppLanguage.en: '11',
      AppLanguage.mm: 'နိုဝင်ဘာ',
    },
    '12': {
      AppLanguage.en: '12',
      AppLanguage.mm: 'ဒီဇင်ဘာ',
    },
  };

  static String numberNormalizer({required String rawString}) {
    String result = '';
    int counter = 0;
    try {
      for (int i = (rawString.characters.toList().length - 1); i >= 0; i--) {
        counter++;
        String _raw = rawString.characters.toList()[i];
        String str = _numbersMap[_raw][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first];
        if ((counter % 3) != 0 && i != 0) {
          result = "$str$result";
        } else if (i == 0) {
          result = "$str$result";
        } else {
          result = ",$str$result";
        }
      }
      return result;
    } catch (e) {
      result = rawString;
    }

    return result;
  }

  static String numberNormalizerEnglish({required String rawString}) {
    String result = '';
    int counter = 0;
    try {
      for (int i = (rawString.characters.toList().length - 1); i >= 0; i--) {
        counter++;
        String _raw = rawString.characters.toList()[i];
        String str = _raw;
        // [AppLanguage.values
        //     .where((element) => element.name == Get.locale!.languageCode)
        //     .first];
        if ((counter % 3) != 0 && i != 0) {
          result = "$str$result";
        } else if (i == 0) {
          result = "$str$result";
        } else {
          result = ",$str$result";
        }
      }
      return result;
    } catch (e) {
      result = rawString;
    }

    return result;
  }

  String convertEngToMm(String data) {
    String _year = _numbersMap[data[0]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first] +
        _numbersMap[data[1]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first] +
        _numbersMap[data[2]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first] +
        _numbersMap[data[3]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first];

    String _month = _monthMap[data[5] + data[6]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first];

    String _date = _numbersMap[data[8]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first] +
        _numbersMap[data[9]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first];

    print(_year + _month + _date);
    return "$_date ရက် $_month $_year";
  }

  String convertEngToMmTwo(String data) {
    String _year = _numbersMap[data[0]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first] +
        _numbersMap[data[1]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first] +
        _numbersMap[data[2]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first] +
        _numbersMap[data[3]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first];

    String _month = _monthMap[data[5] + data[6]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first];

    String _date = _numbersMap[data[8]][AppLanguage.values
        .where((element) => element.name == Get.locale!.languageCode)
        .first] +
        _numbersMap[data[9]][AppLanguage.values
            .where((element) => element.name == Get.locale!.languageCode)
            .first];

    print(_year + _month + _date);
    return "$_date ရက် $_monthလ $_year";
  }

  String calculateOverDueDays(String isoDueDate) {
    if (isoDueDate == "") {
      return "";
    } else {
      DateTime now = DateTime.now(); // <== get current time
      DateTime dueDate =
      DateTime.parse(isoDueDate); // <=== format due date to DateTime
      DateTime formattedDueDate = DateTime(dueDate.year, dueDate.month,
          dueDate.day); // <=== format due date to calculation format
      DateTime currentDate = DateTime(now.year, now.month, now.day);
      Duration difference = currentDate.difference(formattedDueDate);
      int differenceInDays = difference.inDays;
      String daysInString = numberNormalizer(rawString: differenceInDays.toString()); // <=== convert Eng to MM
      return daysInString;
    }
  }
}
