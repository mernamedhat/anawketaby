/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum RequestType {
  groupCreation,
}

RequestType requestTypeFromString(String value) {
  return RequestType.values.firstWhere(
          (status) =>
      status.toString().replaceAll("RequestType.", "") ==
          value,
      orElse: () => RequestType.values.first);
}

extension RequestTypeExtension on RequestType {
  String translate() {
    switch(this) {
      case RequestType.groupCreation:
        return "طلب إنشاء مجموعات";
    }
  }
}
