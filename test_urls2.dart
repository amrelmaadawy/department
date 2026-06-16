import 'dart:io';

void main() async {
  final urls = [
    "https://moqlate.coderaeg.com/storage/projects/1781450435_WhatsApp_Image_2026-06-10_at_7.26.20_PM.jpeg",
    "https://moqlate.coderaeg.com/storage/projects/1781450441_WhatsApp_Image_2026-06-10_at_10.16.48_PM.jpeg",
    "https://moqlate.coderaeg.com/storage/projects/1781450441_WhatsApp_Image_2026-06-10_at_10.32.33_PM.jpeg",
    "https://moqlate.coderaeg.com/storage/projects/1781410518_WhatsApp_Image_2026-06-13_at_9.06.08_PM.jpeg"
  ];

  final client = HttpClient();
  
  for (final url in urls) {
    try {
      final encoded = Uri.encodeFull(url);
      final uri = Uri.parse(encoded);
      final request = await client.headUrl(uri);
      final response = await request.close();
      print("$url -> ${response.statusCode}");
    } catch (e) {
      print("$url -> Error: $e");
    }
  }
  
  client.close();
}
