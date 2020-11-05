import 'package:flutter/material.dart';
import 'package:ibge_location/src/server/CityServer.dart';
import 'package:ibge_location/src/widgets/CustomTextField.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CityServer _cityServer = new CityServer();

  TextEditingController _ufSearchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    print("APP START");
  }

  Future _searchCitys(String uf) async {
    if (uf.length < 1) return null;

    try {
      var res = _cityServer.findAll(uf);

      return res;
    } catch (e) {
      print(e);

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Citys"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextField(
              controller: _ufSearchController,
              hint: "Enter a UF to search for cities",
              prefix: Icon(Icons.search),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton.icon(
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(Icons.search, size: 18),
                  label: Text("SEARCH"),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _searchCitys(_ufSearchController.text),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return Center(child: Text('Loading....'));
                  default:
                    if (snapshot.hasError)
                        return Center(child: Text('Error: ${snapshot.error}'));
                    else
                    return snapshot.data != null
                      ? ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('${snapshot.data[index]['nome']} (${snapshot.data[index]['microrregiao']['mesorregiao']['UF']['regiao']['nome']} - ${snapshot.data[index]['microrregiao']['mesorregiao']['UF']['regiao']['sigla']})'),
                            subtitle: Text('${snapshot.data[index]['microrregiao']['mesorregiao']['UF']['nome']} - ${snapshot.data[index]['microrregiao']['mesorregiao']['UF']['sigla']}'),
                            trailing: Icon(Icons.map),
                          );
                        },
                      )
                      : Center(child: const Text('No items'));
                }
              }
            )
          )
        ],
      ),
    );
  }
}