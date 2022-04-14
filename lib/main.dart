import 'package:admin/Services/AdvisorAccuracyService.dart';
import 'package:admin/Services/analysis_text_servuce.dart';
import 'package:admin/Services/api/quicktrades_notification_token.js.dart';
import 'package:admin/Services/api/quicktrades_tradertoadvisor.dart';
import 'package:admin/Services/auth/signin_with_phonenumber.dart';
import 'package:admin/Services/calls_page_service.dart';
import 'package:admin/Services/fivepaisa/fivepaisa_login_service.dart';
import 'package:admin/Services/full_analysis_image_service.dart';
import 'package:admin/Services/home_screen_services.dart';
import 'package:admin/Services/instrument_search_page_service.dart';
import 'package:admin/Services/new_call_page_services.dart';
import 'package:admin/Services/package_edit_service.dart';
import 'package:admin/Services/package_services.dart';
import 'package:admin/Services/payment_withdraw_services.dart';
import 'package:admin/Services/profile_info_service.dart';
import 'package:admin/Services/profile_page_service.dart';
import 'package:admin/Services/quicktrades_transaction_service.dart';
import 'package:admin/Services/share_button_service.dart';
import 'package:admin/Services/subscribers_page_services.dart';
import 'package:admin/Services/trimarketwatch_ltp_service.dart';
import 'package:admin/Services/trimartketwatch_ui_services.dart';
import 'package:admin/Services/wallet_balance_service.dart';
import 'package:admin/SplashScreen/LoadingPage.dart';
import 'package:admin/pages/UserCheck.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Resources/Color.dart';
import 'Services/IntrumentFetchService.dart';
import 'Services/analysis_title_detail_service.dart';
import 'Services/analysis_upload_service.dart';
import 'Services/auth/code_resend_timer_service.dart';
import 'Services/bottom_navigation_service.dart';
import 'Services/certificate_page_service.dart';
import 'Services/expanse_tracker_services.dart';
import 'Services/landing_page_services.dart';
import 'Services/signin_register_services.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//---------NOTIFICATION SETUP---------------------------------------------------
FirebaseMessaging _fcm = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

NotificationDetails platformChannelSpecifics;

Future<dynamic> onMessageFunction(Map<String, dynamic> message) async {
  print(message.toString());
  // return showNotification(message);
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  print('function called');
  return showNotification(message);
}

showNotification(Map<String, dynamic> message) async {
  await flutterLocalNotificationsPlugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'qt_money_sound');
}

//FCM CONFIGURATION
initNotificationConfiguration() {
  // _fcm.configure(
  //     onLaunch: myBackgroundMessageHandler,
  //     onMessage: onMessageFunction,
  //     onBackgroundMessage: myBackgroundMessageHandler);
}

Future selectNotification(String payload) async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

initNotificationProperties() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('quicktrades');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('0', 'Default QT channel',
          channelDescription: 'Default QT channel for notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('qt_money_sound'),
          enableVibration: true,
          enableLights: true,
          ledOnMs: 1000,
          ledOffMs: 500);

  platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    initNotificationConfiguration();

    initNotificationProperties();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SigninWithPhoneNumber(),
        ),
        ChangeNotifierProvider(
          create: (_) => CertificatePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomNavigationService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExpanseTrackerServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileInfoServices(),
        ),
        ChangeNotifierProvider(create: (_) => NewCallPageServices()),
        ChangeNotifierProvider(
          create: (_) => PackageServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubscribersPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => CallsPageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfilePageService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SigninRegisterServices(),
        ),
        ChangeNotifierProvider(create: (_) => HomeScreenServices()),
        ChangeNotifierProvider(create: (_) => LandingPageServices()),
        ChangeNotifierProvider(create: (_) => InstrumentFetchService()),
        // ChangeNotifierProvider(create: (_) => InstrumentDbClass()),
        ChangeNotifierProvider(create: (_) => InstrumentSearchPageService()),
        ChangeNotifierProvider(create: (_) => AccuracyService()),
        ChangeNotifierProvider(create: (_) => PackageEditService()),
        ChangeNotifierProvider(create: (_) => PaymentWithdrawServices()),
        ChangeNotifierProvider(create: (_) => WalletBalanceService()),
        ChangeNotifierProvider(create: (_) => TriMarketWatchUiServices()),
        ChangeNotifierProvider(create: (_) => TriMarketWatchLtpService()),
        ChangeNotifierProvider(create: (_) => FivePaisaLoginService()),
        ChangeNotifierProvider(create: (_) => ShareButtonService()),
        ChangeNotifierProvider(create: (_) => AnalysisUploadService()),
        ChangeNotifierProvider(create: (_) => AnalysisTextService()),
        ChangeNotifierProvider(create: (_) => FullAnalysisImageService()),
        ChangeNotifierProvider(create: (_) => AnalysisTitleDetailService()),
        ChangeNotifierProvider(create: (_) => CodeResendTimerService()),
        ChangeNotifierProvider(create: (_) => QuicktradesTransactionService()),
        ChangeNotifierProvider(create: (_) => QuicktradesNotificationTokenService()),
        ChangeNotifierProvider(create: (_) => QuicktradesTraderToAdvisor()),
      ],
      child: MaterialApp(
          title: 'QuickTrades Adviser',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: ColorsTheme.primaryColor,
            accentColor: ColorsTheme.secondryColor,
            primaryColorDark: ColorsTheme.primaryDark,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoadingPage()),
    );
  }
}
