import 'package:flutter/material.dart';
import 'package:sanity_test/data_res.dart';
import 'package:sanity_test/sanity.dart';
import 'package:sanity_test/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SanityClient sanityClient = SanityClient(
    projectId: projectId,
    dataset: dataSet,
    useCdn: useCdn,
  );
  List<DataResponse> dataList = [];
  void _incrementCounter() async {
    const String query = '*[_type == "login"] ';
    List<dynamic> result = await sanityClient.fetch(query: query);
    List<DataResponse> dataListTemp = List<DataResponse>.from(result.map((e) => DataResponse.fromJson(e)));
    dataListTemp.forEach((element) {
      var refId = element.image?.assett?.sRef;
      var parts = refId!.split('-');
      var id = parts[1];
      var format = parts[3];
      var size = parts[2];
      element.image?.url = "https://cdn.sanity.io/images/$projectId/$dataSet/$id-$size.$format";
    });

    setState(() {
      dataList = dataListTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(dataList.length, (index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(height: 100, width: 100, child: Image.network(dataList[index].image?.url ?? "")),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dataList[index].userName ?? ""),
                          Text(dataList[index].phoneNo.toString()),
                          Text(dataList[index].emailId ?? "")
                        ],
                      )
                    ],
                  ),
                ),
              );
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
