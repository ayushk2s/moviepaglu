import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InterstitialAdPage extends StatelessWidget {
  final String targetUrl;

  InterstitialAdPage({required this.targetUrl});

  final String htmlTemplate = '''
  <!DOCTYPE html>
  <html>
  <head>
    <title>Ad Loading</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>
      setTimeout(function() {
        window.location.href = "{{REDIRECT_URL}}";
      }, 5000); // Show ad for 5 seconds
    </script>
  </head>
  <body>
    <p style="text-align:center;margin-top:50px;">Ad is loading... please wait.</p>
    <script>
      (function(d,z,s){
        s.src='https://'+d+'/401/'+z;
        try{(document.body||document.documentElement).appendChild(s)}catch(e){}
      })('groleegni.net',9504303,document.createElement('script'));
    </script>
  </body>
  </html>
  ''';

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(
        htmlTemplate.replaceAll('{{REDIRECT_URL}}', targetUrl),
      );

    return Scaffold(
      appBar: AppBar(title: Text("Please Wait...")),
      body: WebViewWidget(controller: controller),
    );
  }
}
