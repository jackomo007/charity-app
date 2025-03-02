import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/charity.dart';
import '../services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CharityViewModel extends StateNotifier<List<Charity>> {
  final GraphQLService _graphqlService;

  CharityViewModel(this._graphqlService) : super([]);

  Future<void> fetchDonations() async {
    const String query = '''
      query {
        donations {
          amount
          category
          donorName
          id
          month
        }
      }
    ''';
    print('Fetching donations...'); // Log the fetching process
    try {
      final result = await _graphqlService.client.query(
        QueryOptions(document: gql(query)),
      );

      if (result.hasException) {
        throw result.exception!;
      }

      final List<dynamic> data = result.data!['donations'];
       print('Parsed donations data: $data'); // Log the parsed data
      state = data.map((json) => Charity.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching donations: $e');
    }
  }
}
