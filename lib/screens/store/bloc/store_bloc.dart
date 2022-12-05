import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../classes/item.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreInitial()) {
    on<GetStoreEvent>(_getStore);
  }

  _getStore(event, emit) async {
    var queryItems =
        await FirebaseFirestore.instance.collection("pocket_items").get();
    var items = queryItems.docs
        .map((doc) => doc.data().cast<String, dynamic>())
        .toList();
    List<Item> storeItems = [];
    for (var i in items) {
      print(i);
      storeItems.add(Item(i["name"], i["effectValue"], i["type"], i["imageUrl"],
          i["description"], i["price"]));
    }
    emit(StoreSuccedState(storeItems));
  }
}
