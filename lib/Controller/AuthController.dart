import 'package:NegXus/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("Logged in successfully");
      Get.offAllNamed("/homePage");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(String email, String password, String name) async {
    isLoading.value = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = result.user?.uid;

      if (uid != null) {
        await initUser(uid, email, name);
        print("Account created successfully.");
        Get.offAllNamed("/homePage");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    await auth.signOut();
    Get.offAllNamed("/authPage");
  }

  Future<void> initUser(String uid, String email, String name) async {
    var newUser = UserModel(
      id: uid,
      email: email,
      name: name,
      createdAt: DateTime.now().toIso8601String(),
      status: "Hey there! I’m using NegXus.",
    );
    try {
      await db.collection("users").doc(uid).set(newUser.toJson());
    } catch (e) {
      print(e);
    }
  }
}
