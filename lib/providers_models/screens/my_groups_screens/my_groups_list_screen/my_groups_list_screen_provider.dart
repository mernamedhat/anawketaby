import 'package:anawketaby/enums/request_status.dart';
import 'package:anawketaby/enums/request_type.dart';
import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/managements/requests_management.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/new_group_screen/new_group_screen.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyGroupsListScreenProvider extends ChangeNotifier {
  AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;

  Future<void> createNewGroup() async {
    if (appUser?.userFeatures?.appFeature?.groupCreationLimit == null) {
      showErrorDialog(
        title: "غير مصرح",
        desc: "يجب إرسال طلب بإنشاء مجموعات إلى إدارة التطبيق اولاً.",
        btnOk: ElevatedButton(
          onPressed: () async {
            Navigator.pop(Get.context!);
            showLoadingDialog();

            final snapshot = await RequestsManagement.instance
                .getMyCreationRequestsWithOptions(
              appUser!,
              requestType: RequestType.groupCreation,
              requestStatus: RequestStatus.pending,
            );
            if (snapshot.docs.isNotEmpty) {
              Navigator.pop(Get.context!);
              showErrorDialog(
                title: "طلب مكرر",
                desc: "لقد تم ارسال طلب من قبل، لا يمكنك الارسال مرة اخرى.",
              );
              return;
            }

            HttpsCallable callable = FirebaseFunctions.instance
                .httpsCallable('usersCallable-requestGroupCreation');
            final response = await callable.call();
            final isSuccess = response.data as bool;
            Navigator.pop(Get.context!);
            if (isSuccess) {
              showSuccessDialog(
                title: "نجحت المهمه",
                desc: "تم إرسال طلبك بنجاح، سوف يتم الرد عليه قريباً.",
              );
            } else {
              showErrorDialog(
                title: "فشلت المهمه",
                desc:
                "تم فشل إرسال الطلب، يُمكن حدوث ذلك إذا كنت طلبت مسبقاً، او حدث عطل ما.",
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.THIRD_COLOR_DARK, // Background color
            minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
          ),
          child: Text(
            "إرسال طلب",
            style: const TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 16.0,
            ),
          ),
        ),

          btnCancel: ElevatedButton(
          onPressed: () => Navigator.pop(Get.context!),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyles.SECONDARY_COLOR_DARK, // Background color
            minimumSize: Size(double.infinity, scaleHeight(55.0)), // Width and height
          ),
          child: Text(
            "إلغاء",
            style: const TextStyle(
              color: AppStyles.TEXT_PRIMARY_COLOR,
              fontSize: 22.0,
            ),
          ),
        ),

      );
      return;
    }

    int userGroupsCount =
        (await GroupsManagement.instance.getMyCreationAppGroupsFuture(appUser!))
            .docs
            .length;

    if (userGroupsCount >=
        appUser!.userFeatures!.appFeature!.groupCreationLimit) {
      showErrorDialog(
        title: "غير مصرح",
        desc:
            "لقد أكملت الحد الأقصى من عدد المجموعات المسموحة لك. لزيادة الحد الأقصى برجاء التواصل مع إدارة التطبيق.",
      );
      return;
    }

    navigateTo(NewGroupScreen());
  }
}
