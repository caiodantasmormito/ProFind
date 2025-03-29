class ValidateEmailArguments {
  final String name;
  final String surname;
  final String cpf;
  final String cep;
  final String city;
  final String uf;
  final String phone;
  final String address;
  final String? service;
  final String userType;

  ValidateEmailArguments({
    required this.name,
    required this.surname,
    required this.cpf,
    required this.cep,
    required this.city,
    required this.phone,
    required this.uf,
    required this.address,
    required this.userType,
    this.service,
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
      'service': service,
      'userType': userType,
    };
  }

  factory ValidateEmailArguments.fromJson(Map<String, dynamic> json) {
    return ValidateEmailArguments(
      name: json['name'] as String,
      surname: json['surname'] as String,
      cpf: json['cpf'] as String,
      cep: json['cep'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String,
      uf: json['uf'] as String,
      address: json['address'] as String,
      service: json['service'] as String,
      userType: json['userType'],
    );
  }
}
