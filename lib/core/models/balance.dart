class Balance {
  double cash;
  double card;

  Balance({this.cash = 0.0, this.card = 0.0});

  Balance copyWith({double? cash, double? card}) {
    return Balance(
      cash: cash ?? this.cash,
      card: card ?? this.card,
    );
  }

  Map<String, dynamic> toJson() => {
        'cash': cash,
        'card': card,
      };

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      cash: json['cash'] ?? 0.0,
      card: json['card'] ?? 0.0,
    );
  }
}
