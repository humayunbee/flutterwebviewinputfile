library flutter_bkash;

import 'dart:developer' as dev;


import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class WebViewPage extends StatefulWidget {
  /// default the sandbox is true

  final String url;
  final String title;


  const WebViewPage({
    Key? key,
    required this.url, required this.title,
  }) : super(key: key);

  @override
  BkashPaymentState createState() => BkashPaymentState();
}

class BkashPaymentState extends State<WebViewPage> {
  InAppWebViewController? webViewController;

  bool isLoading = true;


  @override
  void initState() {
    super.initState();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
            centerTitle: true,
         title: Text('${widget.title}',style: TextStyle(color: Colors.black),),backgroundColor: Colors.white,


         iconTheme: IconThemeData(
           color:Theme.of(context).primaryColor, //change your color here
         ),
       ),
      /*appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.pink,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context, true),
          ),
          title: const Text('bKash Checkout')),*/
      body: Stack(
        children: [
          InAppWebView(
            // access the html file on local
            initialUrlRequest: URLRequest(
                url: Uri.parse(widget.url)
            ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptCanOpenWindowsAutomatically: true,
                useShouldInterceptFetchRequest: true,
              ),
              android: AndroidInAppWebViewOptions(
                useShouldInterceptRequest: true,
                useHybridComposition: true,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
              //sending data from dart to js the data of payment
             /* controller.addJavaScriptHandler(
                  handlerName: 'handlerFoo',
                  callback: (args) {
                    // return data to the JavaScript side!
                    return paymentData;
                  });*/

              controller.clearCache();
            },

            onLoadStop: ((controller, url) {
              // print('url $url');

              /// for payment success
              controller.addJavaScriptHandler(
                  handlerName: 'paymentSuccess',
                  callback: (success) {
                    // print("bkashSuccess $success");
                    //_paymentHandler('paymentSuccess', success[0]);
                  });

              /// for payment failed
              controller.addJavaScriptHandler(
                  handlerName: 'paymentFailed',
                  callback: (failed) {
                     print("bkashFailed $failed");
                    //_paymentHandler('paymentFailed', failed);
                  });

              /// for payment error
              controller.addJavaScriptHandler(
                  handlerName: 'paymentError',
                  callback: (error) {
                     print("paymentError => $error");
                   // _paymentHandler('paymentError', error[0]);
                  });

              /// for payment failed
              controller.addJavaScriptHandler(
                  handlerName: 'paymentClose',
                  callback: (close) {
                     print("paymentClose => $close");
                   // _paymentHandler('paymentClose', close[0]);
                  });

              /// set state is loading or not loading depend on page data
              setState(() => isLoading = false);
            }),

            onConsoleMessage: (controller, consoleMessage) {
              /// for view the console log as message on flutter side
              dev.log(consoleMessage.toString());
            },
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
    );
  }
}
