class Budgets {
  final String id;
  String reason;
  String amount;
  bool isCompleted;

  Budgets({
    required this.id,
    required this.reason,
    required this.amount,
    this.isCompleted = false,
  });

  factory Budgets.fromJson(Map<String, dynamic> json) {
    return Budgets(
      id: json['id'] as String,
      reason: json['reason'] as String,
      amount: json['amount'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reason': reason,
        'amount': amount,
        'isCompleted': isCompleted,
      };
}
