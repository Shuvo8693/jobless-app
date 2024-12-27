/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPdfPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _downloadAndShowPdf();
  }

  // Function to download the PDF and save it locally
  Future<void> _downloadAndShowPdf() async {
    try {
      // Get a temporary directory to store the PDF
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String filePath = '$tempPath/${widget.pdfUrl.split('/').last}';

      // Download the PDF using `http`
      var response = await http.get(Uri.parse(widget.pdfUrl));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Save the file locally
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Update the local path to the downloaded file
        setState(() {
          localPdfPath = filePath;
          isLoading = false;
        });
      } else {
        print('Failed to download PDF: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loader while PDF is downloading
          : localPdfPath != null
          ? PdfView(
        filePath: localPdfPath!, // Display the PDF using flutter_cached_pdfview
      )
          : const Center(child: Text('Failed to load PDF')),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;

  const PdfViewerScreen({required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: const PDF().cachedFromUrl(
        pdfUrl,
        placeholder: (progress) => Center(child: Text('$progress %')),
        errorWidget: (error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
