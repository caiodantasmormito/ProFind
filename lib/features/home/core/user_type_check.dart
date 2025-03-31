import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserTypeChecker extends StatelessWidget {
  final Widget clientHome;
  final Widget serviceProviderHome;
  final Widget loadingWidget;

  const UserTypeChecker({
    super.key,
    required this.clientHome,
    required this.serviceProviderHome,
    this.loadingWidget = const Center(child: CircularProgressIndicator()),
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

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final userType = userData['userType'];

        if (userType == 'client') {
          return clientHome;
        } else if (userType == 'service_provider') {
          return serviceProviderHome;
        }

        return SizedBox.shrink();
      },
    );
  }

  Future<DocumentSnapshot> _getUserDocument(String userId) async {
    final clientDoc = await FirebaseFirestore.instance
        .collection('clients')
        .doc(userId)
        .get();

    if (clientDoc.exists) {
      return clientDoc;
    }

    final providerDoc = await FirebaseFirestore.instance
        .collection('service_providers')
        .doc(userId)
        .get();

    return providerDoc;
  }
}
