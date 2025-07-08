class Exp {
  String? desc;
  String? cat;
  double amount;
  DateTime date;
  String? id;
  Exp({
    this.id,
    this.desc,
    this.cat,
    required this.amount,
    required this.date,
  });
}
