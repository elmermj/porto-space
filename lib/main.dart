// ignore_for_file: unused_local_variable, unused_field, constant_identifier_names
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:porto_space/misc/app_pages.dart';
import 'package:porto_space/misc/color_schemes.g.dart';
import 'package:porto_space/misc/constants.dart';
import 'package:porto_space/firebase_options.dart';
import 'package:porto_space/screens/home/home_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:porto_space/services/services.dart';
import 'package:porto_space/store/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/welcome/welcome_screen.dart';

void logRed(String msg) {
  debugPrint('\x1B[31m$msg\x1B[0m');
}

void logGreen(String msg) {
  debugPrint('\x1B[32m$msg\x1B[0m');
}

void logYellow(String msg) {
  debugPrint('\x1B[33m$msg\x1B[0m');
}

void logCyan(String msg) {
  debugPrint('\x1B[36m$msg\x1B[0m');
}

void logPink(String msg){
  debugPrint('\x1B[35m$msg\x1B[0m');
}

final storage = GetStorage();

const String STORAGE_USER_PROFILE_KEY = 'user_profile';
const String STORAGE_USER_TOKEN_KEY = 'user_token';
const String STORAGE_DEVICE_FIRST_OPEN_KEY = 'device_first_open';
const String STORAGE_INDEX_NEWS_CACHE_KEY = 'cache_index_news';
const String STORAGE_LANGUAGE_CODE = 'language_code';

String? deviceToken = '';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Get.putAsync<StorageService>(() => StorageService().init());
  await GetStorage.init();
  var appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Get.put<ConfigStore>(ConfigStore());

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    sound: true,
    badge: true,
    alert: true,
    provisional: false,
  );
  deviceToken = await messaging.getToken();

  logPink("DEVICE TOKEN ::: $deviceToken");
  FirebaseAppCheck.instance.activate();
  // Get.put(HomeController());
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // debugPrint(fcmToken);
  runApp(PortoSpaceApp());
}

class AuthController extends GetxController {
  final Rx<User?> _firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

  User? get user => _firebaseUser.value;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      _firebaseUser.value = firebaseUser;
      storage.write('user', firebaseUser.toString());
      storage.read('user');
    });
  }
}

class PortoSpaceApp extends StatelessWidget {
  PortoSpaceApp({super.key});
  final AuthController _authController = Get.put(AuthController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Porto Space',
      theme: ThemeData(
        highlightColor: lightColorScheme.primaryContainer,
        splashColor: lightColorScheme.primaryContainer,
        useMaterial3: true, 
        colorScheme: lightColorScheme,
        buttonTheme: ButtonThemeData(
          minWidth: 96,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
          ),
          highlightColor: lightColorScheme.primaryContainer,
          splashColor: lightColorScheme.primaryContainer,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          TextTheme(
            labelLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Constants.mainTextColor
            )
          )
        ),
      ),
      getPages: AppPages.routes,
      home: FutureBuilder(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}

