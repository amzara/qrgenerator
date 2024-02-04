import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: function2(),
    );
  }
}

class function2 extends StatefulWidget {
  @override
  _Function2State createState() => _Function2State();
}

class _Function2State extends State<function2> {
  TextEditingController extController1 = TextEditingController();
  TextEditingController extController2 = TextEditingController();
  TextEditingController domainController = TextEditingController();
  List<String> qrCodes = [];
  String apiResponse = '';
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Reached the end of the list, load more data
      fetchData();
    }
  }

  Future<void> fetchData() async {
    int ext1 = int.parse(extController1.text);
    int ext2 = int.parse(extController2.text);
    String domain = domainController.text;

    for (int i = ext1; i <= ext2; i++) {
      String url = 'https://10.16.1.213/backend/crp2.php?ext=$i&domain=$domain';
      var response = await http.get(Uri.parse(url));
      setState(() {
        apiResponse = response.body;
        String? extractedImgUrl = newCustomFunction(apiResponse);
        if (extractedImgUrl != null) {
          qrCodes.add(extractedImgUrl);
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: extController1,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Start Extension'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: extController2,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'End Extension'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: domainController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Domain'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchData,
                child: Text('Generate QR Codes'),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: qrCodes.length,
                itemBuilder: (context, index) {
                  int extNumber = int.parse(extController1.text) + index;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'QR Code for Extension $extNumber:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          qrCodes[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
