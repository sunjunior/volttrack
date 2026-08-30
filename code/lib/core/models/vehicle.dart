class Vehicle {
  final int id;
  final String brand;
  final String model;
  final DateTime? purchaseDate;
  final double initialMileageKm;
  final int? initialSocPct;
  final String? note;

  const Vehicle({
    this.id = 0,
    this.brand = '',
    this.model = '',
    this.purchaseDate,
    this.initialMileageKm = 0,
    this.initialSocPct,
    this.note,
  });
}
