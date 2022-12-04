import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokimon/classes/user.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/login/user_auth_repository.dart';
import 'package:pokimon/screens/settings/bloc/user_bloc.dart';
import 'package:pokimon/screens/settings/components/battle_item.dart';
import 'package:pokimon/screens/settings/components/changename_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserAuthRepository _authRepo = UserAuthRepository();
  XFile? imageFile;

  void PickUploadImage() async {
    var user = await FirebaseAuth.instance.currentUser!.uid;
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile? image;
    image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imagefile = File("${image.path}");
      var snapshot =
          await _firebaseStorage.ref().child("${user}").putFile(imagefile);
      String downloadURL = await snapshot.ref.getDownloadURL();
    } else {
      print("No image received");
    }
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UserSucceed) {
            controller.text = state.myUser.userName;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(state.profileImage),
                        radius: 84,
                      ),
                      Positioned(
                        top: 120,
                        left: 120,
                        child: IconButton(
                            onPressed: () async {
                              imageFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              print(imageFile?.path);
                              UploadFile(imageFile!.path);
                              BlocProvider.of<UserBloc>(context)
                                  .add(ResetProfileEvent());
                              BlocProvider.of<UserBloc>(context)
                                  .add(GetMyProfileEvent());
                              setState(() {});
                            },
                            icon: Icon(
                              Icons.add_a_photo_sharp,
                              size: 50,
                            )),
                      )
                    ]),
                    ListTile(
                      title: Text(
                        state.myUser.userName,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          setState(() {});
                          ShowCustomDialog(context, ChangeNameDialog());
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("Fecha de creación"),
                      subtitle: Text(state.myUser.createdAt.toString()),
                    ),
                    BattleItem()
                  ],
                ),
              ),
            );
          } else if (state is LoadingUserState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ErrorLoadingUserState) {
            return Center(
                child: Text(
                    "Ocurrió un error al cargar el perfil. Intenta más tarde"));
          }
          return Center(child: Text("Nada que mostrar"));
        },
      ),
    );
  }

  Future<String> SearchForProfileImage() async {
    var user = await FirebaseAuth.instance.currentUser!.uid;
    Reference storageRef = FirebaseStorage.instance.ref().child("${user}");
    return storageRef.getDownloadURL();
  }

  UploadFile(String filepath) async {
    try {
      File image = File(filepath);
      var user = await FirebaseAuth.instance.currentUser!.uid;
      Reference storageRef = FirebaseStorage.instance.ref().child("${user}");
      TaskSnapshot uploadTask = await storageRef.putFile(image);

      print("Uploaded image");
      String downloadURL = await uploadTask.ref.getDownloadURL();
      print(downloadURL);
    } catch (e) {
      print(e);
    }
  }
}
