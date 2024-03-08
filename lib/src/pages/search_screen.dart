import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> items = [
    'Texto 1',
    'Texto 2',
    'Texto 3',
    'Texto 4',
    'Texto 5'
  ];
  String dropdownValue = 'Texto 1';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    Widget buildBottomAppBar() {
      return BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.qr_code),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.5,
              maxHeight: screenSize.height * 0.05,
            ),
            child: Image.asset(
              'assets/images/logo_text.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                height: screenSize.height * 0.7,
                child: Image.asset('assets/images/mock_map.png'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomAppBar(),
    );
  }
}
