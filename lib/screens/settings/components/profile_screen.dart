import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/settings/bloc/user_bloc.dart';
import 'package:pokimon/screens/settings/components/battle_item.dart';
import 'package:pokimon/screens/settings/components/changename_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is UserSucceed) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 84,
                      child: LayoutBuilder(builder: (context, constraint) {
                        return Icon(Icons.account_circle,
                            size: constraint.biggest.height);
                      }),
                    ),
                    ListTile(
                      title: Text(
                        state.myUser.userName,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
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
}
