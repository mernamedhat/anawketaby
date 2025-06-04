import 'dart:math';

import 'package:anawketaby/extensions/list_extensions.dart';
import 'package:anawketaby/managements/competitions_management.dart';
import 'package:anawketaby/managements/groups_management.dart';
import 'package:anawketaby/models/app_group.dart';
import 'package:anawketaby/models/app_user.dart';
import 'package:anawketaby/models/competition.dart';
import 'package:anawketaby/providers_models/main/user_provider.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/new_group_screen/new_group_screen.dart';
import 'package:anawketaby/ui/screens/my_groups_screens/group_info_screen/group_info_screen.dart';
import 'package:anawketaby/ui/widgets/empty_list_loader.dart';
import 'package:anawketaby/ui/widgets/empty_list_text.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupInfoScreenProvider extends ChangeNotifier {
  final AppUser? appUser =
      Provider.of<UserProvider>(Get.context!, listen: false).appUser;
  final AppGroup group;

  GroupInfoScreenProvider(this.group);

  Future editGroup() async {
    AppGroup? updatedGroup = await navigateTo(NewGroupScreen(group: group));
    if (updatedGroup != null) {
      await navigateReplacement(GroupInfoScreen(group: updatedGroup));
    }
  }

  Future generateNewShareId() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'إعادة تعيين رابط جديد',
      desc:
          'سوف يتم تعطيل الرابط القديم لهذه المجموعة، هل أنت متأكد من تعيين رابط جديد؟',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        group.shareID = generateUniqueKey();
        bool isSuccess =
            await GroupsManagement.instance.editGroup(group, appUser);

        if (isSuccess) {
          notifyListeners();
        }
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  Future leaveGroup() async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد المغادرة',
      desc:
          'هل تريد بالتأكيد مغادرة هذه المجموعة؟ لا يمكن الرجوع في هذه الخطوة.',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        await GroupsManagement.instance
            .leaveGroup(group, group.membersProfiles[appUser!.id!]);
        Navigator.pop(Get.context!);
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  Future copyCompetitionToGroup(Competition competition) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "اختيار المجموعة",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppStyles.PRIMARY_COLOR,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 22.0,
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(Get.context!).size.height * 0.8,
            width: MediaQuery.of(Get.context!).size.width * 0.8,
            child: StreamBuilder<dynamic>(
              stream: GroupsManagement.instance.getMyControlGroups(appUser!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: EmptyListLoader());
                } else {
                  List docs = [];

                  if (snapshot.data is List) {
                    for (final list in snapshot.data) {
                      docs.addAll(list.docs);
                    }
                    docs = docs.distinctBy(((e) => e.data()[AppGroup.ID_KEY]))
                        as List<dynamic>;
                    docs.sort((a, b) => b
                        .data()[AppGroup.TIME_CREATED_KEY]
                        .compareTo(a.data()[AppGroup.TIME_CREATED_KEY]));
                  } else {
                    docs.addAll(snapshot.data!.docs);
                  }

                  if (docs.length < 2)
                    return Center(
                        child: EmptyListText(
                            text: "لا توجد مجموعات اخرى خاصة بك"));
                  else {
                    return ListView.separated(
                        itemCount: docs.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: scaleHeight(12.0)),
                        padding:
                            EdgeInsets.symmetric(vertical: scaleHeight(16.0)),
                        itemBuilder: (_, index) {
                          AppGroup group = AppGroup.fromDocument(docs[index]);
                          if (competition.groupsIDs!.contains(group.id)) {
                            return SizedBox();
                          }
                          return ElevatedButton(
                            onPressed: () async {
                              showLoadingDialog();

                              competition.groupsIDs?.add(group.id!);

                              bool successfulCompetition =
                              await CompetitionManagement.instance
                                  .editCompetition(competition, this.appUser);

                              group.createdCompetitions.add(competition.id!);

                              bool successfulGroup = await GroupsManagement
                                  .instance
                                  .editGroup(group, this.appUser);

                              Navigator.pop(Get.context!);
                              Navigator.pop(Get.context!);

                              if (successfulCompetition && successfulGroup) {
                                showSuccessDialog(
                                  title: "تم نسخ المسابقة",
                                  desc:
                                  "تم نسخ المسابقة لمجموعة ${group.name} بنجاح.",
                                  onDismissCallback: (_) =>
                                      Navigator.pop(Get.context!, group),
                                );
                              } else {
                                showErrorDialog(
                                  title: "حدث خطأ",
                                  desc: "حدث خطأ في اتمام عملية النسخ",
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.PRIMARY_COLOR_DARK, // Background color
                              minimumSize: Size(double.infinity, scaleHeight(36.0)), // Width and height
                            ),
                            child: Text(
                              group.name,
                              style: const TextStyle(
                                color: AppStyles.TEXT_PRIMARY_COLOR,
                                fontSize: 16.0,
                              ),
                            ),
                          );

                        });
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future removeCompetitionFromGroup(Competition competition) async {
    AwesomeDialog(
      context: Get.context!,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.question,
      title: 'تأكيد الحذف',
      desc: 'هل تريد بالتأكيد حذف هذه المسابقة من هذه المجموعة؟',
      btnOkText: 'نعم',
      btnOkOnPress: () async {
        showLoadingDialog();

        competition.groupsIDs?.remove(group.id!);

        bool successfulCompetition = await CompetitionManagement.instance
            .editCompetition(competition, this.appUser);

        group.createdCompetitions.remove(competition.id!);

        bool successfulGroup =
            await GroupsManagement.instance.editGroup(group, this.appUser);

        Navigator.pop(Get.context!);

        if (successfulCompetition && successfulGroup) {
          showSuccessDialog(
            title: "تم حذف المسابقة",
            desc: "تم حذف المسابقة من هذه المجموعة بنجاح.",
            onDismissCallback: (_) => Navigator.pop(Get.context!, group),
          );
        } else {
          showErrorDialog(
            title: "حدث خطأ",
            desc: "حدث خطأ في اتمام عملية الحذف",
          );
        }
      },
      btnCancelText: 'لا',
      btnCancelOnPress: () {},
    )..show();
  }

  Future adminActivateGroup() async {
    showLoadingDialog();

    group.isActivated = true;

    bool successful =
        await GroupsManagement.instance.editGroup(this.group, this.appUser);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم تفعيل المجموعة",
        desc: "تم تفعيل المجموعة بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!, group),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية التعديل",
      );
    }
  }

  Future adminDeactivateGroup() async {
    showLoadingDialog();

    group.isActivated = false;

    bool successful =
        await GroupsManagement.instance.editGroup(this.group, this.appUser);

    Navigator.pop(Get.context!);

    if (successful) {
      showSuccessDialog(
        title: "تم تعطيل المجموعة",
        desc: "تم تعطيل المجموعة بنجاح.",
        onDismissCallback: (_) => Navigator.pop(Get.context!, group),
      );
    } else {
      showErrorDialog(
        title: "حدث خطأ",
        desc: "حدث خطأ في اتمام عملية التعديل",
      );
    }
  }

  Future removeMember(Map memberMap) async {}

  String generateUniqueKey() {
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final Random random = Random();
    String key = '';

    for (int i = 0; i < 8; i++) {
      final int randomIndex = random.nextInt(chars.length);
      key += chars[randomIndex];
    }

    return key;
  }
}
