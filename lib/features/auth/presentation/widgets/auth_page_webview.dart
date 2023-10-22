import 'package:flutter/material.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthPageWebView extends StatefulWidget {
  const AuthPageWebView({Key? key, required this.url, required this.getAccessToken}) : super(key: key);
  final String url;
  final void Function(String code) getAccessToken;
  @override
  State<AuthPageWebView> createState() => _AuthPageWebViewState();
}

class _AuthPageWebViewState extends State<AuthPageWebView> {
  late WebViewController controller;
  int currentProgress = 100;
  String code = "";
  bool init = true;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if(init == false){
              setState(() {
                currentProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            printDebug("WebView=> onPageStarted $url");
          },
          onPageFinished: (String url) {
            printDebug("WebView=> onPageFinished $url");
          },
          onWebResourceError: (WebResourceError error) {
            printDebug("WebView=> onWebResourceError ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            printDebug("WebView=> onNavigationRequest ${request.url}");
            if(request.url.contains("?code=")){
              setState(() {
                code = request.url.split("?code=").elementAtOrNull(1)??"";
              });
              printDebug("WebView=> onNavigationRequest code $code");
              Navigator.maybePop(context);
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    init = false;
    super.initState();
  }

  @override
  void dispose() {
    printDebug("WebView=> dispose $code");
    if(code.isNotEmpty){
      widget.getAccessToken(code);
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ///TODO C loading bar
          Text("progress $currentProgress"),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
