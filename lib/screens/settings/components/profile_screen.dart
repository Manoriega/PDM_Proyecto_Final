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
  final List<BattleItem> battles;
  const ProfileScreen({super.key, required this.battles});

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
            return SingleChildScrollView(
              child: Padding(
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
                                try {
                                  imageFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  BlocProvider.of<UserBloc>(context)
                                      .add(ResetProfileEvent());
                                  await UploadFile(imageFile!.path);
                                  BlocProvider.of<UserBloc>(context)
                                      .add(GetMyProfileEvent());
                                } catch (e) {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(ResetProfileEvent());
                                  BlocProvider.of<UserBloc>(context)
                                      .add(GetMyProfileEvent());
                                }
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
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {});
                            ShowCustomDialog(context, const ChangeNameDialog());
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text("Creation date"),
                        subtitle: Text(toDate(state.myUser.createdAt)),
                      ),
                      ListTile(
                        title: const Text("Trainer points"),
                        subtitle: Text(state.myUser.trainerPoints.toString()),
                      ),
                      Column(
                        children: widget.battles,
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is LoadingUserState || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorLoadingUserState) {
            return const Center(
                child: Text(
                    "Ocurrió un error al cargar el perfil. Intenta más tarde"));
          }
          return const Center(child: Text("Nada que mostrar"));
        },
      ),
    );
  }

  toDate(DateTime dt) {
    return "${dt.day}-${dt.month}-${dt.year} at ${dt.hour}:${dt.minute}";
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
