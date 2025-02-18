class HiddenBalance {
  double hiddenBalance;

  HiddenBalance({this.hiddenBalance = 0.0});

  HiddenBalance copyWith({double? hiddenBalance}) {
    return HiddenBalance(
      hiddenBalance: hiddenBalance ?? this.hiddenBalance,
    );
  }

  Map<String, dynamic> toJson() => {'hiddenBalance': hiddenBalance};

  factory HiddenBalance.fromJson(Map<String, dynamic> json) {
    return HiddenBalance(
      hiddenBalance: json['hiddenBalance'] ?? 0.0,
    );
  }
}
