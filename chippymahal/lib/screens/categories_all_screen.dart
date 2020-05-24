import 'dart:math';

import 'package:sabon/components/catogory_list_item_widget.dart';
import 'package:sabon/components/custom_category_item.dart';
import 'package:sabon/model/category_data.dart';
import 'package:flutter/material.dart';

class AllCategoriesScreen extends StatefulWidget {
  final List<CategoryData> categories;

  AllCategoriesScreen({this.categories});

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Categories'),
        ),
        body: ListView.builder(
          itemCount: widget.categories.length,
          itemBuilder: (BuildContext context, int index) =>
              CategoryListItem(
                iconPath: 'assets/images/icon_hamburger.png',
                name: widget.categories[index].name,
                places: 350,
              ),
        ));
  }
}
