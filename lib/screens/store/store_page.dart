import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/screens/store/ItemWidget.dart';
import 'package:pokimon/screens/store/bloc/store_bloc.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreState>(
      builder: (context, state) {
        if (state is StoreSuccedState) {
          List<ItemWidget> itemsWidget = [];
          for (var item in state.storeItems) {
            itemsWidget.add(ItemWidget(storeItem: item));
          }
          return GridView.count(
            crossAxisCount: 2,
            children: itemsWidget,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
