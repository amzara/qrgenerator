import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//function3=specific extension numbers as opposed to a range.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: function3(),
    );
  }
}

class function3 extends StatefulWidget {
  @override
  _Function3State createState() => _Function3State();
}

class _Function3State extends State<function3> {
  TextEditingController extController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  List<int> selectedExtensions = [];
  List<String> qrCodes = [];
  String apiResponse = '';

  Future<void> fetchData(int extension, String domain) async {
    String url =
        'https://10.16.1.213/backend/crp2.php?ext=$extension&domain=$domain';
    var response = await http.get(Uri.parse(url));
    setState(() {
      apiResponse = response.body;
      String? extractedImgUrl = newCustomFunction(apiResponse);
      if (extractedImgUrl != null) {
        qrCodes.add(extractedImgUrl);
      }
    });
  }

  String? newCustomFunction(String? html) {
    /// MODIFY CODE ONLY BELOW THIS LINE

    // Find the index of 'src' attribute
    int? srcIndex = html!.indexOf('src=');

    // If 'src' attribute is found
    if (srcIndex != null && srcIndex != -1) {
      // Move the index to the start of the URL
      int urlStartIndex = srcIndex + 5; // 5 is the length of 'src='

      // Find the closing quote of the URL
      int? urlEndIndex = html?.indexOf("'", urlStartIndex);
      if (urlEndIndex == null || urlEndIndex == -1) {
        urlEndIndex = html?.indexOf('"', urlStartIndex);
      }

      // Extract the URL if urlEndIndex is not null
      if (urlEndIndex != null && urlEndIndex != -1) {
        String imageUrl = html.substring(urlStartIndex, urlEndIndex);
        // Append the base URL
        return "https://10.16.1.213/backend/$imageUrl";
      }
    }

    // If 'src' attribute is not found or URL extraction fails, return null
    return null;

    /// MODIFY CODE ONLY ABOVE THIS LINE
  }

  void addExtension() {
    int extension = int.tryParse(extController.text) ?? 0;
    if (extension != 0) {
      setState(() {
        selectedExtensions.add(extension);
      });
      extController.clear();
    }
  }

  void generateQRCodes() async {
    String domain = domainController.text;
    for (int extension in selectedExtensions) {
      await fetchData(extension, domain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: extController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Extension'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: domainController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Domain'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addExtension,
                child: Text('Add Extension'),
              ),
              SizedBox(height: 20),
              if (selectedExtensions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Extensions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: selectedExtensions.map((extension) {
                        return Chip(
                          label: Text('$extension'),
                          onDeleted: () {
                            setState(() {
                              selectedExtensions.remove(extension);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: generateQRCodes,
                child: Text('Generate QR Codes'),
              ),
              SizedBox(height: 20),
              if (qrCodes.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QR Codes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: qrCodes.map((qrCode) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.network(
                            qrCode,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
