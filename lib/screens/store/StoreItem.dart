class StoreItem {
  final String description;
  final int effectvalue;
  final String itemImage;
  final String name;

  StoreItem(this.description, this.effectvalue, this.itemImage, this.name);
  StoreItem.fromDocument(Map<String, dynamic> document)
      : description = document['description'],
        effectvalue = document['effectValue'] as int,
        itemImage = document['imageUrl'],
        name = document['name'];
}
