import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PDFViewScreen extends StatefulWidget {
  final String pdfUrl;

  PDFViewScreen({required this.pdfUrl});

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  String? localFilePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadPDF();
  }

  Future<void> downloadPDF() async {
    try {
      var dir = await getTemporaryDirectory();
      String filePath = '${dir.path}/temp.pdf';

      await Dio().download(widget.pdfUrl, filePath);
      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      print("Error downloading PDF: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PDF Viewer")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : localFilePath == null
          ? Center(child: Text("Failed to load PDF"))
          : PDFView(
        filePath: localFilePath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
      ),
    );
  }
}
