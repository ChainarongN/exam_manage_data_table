import 'dart:convert';

import 'package:exam_fluter_managetable/pages/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:provider/provider.dart';

class TableView extends StatefulWidget {
  const TableView({super.key});

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, data, child) => HorizontalDataTable(
        leftHandSideColumnWidth: 100,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: data.searchItem.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black38,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
      ),
    );
    ;
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('ID', 100),
      _getTitleItemWidget('Title', 100),
      _getTitleItemWidget('Desc', 140),
      _getTitleItemWidget('DateTime', 100),
      _getTitleItemWidget('Images', 100),
      _getTitleItemWidget('Status', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Consumer _generateFirstColumnRow(BuildContext context, int index) {
    return Consumer<HomeViewModel>(
      builder: (context, data, child) => GestureDetector(
        onTap: () {
          data.beginUpdate(index);
        },
        child: Container(
          width: 100,
          height: 80,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(data.searchItem[index].id!),
        ),
      ),
    );
  }

  Consumer _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Consumer<HomeViewModel>(
      builder: (context, data, child) => GestureDetector(
        onTap: () {
          data.beginUpdate(index);
        },
        child: Row(
          children: <Widget>[
            Container(
                width: 100,
                height: 80,
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                alignment: Alignment.centerLeft,
                child: Text(data.searchItem[index].title!)),
            Container(
              width: 140,
              height: 80,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(data.searchItem[index].description!),
            ),
            Container(
              width: 100,
              height: 80,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(data.searchItem[index].createdAtDateTime!),
            ),
            Container(
              width: 100,
              height: 80,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: data.searchItem[index].image == ''
                  ? Image.network(
                      "https://cdn.vectorstock.com/i/preview-1x/48/06/image-preview-icon-picture-placeholder-vector-31284806.jpg",
                    )
                  : Image.memory(base64Decode(data.searchItem[index].image!)),
            ),
            Container(
              height: 80,
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(data.searchItem[index].status!),
            ),
          ],
        ),
      ),
    );
  }
}
