import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserTypeChecker extends StatelessWidget {
  final Widget clientHome;
  final Widget serviceProviderHome;
  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget unknownUserWidget;

  const UserTypeChecker({
    super.key,
    required this.clientHome,
    required this.serviceProviderHome,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
    this.errorWidget =
        const Center(child: Text('Erro ao verificar tipo de usuário')),
    this.unknownUserWidget =
        const Center(child: Text('Tipo de usuário desconhecido')),
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Usuário não autenticado'));
    }

    return FutureBuilder<DocumentSnapshot>(
      future: _getUserDocument(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget;
        }

        final userData = snapshot.data!.data();
        final userType = _getUserTypeSafely(userData);

        switch (userType) {
          case 'client':
            return clientHome;
          case 'service_provider':
            return serviceProviderHome;
          default:
            return unknownUserWidget;
        }
      },
    );
  }

  String? _getUserTypeSafely(Object? userData) {
    if (userData == null) return null;
    if (userData is! Map<String, dynamic>) return null;

    final dynamic userType = userData['userType'];

    if (userType is String) return userType;
    if (userType != null) return userType.toString();

    return null;
  }

  Future<DocumentSnapshot> _getUserDocument(String userId) async {
    final clientDoc = await FirebaseFirestore.instance
        .collection('clients')
        .doc(userId)
        .get();

    if (clientDoc.exists) {
      return clientDoc;
    }

    return await FirebaseFirestore.instance
        .collection('service_providers')
        .doc(userId)
        .get();
  }
}
