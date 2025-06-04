/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

enum RequestStatus {
  pending,
  approved,
  rejected,
}

RequestStatus requestStatusFromString(String value) {
  return RequestStatus.values.firstWhere(
          (status) =>
      status.toString().replaceAll("RequestStatus.", "") ==
          value,
      orElse: () => RequestStatus.values.first);
}
