// ignore_for_file: sort_child_properties_last, prefer_collection_literals
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inputtest/web_view_page.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() async {
  // 초기화
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "File Upload",
    debugShowCheckedModeBanner: false,
    home: WebViewPage(title: 'File Upload', url: 'https://www.apptoaster.co.kr/ad',),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey inAppWebViewKey = GlobalKey();
  late final WebViewController webviewController;
  String userAgent = Platform.isAndroid
      ? "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.120 Mobile Safari/537.36 [FB_IAB/FB4A;FBAV/294.0.0.39.118;]"
      : "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1";
  DateTime? currentBackPressTime;
  late String nowScreen = "main";
  String errorMessage = "";
  bool isRefreshError = false;
  late String? token;
  bool isInit = true;
  bool endLoad = false;

  // 상태 초기화
  @override
  void initState() {
    super.initState();

    webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(userAgent)
      ..loadRequest(Uri.parse("https://www.apptoaster.co.kr/ad"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SafeArea(
            child: SizedBox(),
            bottom: false,
          ),
        ),
      ),
      body: WebViewWidget(
        controller: webviewController,
        gestureRecognizers: Set()
          ..add(
            Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer()..onUpdate = (_) {}),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          launchUrlString(
            "https://www.apptoaster.co.kr/ad",
            mode: LaunchMode.externalApplication,
          );
        },
        child: Icon(Icons.open_in_browser),
      ),
    );
  }
}
