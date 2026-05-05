class IngredientModel {
  late String ingredientId;
  late String ingredientName;
  late String ingredientImage;
  late String userId;
  late double originalAmount;
  late double consumption;
  late String unit;
  late DateTime mfg;
  late DateTime exp;
  IngredientModel({
    required this.ingredientId,
    required this.ingredientName,
    required this.ingredientImage,
    required this.userId,
    required this.originalAmount,
    required this.consumption,
    required this.unit,
    required this.mfg,
    required this.exp,
  });
  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      ingredientId: json['ingredientId'] ?? '',
      ingredientName: json['ingredientName'] ?? '',
      ingredientImage: json['ingredientImage'] ?? '',
      originalAmount: json['amount'] ?? 0.0,
      consumption: json['consumption'] ?? 0.0,
      userId: json['userId'] ?? '',
      unit: json['unit'] ?? '',
      mfg: DateTime.parse(json['mfg'] ?? DateTime.now()),
      exp: DateTime.parse(json['exp'] ?? DateTime.now()),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'ingredientName': ingredientName,
      'ingredientImage': ingredientImage,
      'originalAmount': originalAmount,
      'unit': unit,
      'consumption': consumption,
      'mfg': mfg.toIso8601String(),
      'exp': exp.toIso8601String(),
    };
  }
  Map<String, dynamic> updateJson() {
    return {
      'ingredientName': ingredientName,
      'ingredientImage': ingredientImage,
      'originalAmount': originalAmount,
      'unit': unit,
      'consumption': consumption,
      'mfg': mfg.toIso8601String(),
      'exp': exp.toIso8601String(),
    };
  }
}