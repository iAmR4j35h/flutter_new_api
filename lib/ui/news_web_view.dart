import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsWebView extends StatefulWidget {
  String url;
  String title;
  NewsWebView({@required this.url,this.title});
  @override
  NewsWebViewState createState() => NewsWebViewState();
}

class NewsWebViewState extends State<NewsWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Flexible(child: Text("${widget.title}", style: TextStyle(color: Colors.white, fontSize: 24,))),
          ],
        ),
      ),
      body: SafeArea(
        child: WebView(
          initialUrl: widget.url,
        ),
      ),
    );
  }
}