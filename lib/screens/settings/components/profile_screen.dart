import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/classes/user.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
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
  bool isActive = false;
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
                      CircleAvatar(
                        radius: 84,
                        child: LayoutBuilder(builder: (context, constraint) {
                          return Icon(Icons.account_circle_outlined,
                              size: constraint.biggest.height);
                        }),
                      ),
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
                        subtitle: Text(state.myUser.createdAt.toString()),
                      ),
                      Column(
                        children: widget.battles,
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is LoadingUserState) {
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
}
