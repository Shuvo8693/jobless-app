import 'package:url_launcher/url_launcher.dart';

class URLLauncherService {
  // Launch any URL
  static Future<void> launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      // Handle error silently or log if needed
    }
  }

  // Launch URL in external browser
  static Future<void> launchURLExternal(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or log if needed
    }
  }

  // Launch phone dialer
  static Future<void> makePhoneCall(String phoneNumber) async {
    await launchURL('tel:$phoneNumber');
  }

  // Launch SMS
  static Future<void> sendSMS(String phoneNumber, [String? message]) async {
    String url = 'sms:$phoneNumber';
    if (message != null) {
      url += '?body=${Uri.encodeComponent(message)}';
    }
    await launchURL(url);
  }

  // Launch email
  static Future<void> sendEmail(String email, {String? subject, String? body}) async {
    String url = 'mailto:$email';
    List<String> params = [];

    if (subject != null) {
      params.add('subject=${Uri.encodeComponent(subject)}');
    }
    if (body != null) {
      params.add('body=${Uri.encodeComponent(body)}');
    }

    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }

    await launchURL(url);
  }

  // Launch WhatsApp
  static Future<void> openWhatsApp(String phoneNumber, [String? message]) async {
    String url = 'https://wa.me/$phoneNumber';
    if (message != null) {
      url += '?text=${Uri.encodeComponent(message)}';
    }
    await launchURL(url);
  }

  // Launch Maps
  static Future<void> openMaps(double latitude, double longitude) async {
    await launchURL('https://maps.google.com/?q=$latitude,$longitude');
  }

  // Launch Maps with address
  static Future<void> openMapsWithAddress(String address) async {
    await launchURL('https://maps.google.com/?q=${Uri.encodeComponent(address)}');
  }
}