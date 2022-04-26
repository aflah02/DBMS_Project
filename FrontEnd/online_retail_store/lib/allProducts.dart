import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'displaycategories.dart';

class Product {
  late String brand;
  late String price;
  late String name;
  late String url;

  Product(
      {required this.name,
      required this.price,
      required this.brand,
      required this.url});
}

class AllProductPage extends StatefulWidget {
  final int uid;
  const AllProductPage({Key? key, required this.uid}) : super(key: key);

  @override
  _AllProductPageState createState() => _AllProductPageState();
}

class _AllProductPageState extends State<AllProductPage> {
  @override
  void initState() {
    super.initState();
    Userid = widget.uid;
  }

  int quantity = 1;
  late String Username;
  late int Userid;
  Future<int> addToCart(String brand, String product, int quantity) async {
    var data = await http.get(Uri.parse(
        'http://127.0.0.1:5000/getProductID/' + product + '/' + brand));
    var jsonData = json.decode(data.body);
    print(jsonData[0][0]);
    await http.get(Uri.parse('http://127.0.0.1:5000/addProductToCart/' +
        Userid.toString() +
        '/' +
        jsonData[0][0].toString() +
        '/' +
        quantity.toString()));
    return 1;
  }

  Widget generateCards() {
    return Container(
      height: 325,
      child: FutureBuilder(
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
                        getProducts();
                        print(snapshot.data);
                      },
                      child: Text("Loading ..."))
                ]),
              ),
            );
          } else {
            return (ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(50, 0, 0, 20),
                          child: Image.network(
                            snapshot.data[index].url,
                            height: 120,
                            width: 140,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            '${snapshot.data[index].name}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text('${snapshot.data[index].brand}'),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${snapshot.data[index].price}' + '₹',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              // IconButton(
                              //     onPressed: () {},
                              //     icon: Icon(Icons.add_shopping_cart))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(75, 0, 0, 0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                        title: Text('Cart'),
                                        content: Container(
                                          height: 100,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                'Quantity : ${quantity}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        print('increase');
                                                        setState(() {
                                                          quantity += 1;
                                                        });
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        print('decrease');
                                                        setState(() {
                                                          quantity -= 1;
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                if (quantity <= 0) {
                                                  setState(() {
                                                    quantity = 0;
                                                  });
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Database'),
                                                          content: Text(
                                                              'ERROR! Ensure Quantity is a positive number'),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(
                                                                          'dialog');
                                                                },
                                                                child: Text(
                                                                    'Back to App'))
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  setState(() {
                                                    quantity = 0;
                                                  });
                                                  addToCart(
                                                      snapshot
                                                          .data[index].brand,
                                                      snapshot.data[index].name,
                                                      quantity);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop('dialog');
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text('Database'),
                                                          content: Text(
                                                              'Successfully Added to Cart'),
                                                          actions: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop(
                                                                          'dialog');
                                                                },
                                                                child: Text(
                                                                    'Back to App'))
                                                          ],
                                                        );
                                                      });
                                                }
                                              },
                                              child: Text('Add to Cart')),
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  quantity = 0;
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop('dialog');
                                              },
                                              child: Text('Back'))
                                        ],
                                      );
                                    });
                                  });
                            },
                            icon: Icon(Icons.shopping_cart),
                            label: Text('Add to cart'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(162, 124, 91, 0.7)),
                            ),
                          ),
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

  Widget Trial() {
    return Container(
      height: 275,
      child: FutureBuilder(
        future: getProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Text('Here');
              },
            );
          } else {
            return Text('Here in Null');
          }
        },
      ),
    );
  }

  Future<List<Product>> getProducts() async {
    var data =
        await http.get(Uri.parse('http://127.0.0.1:5000/listAllProducts'));

    var jsonData = json.decode(data.body);
    print('in allProducts');
    print('${data.body}');
    List<Product> productList = [];
    for (var prod in jsonData) {
      var links = await http.get(Uri.parse(
          'http://127.0.0.1:5000/getProductImage/' + prod[2] + '/' + prod[0]));

      var link = json.decode(links.body);
      Product temp =
          Product(name: prod[0], price: prod[1], brand: prod[2], url: link);
      productList.add(temp);
    }
    print(productList);
    print("in get Category");
    return productList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      height: 400,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print("Back");
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.keyboard_arrow_left)),
                                    Text(
                                      'All Products',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 26,
                                      ),
                                    ),
                                  ],
                                ),
                                generateCards(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
          )),
    );
  }
}
