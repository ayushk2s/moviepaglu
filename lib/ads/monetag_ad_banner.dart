import 'dart:html' as html;
import 'package:flutter/material.dart';

class MonetagAdBanner extends StatelessWidget {
  const MonetagAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const scriptId = 'monetag-script';

    // Inject script only once
    if (html.document.getElementById(scriptId) == null) {
      final script = html.ScriptElement()
        ..id = scriptId
        ..type = 'text/javascript'
        ..setAttribute('data-cfasync', 'false')
        ..innerHtml = """
(() => {
  var _ludgzr;
  (function(d,z,s,c){
    s.src='//shaiwourtijogno.net/400/9504376';
    s.onerror=s.onload=E;
    function E(){c&&c();c=null}
    try{(document.body||document.documentElement).appendChild(s)}
    catch(e){E()}
  })('shaiwourtijogno.net',9504376,document.createElement('script'),_ludgzr);
})();
""";

      html.document.body!.append(script);
    }

    return const SizedBox(
      height: 100,
      child: Center(
        child: Text("", style: TextStyle(color: Color(0xFFAAAAAA))),
      ),
    );
  }
}
