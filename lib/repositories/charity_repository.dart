import 'package:charity_app/core/models/charity.dart';
import 'package:charity_app/core/services/graphql_service.dart';
import 'package:charity_app/providers/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CharityRepository {
  final GraphQLService _graphqlService;

  CharityRepository(this._graphqlService);

  Future<List<Charity>> fetchDonations() async {
    const String query = '''
      query {
        donations {
          id
          donorName
          category
          amount
          month
        }
      }
    ''';

    final result = await _graphqlService.client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw result.exception!;
    }

    return (result.data?['donations'] as List)
        .map((json) => Charity.fromJson(json))
        .toList();
  }

  Future<Charity> addDonation(String donorName, String category, double amount) async {
    const String mutation = '''
      mutation AddDonation(\$donorName: String!, \$category: String!, \$amount: Float!) {
        addDonation(donorName: \$donorName, category: \$category, amount: \$amount) {
          id
          donorName
          category
          amount
          month
        }
      }
    ''';

    final result = await _graphqlService.client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {'donorName': donorName, 'category': category, 'amount': amount},
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    return Charity.fromJson(result.data!['addDonation']);
  }
}

final charityRepositoryProvider = Provider<CharityRepository>((ref) {
  final graphqlService = ref.watch(graphQLServiceProvider);
  return CharityRepository(graphqlService);
});