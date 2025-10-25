import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadAndEarnPage extends StatelessWidget {
  final String linkyReferral = 'https://publisher.linkyshare.com/ref/Ayushk2s';
  final String shortLinkReferral = 'https://shrinkme.io/ref/101781604099145355747';

  void _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Upload & Earn', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth >= 900 ? 600 : double.infinity;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Earn Money by Uploading Files!',
                      style: TextStyle(color: Colors.amber, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '1. Create your free account using the button below.\n'
                          '2. Upload your videos or files to their dashboard.\n'
                          '3. Share your short download links anywhere.\n'
                          '4. Earn money for each valid download you receive!',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Start Earning Now!',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Tap the button below to register and start uploading content to earn money.',
                            style: TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => _openUrl(linkyReferral),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            icon: const Icon(Icons.create),
                            label: const Text('Upload & Earn'),
                          ),
                          const SizedBox(height: 16),

                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Maximize Your Earnings:',
                      style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Use another platform that pays when people visit your shared links. You can earn more by combining both methods.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _openUrl(shortLinkReferral),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(Icons.link),
                      label: const Text('Get Paid for Sharing Links'),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Key Benefits:',
                      style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '✔ High earnings per download\n'
                          '✔ Fast and simple dashboard\n'
                          '✔ Weekly payouts with low threshold\n'
                          '✔ Global traffic accepted',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      '💸 Earning Proof:',
                      style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://i.ibb.co/TDx7GHsZ/earningproof.jpg',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[800],
                          child: const Text('Failed to load image', style: TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
