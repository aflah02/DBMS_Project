// http://127.0.0.1:5000/displayCategories

import 'package:amazon_clone/categorypage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'categorycard.dart';

class Category {
  late String categoryName;
  late String tagLine;
  late String url;

  Category({
    required this.categoryName,
    required this.tagLine,
    required this.url,
  });
}

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Future<List<Category>> getProducts() async {
    var data =
        await http.get(Uri.parse('http://127.0.0.1:5000/displayCategories'));

    var jsonData = json.decode(data.body);
    List<Category> productList = [];
    for (var prod in jsonData) {
      var links = await http
          .get(Uri.parse('http://127.0.0.1:5000/getProductImage/' + prod[0]));
      var link = json.decode(links.body);
      Category temp =
          Category(categoryName: prod[0], tagLine: prod[1], url: link);
      productList.add(temp);
    }
    print(productList);
    print("in get");
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Category List")),
      body: FutureBuilder(
        future: getProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: Column(children: [
                  Text("Loading ..."),
                  ElevatedButton(
                      onPressed: () {
                        print('here');
                        print(snapshot.data);
                      },
                      child: Text("Loading ..."))
                ]),
              ),
            );
          } else {
            return (ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.grey[300],
                    ),
                    margin: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Image.network(
                          snapshot.data[index].url,
                          height: 150,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(
                            '${snapshot.data[index].categoryName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text('${snapshot.data[index].tagLine}'),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            print("Tapped");
                            Navigator.push(context, PageRouteBuilder(
                                pageBuilder: (BuildContext context, _, __) {
                              return CategoryPage(
                                  category: snapshot.data[index].categoryName);
                            }));
                          },
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ));
              },
            ));
            // return Container(
            //   child: Center(
            //     child: FloatingActionButton(
            //       onPressed: () {
            //         print(snapshot);
            //       },
            //       child: Text("Print data"),
            //     ),
            //   ),
            // );
          }
        },
      ),
    );
  }
}
