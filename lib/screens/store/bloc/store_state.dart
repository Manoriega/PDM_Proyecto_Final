part of 'store_bloc.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

class StoreInitial extends StoreState {}

class LoadingStoreState extends StoreState {}

class StoreSuccedState extends StoreState {
  final List<Item> storeItems;

  StoreSuccedState(this.storeItems);

  @override
  // TODO: implement props
  List<Object> get props => [storeItems];
}
