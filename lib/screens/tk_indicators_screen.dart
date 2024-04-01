import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:macres/config/app_config.dart';
import 'package:macres/models/tk_model.dart';
import 'package:macres/util/magnifier.dart' as Mag;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

class TkIndicatorsScreen extends StatefulWidget {
  const TkIndicatorsScreen({super.key});

  @override
  State<TkIndicatorsScreen> createState() => _TkIndicatorsScreenState();
}

class _TkIndicatorsScreenState extends State<TkIndicatorsScreen> {
  List<TkIndicatorModel> indicators = [];
  int counter = 0;
  bool visibility = false;

  List<TkIndicatorModel> apiData = [];
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchIndicators();
    super.initState();
  }

  fetchIndicators() async {
    this.indicators = await getIndicators();
  }

  Future<List<TkIndicatorModel>> getIndicators() async {
    String username = AppConfig.userName;
    String password = AppConfig.password;
    String host = AppConfig.baseUrl;
    String endpoint = '/tk/ind?_format=json';
    List<TkIndicatorModel> data = [];

    this.isLoading = true;

    final basicAuth =
        "Basic ${base64.encode(utf8.encode('$username:$password'))}";
    dynamic response;
    try {
      response = await http.get(
        Uri.parse('$host$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': basicAuth
        },
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body).isEmpty) {
          setState(() {
            isLoading = false;
          });

          return [];
        }

        setState(() {
          isLoading = false;
        });
        final loaded_data = json.decode(response.body) as List<dynamic>;
        return loaded_data
            .map((json) => TkIndicatorModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      const snackBar = SnackBar(
        content: Text(
            'Error: Unable to load traditional knowledge Indicators data.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Mag.Magnifier(
      size: Size(250.0, 250.0),
      enabled: visibility ? true : false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(92, 125, 138, 1.0),
          foregroundColor: Colors.white,
          title: const Text('Traditional Indicators'),
          elevation: 0,
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  this.counter = 0;
                  visibility = !visibility;
                });
              },
              child: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: this.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in this.indicators)
                        formatIndicators(item),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget formatIndicators(data) {
    return Container(
      color: Color.fromARGB(255, 237, 235, 235),
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: data.photo,
            placeholder: (context, url) => new CircularProgressIndicator(),
            errorWidget: (context, url, error) => new Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text('${data.weight}. ${data.name}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left),
          ),
          SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 10.0,
            ),
            child: Text(data.desc),
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
