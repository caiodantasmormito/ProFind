class ValidateEmailArguments {
  final String name;
  final String surname;
  final String cpf;
  final String cep;
  final String city;
  final String uf;
  final String phone;
  final String address;

  ValidateEmailArguments({
    required this.name,
    required this.surname,
    required this.cpf,
    required this.cep,
    required this.city,
    required this.phone,
    required this.uf,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'cpf': cpf,
      'phone': phone,
      'city': city,
      'cep': cep,
      'uf': uf,
      'address': address,
    };
  }

  factory ValidateEmailArguments.fromJson(Map<String, dynamic> json) {
    return ValidateEmailArguments(
      name: json['name'] as String,
      surname: json['surname'] as String,
      cpf: json['cpf'] as String,
      cep: json['cep'] as String,
      city: json['city'],
      phone: json['phone'],
      uf: json['uf'],
      address: json['address'],
    );
  }
}
