import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';

class Browser extends StatefulWidget {
  final String link;
  final String source;
  Browser({@required this.link, @required this.source});
  @override
  _BrowserState createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final _key = UniqueKey();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String _source = '';
    if (widget.link.contains('https://')) {
      _source = widget.source.replaceAll('https://', '');
    }
    if (widget.link.contains('http://')) {
      _source = widget.source.replaceAll('http://', '');
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text(_source ?? '')),
        ),
        bottomNavigationBar: BottomAppBar(
          child: NavigationControls(
            webViewControllerFuture: _controller.future,
            link: widget.link,
          ),
        ),
        body: Column(
          children: [
            WebLoader(
              webViewControllerFuture: _controller.future,
            ),
            Expanded(
              child: Container(
                child: WebView(
                  key: _key,
                  initialUrl: '${widget.link}',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated:
                      (WebViewController webViewController) async {
                    await Future.delayed(Duration(seconds: 1));
                    _controller.complete(webViewController);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(
      {@required this.webViewControllerFuture, @required this.link});

  final Future<WebViewController> webViewControllerFuture;
  final String link;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        Toast.show(
                          "No back history",
                          context,
                          duration: Toast.LENGTH_SHORT,
                          gravity: Toast.BOTTOM,
                        );

                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        Toast.show(
                          "No forward history",
                          context,
                          duration: Toast.LENGTH_SHORT,
                          gravity: Toast.BOTTOM,
                        );

                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: !webViewReady
                  ? null
                  : () {
                      Share.share('$link');
                    },
            ),
            IconButton(
              icon: const Icon(Icons.launch),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await canLaunch('$link')) {
                        await launch('$link');
                      } else {
                        Toast.show(
                          "Cannot Launch Url !!",
                          context,
                          duration: Toast.LENGTH_SHORT,
                          gravity: Toast.BOTTOM,
                        );

                        return;
                      }
                    },
            ),
          ],
        );
      },
    );
  }
}

class WebLoader extends StatelessWidget {
  const WebLoader({@required this.webViewControllerFuture});

  final Future<WebViewController> webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        //final WebViewController controller = snapshot.data;
        return webViewReady
            ? SizedBox()
            : LinearProgressIndicator(
                minHeight: 2.0,
              );
      },
    );
  }
}
