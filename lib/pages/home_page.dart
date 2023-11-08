import 'dart:convert';
import 'package:exam_fluter_managetable/pages/table.dart';
import 'package:exam_fluter_managetable/pages/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HomeViewModel>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              title(context),
              description(context),
              status(),
              addImage(),
              btnInput(context),
              btnUpdate(context),
              searchField(),
              const SizedBox(
                height: 500,
                child: TableView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Consumer<HomeViewModel> searchField() {
    return Consumer<HomeViewModel>(
      builder: (context, data, child) => Container(
        margin: const EdgeInsets.only(left: 20, top: 20),
        width: MediaQuery.of(context).size.width * 0.7,
        height: 70,
        child: TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
              labelText: 'Search'),
          onChanged: (newValue) {
            data.filterSearchResults(newValue);
          },
        ),
      ),
    );
  }

  SizedBox btnUpdate(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Consumer<HomeViewModel>(
        builder: (context, data, child) => OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: 2,
                color: !data.disable
                    ? Colors.grey.shade200
                    : Colors.purple.shade200),
            primary: Colors.black,
            backgroundColor: !data.disable
                ? Colors.grey.shade200
                : const Color.fromARGB(255, 243, 223, 247),
          ),
          onPressed: () {
            if (data.disable) {
              data.updateData();
            }
          },
          child: const Text('Update'),
        ),
      ),
    );
  }

  SizedBox btnInput(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Consumer<HomeViewModel>(
        builder: (context, data, child) => OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: 2,
                color: data.disable
                    ? Colors.grey.shade200
                    : Colors.purple.shade200),
            primary: Colors.black,
            backgroundColor: data.disable
                ? Colors.grey.shade200
                : const Color.fromARGB(255, 243, 223, 247),
          ),
          onPressed: () {
            if (!data.disable) {
              data.inputBtn();
            }
          },
          child: const Text('Input Data'),
        ),
      ),
    );
  }

  Consumer<HomeViewModel> status() {
    return Consumer<HomeViewModel>(
      builder: (context, data, child) => Row(
        children: <Widget>[
          const Text('Status : ', style: TextStyle(fontSize: 18)),
          Container(
            margin: const EdgeInsets.only(left: 25),
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 223, 247),
                borderRadius: BorderRadius.circular(10)),
            child: DropdownButton(
              value: data.selectedLocation,
              onChanged: (newValue) {
                data.setSelected(newValue!);
              },
              items: data.dropDownStatus.map((location) {
                return DropdownMenuItem(
                  value: location,
                  child: Text(location, style: const TextStyle(fontSize: 12)),
                );
              }).toList(),
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 35,
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Container addImage() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Consumer<HomeViewModel>(
        builder: (context, data, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                const Text('Image : ', style: TextStyle(fontSize: 18)),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 2, color: Colors.purple.shade200),
                    primary: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 243, 223, 247),
                  ),
                  onPressed: () {
                    data.getImageGallery();
                  },
                  child: const Text('Add image'),
                )
              ],
            ),
            Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              child: data.base64String == ''
                  ? Image.network(
                      "https://cdn.vectorstock.com/i/preview-1x/48/06/image-preview-icon-picture-placeholder-vector-31284806.jpg",
                    )
                  : Stack(
                      children: <Widget>[
                        Image.memory(base64Decode(data.base64String!)),
                        Positioned(
                          right: 1,
                          top: 1,
                          child: InkWell(
                            child: const Icon(
                              Icons.cancel,
                              size: 25,
                              color: Colors.red,
                            ),
                            onTap: () {
                              data.removeImage('input');
                            },
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Column description(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          alignment: Alignment.centerLeft,
          child: const Text('Description : ', style: TextStyle(fontSize: 18)),
        ),
        Consumer<HomeViewModel>(
          builder: (context, data, child) => Container(
            margin: const EdgeInsets.only(left: 20, bottom: 10),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: data.controller[1],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Row title(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text('Title : ', style: TextStyle(fontSize: 18)),
        Consumer<HomeViewModel>(
          builder: (context, data, child) => Container(
            margin: const EdgeInsets.only(left: 20),
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: data.controller[0],
              maxLength: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
