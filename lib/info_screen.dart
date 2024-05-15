import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[100],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'urstory@gmail.com',
              );
              try {
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  _showErrorDialog(context, '메일 앱을 열 수 없습니다.');
                }
              } catch (e) {
                _showErrorDialog(context, '메일 앱을 여는 도중 오류가 발생했습니다.');
              }
            },
            child: Text(
              '만든사람 : 토토 (urstory@gmail.com)',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            '제작일 : 2024년 5월 15일',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse('https://github.com/urstory');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                _showErrorDialog(context, '브라우저를 열 수 없습니다.');
              }
            },
            child: Text(
              'Github URL : https://github.com/urstory',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }
}
