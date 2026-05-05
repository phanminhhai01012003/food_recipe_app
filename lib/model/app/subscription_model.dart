class SubscriptionModel {
  late String subscriptionId;
  late String subscriptionName;
  late int price;
  late String priceUnit;
  late String offer;
  late String time;
  SubscriptionModel.fromMap(Map<String, dynamic> data){
    subscriptionId = data['subscriptionId'] ?? '';
    subscriptionName = data['subscriptionName'] ?? '';
    price = data['price'] ?? 0;
    priceUnit = data['priceUnit'] ?? '';
    offer = data['offer'] ?? '';
    time = data['time'] ?? '';
  }
}