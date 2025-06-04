/*
 * Copyright (c) 2021 Shady Boshra.
 * IN: https://LinkedIn.com/in/ShadyBoshra2012
 * GitHub: https://github.com/ShadyBoshra2012
 * Mostaql: https://mostaql.com/u/ShadyBoshra2012
 */

import 'package:anawketaby/providers_models/screens/splash_screens/splash_screen_provider.dart';
import 'package:anawketaby/utils/responsive_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashScreenProvider(),
      child: Consumer<SplashScreenProvider>(builder: (_, provider, __) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
          ),
          child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Image.asset(
                        "assets/images/logo_named.jpg",
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (provider.isInit && provider.isMaintenance!)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(height: scaleHeight(80.0)),
                          Text(
                            "مقفل للصيانه",
                            style: TextStyle(
                              fontSize: 32,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "${provider.maintenanceMessage}",
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          )
                        ],
                      ),
                    if (provider.isInit && provider.needsUpdate)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(height: scaleHeight(80.0)),
                          Text(
                            "البرنامج يحتاج تحديث",
                            style: TextStyle(
                              fontSize: 32,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          SizedBox(height: scaleHeight(20.0)),
                          ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                "تحديث البرنامج",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                            onPressed: provider.updateAppPressed,
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
