import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AdminMyCreationTopicsScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
}
