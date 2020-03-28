import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewExample extends StatefulWidget {
  WebViewExample({Key key}) : super(key: key);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {

  @override
  void initState() {
    super.initState();
  }

  void _onPageStarted(String url, BuildContext context) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  _onPageFinished(String url) {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: Colors.blue,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              WebView(
                onPageStarted: (url) => _onPageStarted(url, context),
                onPageFinished: _onPageFinished,
                onWebViewCreated: (controller) => _controller = controller,
                initialUrl: "https://alissonlima.com.br",
                javascriptMode: JavascriptMode.unrestricted,
                gestureRecognizers: Set()
                  ..add(Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()..onUpdate = (_) {},
                  )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _onWillPop(BuildContext context) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    SystemNavigator.pop(animated: true);
    return false;
  }
}
