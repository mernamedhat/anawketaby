import 'package:anawketaby/enums/request_status.dart';
import 'package:anawketaby/enums/request_type.dart';
import 'package:anawketaby/models/request.dart';
import 'package:anawketaby/ui/widgets/filled_button.dart';
import 'package:anawketaby/ui/widgets/rounded_container.dart';
import 'package:anawketaby/utils/app_styles.dart';
import 'package:anawketaby/utils/navigation.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestVerticalTile extends StatelessWidget {
  final Request request;

  const RequestVerticalTile({
    Key? key,
    required this.request,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: RoundedContainer(
        height: scaleHeight(200.0),
        padding: EdgeInsets.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 3),
            blurRadius: 4.0,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AutoSizeText(
                '${this.request.userFullName}',
                maxLines: 2,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 24.0,
                  color: AppStyles.TEXT_SECONDARY_COLOR,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () =>
                    launchUrl(Uri.parse("tel:${this.request.userPhone}")),
                child: AutoSizeText(
                  '${this.request.userPhone}',
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppStyles.TEXT_SECONDARY_COLOR,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AutoSizeText(
                '${request.requestType.translate()}',
                maxLines: 1,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22.0,
                  color: AppStyles.TEXT_SECONDARY_COLOR,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        showLoadingDialog();
                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('adminsCallable-respondRequest');
                        final response = await callable.call({
                          "requestID": request.id,
                          "action": RequestStatus.approved.name,
                        });
                        final isSuccess = response.data as bool;
                        Navigator.pop(Get.context!);
                        if (isSuccess) {
                          showSuccessDialog(
                            title: "نجحت المهمه",
                            desc: "تم الموافقة على الطلب.",
                          );
                        } else {
                          showErrorDialog(
                            title: "فشلت المهمه",
                            desc: "لم يتم الموافقة على الطلب.",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, backgroundColor: AppStyles.THIRD_COLOR, minimumSize: Size(double.infinity, scaleHeight(55.0)), // Text color
                        textStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      child: const Text("موافقة"),
                    ),
                  ),
                  SizedBox(width: scaleWidth(4.0)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        showLoadingDialog();
                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('adminsCallable-respondRequest');
                        final response = await callable.call({
                          "requestID": request.id,
                          "action": RequestStatus.rejected.name,
                        });
                        final isSuccess = response.data as bool;
                        Navigator.pop(Get.context!);
                        if (isSuccess) {
                          showSuccessDialog(
                            title: "نجحت المهمه",
                            desc: "تم رفض الطلب.",
                          );
                        } else {
                          showErrorDialog(
                            title: "فشلت المهمه",
                            desc: "لم يتم رفض الطلب.",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: AppStyles.TEXT_PRIMARY_COLOR, backgroundColor: AppStyles.SECONDARY_COLOR, minimumSize: Size(double.infinity, scaleHeight(55.0)), // Text color
                        textStyle: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      child: const Text("رفض"),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  String getDateTime(DateTime date) {
    Intl.defaultLocale = Get.locale!.languageCode;
    var timeFormatter = DateFormat('yyyy/MM/dd');
    return timeFormatter.format(date);
  }
}
