import 'dart:convert';
import 'dart:io';
import 'package:exam_fluter_managetable/models/data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeViewModel extends ChangeNotifier {
  List<String> dropDownStatus = ["IN_PROGRESS", "COMPLETED"];
  String? selectedLocation = 'IN_PROGRESS', titleText = '', base64String = '';
  SharedPreferences? prefs;
  List<TextEditingController> controller =
      List.generate(2, (i) => TextEditingController());
  bool disable = false;
  int? indexUpdate = 0;
  List<DataModel> dataList = [], searchItem = [];

  init() async {
    prefs = await SharedPreferences.getInstance();
    controller[0].text = '';
    controller[1].text = '';
    getData();
    searchItem = dataList;
  }

  void filterSearchResults(String query) {
    searchItem = dataList
        .where((item) => item.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future setSelected(String newValue) async {
    selectedLocation = newValue;
    notifyListeners();
  }

  Future getImageGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);
    final bytes = File(returnedImage!.path).readAsBytesSync();
    base64String = base64Encode(bytes);
    notifyListeners();
  }

  Future removeImage(String frag) async {
    base64String = '';
    notifyListeners();
  }

  Future inputBtn() async {
    var uuid = const Uuid();
    String id = uuid.v4();
    final now = DateTime.now();
    final selectedTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);
    dataList.add(DataModel(
        id: id,
        title: controller[0].text,
        description: controller[1].text,
        createdAtDateTime: selectedTime.toString(),
        image: base64String ?? '',
        status: selectedLocation));
    String rawJson = jsonEncode(dataList);
    if (controller[0].text != '') {
      prefs!.setString('Data', rawJson);
    }

    notifyListeners();
  }

  Future getData() async {
    dataList = [];
    var resData = jsonDecode(prefs!.getString('Data')!);
    for (var element in resData) {
      dataList.add(
        DataModel(
            id: element['id'],
            description: element['description'],
            title: element['title'],
            createdAtDateTime: element['createdAtDateTime'],
            image: element['image'],
            status: element['status']),
      );
    }

    notifyListeners();
  }

  Future beginUpdate(int index) async {
    disable = true;
    controller[0].text = dataList[index].title!;
    controller[1].text = dataList[index].description!;
    base64String = dataList[index].image!;
    selectedLocation = dataList[index].status!;
    indexUpdate = index;

    notifyListeners();
  }

  Future updateData() async {
    final now = DateTime.now();
    final selectedTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    dataList[indexUpdate!].title = controller[0].text;
    dataList[indexUpdate!].description = controller[1].text;
    dataList[indexUpdate!].createdAtDateTime = selectedTime.toString();
    dataList[indexUpdate!].status = selectedLocation;
    dataList[indexUpdate!].image = base64String ?? '';

    String rawJson = jsonEncode(dataList);

    if (controller[0].text != '') {
      prefs!.setString('Data', rawJson);
    }
    disable = false;
    controller[0].text = '';
    controller[1].text = '';
    selectedLocation = 'IN_PROGRESS';
    base64String = '';
    getData();
    notifyListeners();
  }
}
