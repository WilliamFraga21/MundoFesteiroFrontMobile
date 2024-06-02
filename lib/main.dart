import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
// import 'backend/firebase/firebase_config.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import '../constants/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Helper/helper.dart';
export 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import './datas/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();
  // await initFirebase();

  await FlutterFlowTheme.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  // late Future futureToken;
  @override
  void initState() {
    super.initState();
    // futureToken = fetchToken();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MundoFesteiroMobileApp',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;
  late Future futureToken;
  bool iftoken = false;
  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
    // futureToken = fetchToken();
  }

  // Future fetchToken() async {
  //   final dbHelper = DatabaseHelper();
  //   String? validToken = await DatabaseHelper().getToken();
  //   print(validToken);
  //   print('validToken');
  //   var url = Uri.parse(apiUrl + '/api/profile');

  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': "Bearer $validToken",
  //   };

  //   var response = await http.get(url, headers: headers);

  //   if (response.statusCode == 200) {
  //     iftoken = true;
  //   } else {
  //     print(response.statusCode);
  //     final dbHelper = DatabaseHelper();
  //     await dbHelper.deleteToken();
  //     setState(() {
  //       GoRouter.of(context).go('/LoginPage');
  //     });
  //   }
  // }

  Future<void> handleEventManagementNavigation() async {
    final dbHelper = DatabaseHelper();
    String? validToken = await dbHelper.getToken();
    var url = Uri.parse(apiUrl + '/api/profile');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $validToken",
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Navigate to the event management page
      iftoken = true;
      setState(() {
        _currentPage = SelectEditEventWidget();
        _currentPageName = 'SelectEditEvent';
      });
    } else {
      // Navigate to the login page
      final dbHelper = DatabaseHelper();
      await dbHelper.deleteToken();
      setState(() {
        GoRouter.of(context).go('/LoginPage');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': const HomePageWidget(),
      'ProvideServicesPage': const ProvideServicesPageWidget(),
      'SelectEditEvent': const SelectEditEventWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);
    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) async {
          if (tabs.keys.toList()[i] == 'SelectEditEvent') {
            await handleEventManagementNavigation();
          } else {
            setState(() {
              _currentPage = null;
              _currentPageName = tabs.keys.toList()[i];
            });
          }
        },
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF05BD7B),
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 24.0,
            ),
            label: 'Home',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.badge_outlined,
              size: 24.0,
            ),
            label: 'Prestar Serviços',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.celebration_outlined,
              size: 24.0,
            ),
            label: 'Gerenciar eventos',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
