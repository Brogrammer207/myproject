import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/googleapis_auth.dart';

String fireBaseMessagingScope = "https://www.googleapis.com/auth/firebase.messaging";


Future<String> getAccessToken() async {
  final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(
          {
            "type": "service_account",
            "project_id": "borawar-oil-meal",
            "private_key_id": "4cc3e8ab54e9ec25f0ea0aea400980d9b6beaaea",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC0O+QZovAey6O2\nraDcE+l4L7rU96iyo1pXzAo3JQZNfUYtLgNgaekDlzcw4wjZd2wAPqqmG1CqXPhw\nlmxBe6YHoOCroICZCCs4MsGgtVTtdIBok3LlzBrI2Nn66SyGcrRPHZs2lIkUevQM\n4Sknm+o3reGbYuW+Msy9h0IR7/tMD/T7zH0+PBcyN2infIN5dMd0NJpWv9qLr/pG\nBt/v4PgiZ6zpvFI4Zp5/hbwAtGho5tr8FCjcnmpjwuYjF6rp9jsxzuMb8ZW2WdHU\nMv/xPJVOlsMTI8Q6DUq0kC1AaUUi9UeW2tTl9FKHVa3/MpmKAhGQasV8nCrpOeau\nZ4Z0sxnPAgMBAAECggEAV/VIjwhZNjY8mejncbAYBwsIG2oX/sJA00slCx97EXMb\nPe5QQIu/Z3yzNxz9kx+4afArWPBIsDO6HTwT7es5rkxhiPDGAakeaok+vL7yCQaL\nqj2XW7V9tto5mz2TeLPe8iNpPbxEn+WXV/fEnWt2ZSDrUulzZJynFbG+WUGsesQX\nHGc3sMzQjJ5JNbMMS2ab4xJRxjY0D7+uo8ZcGXz+QdyGYXUZxet0Npxs3yxQSYZd\nhNmsu6fE/G66iTLdp4tOdqwUDSj60VIPsb/vePE6fxFIqCn+LeXj/lEDD8q7lYXM\n6S1iJJyLeIph+bAx2+JMz54KJCe30obNlMx0x5MJjQKBgQDb1BcH8e29pEQzhXBc\ndL6hW7+aF0UoqxPlv3wVXxELb+TDzK5i2+48u39pQrBDgl2rKAcen+zk+kuLfAfY\n1phPj5wuKh+JkWxQ/jJo2HhEyVbM7hU8d9qudtrzKvaRaTFNWqFDtM1lIdOImNJI\n/AA+YjmruOsHf6xtSW/FErRnkwKBgQDR4/J/NgbKRe0cGq13t2eIsmouPUtZJeQ2\n2gJamuuxZVltYcAAP/AN9kT93Z52ysOsMdmJaXn8xJVftCpT08hLlEhWD9DSryj1\nMoyKZSolxKHdvp1fiu/H3aqWHOCl0gft1kguHOqHDAwkIG5JFhN14IJJ1vN06pgb\nWFhRCmYyVQKBgQDSFLs53YuNS7nd3u1FflBb1lmighCWz//A9aE4r1STsIhYUnhp\ng7MGmU0nJBNdQO4RTryXGNEE9upRT+QT5ulCR4VDXQAssSxprrQwHIe7fQqV6AWl\ndwkm5/FQqENhLb1vJmitUtFjj9MfXKTCGQqGk8p3gM4jqXD4NFE7bie4PwKBgQCz\nMXmHQgjqCGk25U/UNbEe87PTZmE96yu76MS5tiojefOvfxT9IZlBUk/0rZDsuo/0\nI1smBfcv5mXhH2BD0Tvfyuk3EKmoNgMx08ZJIbWqKQZI2sRhHa05ZfaN0nm5GGfM\nlnVpaSaRxadX8Jg3rbFPoi2Z/Po9h0v1jKdaCRbXQQKBgFX2E6VvNCniAWZUgIoo\nDg9sl9tmIKovAyDuV1Sw5ZUwnmnXDwA3cOmjiDmrScnAQn0MGJDD6uvvfKyk+RZV\nmiIJdEuKgkNCU/H6lhJSkkUAE0LQhlsoY9fT/b4niSquDEZCQ5J4lI+WZS9TIbmG\nJdyWGgAdbNZhepOXnJy3H0hK\n-----END PRIVATE KEY-----\n",
            "client_email": "firebase-adminsdk-cqb91@borawar-oil-meal.iam.gserviceaccount.com",
            "client_id": "107326310249235763489",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-cqb91%40borawar-oil-meal.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }
      ),
      [fireBaseMessagingScope]);
  final accessToken = client.credentials.accessToken.data;
  return accessToken;
}

Future<void> sendPushNotification({
  required String deviceToken,
  required String title,
  required String body,
  required String image,
  required String orderID,
}) async {
  final String projectId = 'borawar-oil-meal'; // Replace with your project ID
  final String accessToken = await getAccessToken();

  final Map<String, dynamic> notification = {
    'body': body,
    'title': title,
    'image': image,
  };

  final Map<String, dynamic> message = {
    'message': {
      'token': deviceToken,
      'notification': notification,
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'order_id': orderID,
      },
    },
  };

  try {
    final http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      print(response.body);
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  }
}
