class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String isActive;
  final String userRole;
  final String token;
  final String machineModule;
  final String clientModule;
  final String userModule;
  final String acknowledgeModule;
  final String tonerRequestModule;
  final String dispatchModule;
  final String receiveModule;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Additional fields for client
  final String? city;
  final List<String>? address;
  final String? contactPerson;
  final int? addBy;
  final String? userType;
  final String supplyChain;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
    required this.userRole,
    required this.token,
    required this.machineModule,
    required this.clientModule,
    required this.userModule,
    required this.supplyChain,
    required this.acknowledgeModule,
    required this.tonerRequestModule,
    required this.dispatchModule,
    required this.receiveModule,
    required this.createdAt,
    required this.updatedAt,
    this.city,
    this.address,
    this.contactPerson,
    this.addBy,
    this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      // Handle address field which might be a List or a String
      List<String> addressList = [];
      if (json['address'] != null) {
        if (json['address'] is List) {
          addressList = List<String>.from(json['address']);
        } else if (json['address'] is String) {
          addressList = [json['address']];
        }
      }

      // Handle isActive which might be named differently
      String activeStatus = '';
      if (json.containsKey('is_active')) {
        activeStatus = json['is_active'].toString();
      } else if (json.containsKey('isActive')) {
        activeStatus = json['isActive'].toString();
      } else {
        activeStatus = '0';
      }

      // Handle add_by which might be String or int
      int? addByValue;
      if (json['add_by'] != null) {
        if (json['add_by'] is int) {
          addByValue = json['add_by'];
        } else if (json['add_by'] is String) {
          addByValue = int.tryParse(json['add_by']);
        }
      }

      return User(
        id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        isActive: activeStatus,
        userRole: json['user_role'] ?? '',
        token: json['token'] ?? '',
        machineModule: json['machine_module']?.toString() ?? '0',
        clientModule: json['client_module']?.toString() ?? '0',
        userModule: json['user_module']?.toString() ?? '0',
        supplyChain: json['supply_chain_module']?.toString() ?? '0',
        acknowledgeModule: json['acknowledge_module']?.toString() ?? '0',
        tonerRequestModule: json['toner_request_module']?.toString() ?? '0',
        dispatchModule: json['dispatch_module']?.toString() ?? '0',
        receiveModule: json['receive_module']?.toString() ?? '0',
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
        city: json['city']?.toString(),
        address: addressList,
        contactPerson: json['contact_person']?.toString(),
        addBy: addByValue,
        userType: json['user_type']?.toString(),
      );
    } catch (e) {
      print("Error parsing User JSON: $e");
      print("Problematic JSON: $json");
      throw Exception('Error parsing User data: $e');
    }
  }
}