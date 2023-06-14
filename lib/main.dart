// ignore_for_file: unused_local_variable, unused_field, constant_identifier_names
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

const String STORAGE_USER_PROFILE_KEY = 'user_profile';
const String STORAGE_USER_TOKEN_KEY = 'user_token';
const String STORAGE_DEVICE_FIRST_OPEN_KEY = 'device_first_open';
const String STORAGE_INDEX_NEWS_CACHE_KEY = 'cache_index_news';
const String STORAGE_LANGUAGE_CODE = 'language_code';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());

  // final fcmToken = await FirebaseMessaging.instance.getToken();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

