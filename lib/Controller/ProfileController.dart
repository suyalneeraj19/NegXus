import 'package:NegXus/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  Rx<UserModel> currentUser = UserModel().obs;

  void onInit() async {
    super.onInit();
    await getUserDetails();
  }

  Future<void> getUserDetails() async {
    await db.collection("users").doc(auth.currentUser!.uid).get().then((value) => {
          currentUser.value = UserModel.fromJson(
            value.data()!,
          )
        });
  }

  Future<void> updateProfile({
    String? name,
    String? about,
    String? phoneNumber,
    String? imagePath,
  }) async {
    isLoading.value = true;

    try {
      String? imageUrl = currentUser.value.profileImage;

      if (imagePath != null && imagePath.isNotEmpty) {
        imageUrl = await uploadImageToCloudinary(imagePath);
      }

      print(imageUrl);

      final updatedUser = UserModel(
        name: name,
        about: about,
        phoneNumber: phoneNumber,
        profileImage: imageUrl,
      );
      await db.collection("users").doc(auth.currentUser!.uid).set(
            updatedUser.toJson(),
          );
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  Future<String> uploadImageToCloudinary(String imagePath) async {
    const cloudName = 'dxvnxycz6';
    const uploadPreset = 'flutter_upload';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final file = File(imagePath);
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    final res = await http.Response.fromStream(response);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['secure_url']; // ← use this URL to store in Firestore or user profile
    } else {
      print('Upload failed: ${res.body}');
      return '';
    }
  }
}
