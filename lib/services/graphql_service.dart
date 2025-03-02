import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  late final GraphQLClient _client;

  GraphQLService() {
    final HttpLink httpLink = HttpLink(
      'https://charity-8ba6095og-angels-projects-1a4dcd1f.vercel.app/graphql',
    );

    _client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  GraphQLClient get client => _client;

  Future<List<Map<String, dynamic>>> fetchDonations() async {
    const String query = """
      query {
        donations {
          id
          amount
          donorName
          category
          month
        }
      }
    """;

    final QueryOptions options = QueryOptions(document: gql(query));

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        print("❌ Error al obtener donaciones: ${result.exception.toString()}");
        return [];
      }

      return List<Map<String, dynamic>>.from(result.data?['donations'] ?? []);
    } catch (e) {
      print("🔥 Error inesperado: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> addDonation({
    required String donorName,
    required String category,
    required double amount,
  }) async {
    const String mutation = """
      mutation AddDonation(\$donorName: String!, \$category: String!, \$amount: Float!) {
        addDonation(donorName: \$donorName, category: \$category, amount: \$amount) {
          id
          donorName
          category
          amount
          month
        }
      }
    """;

    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: {
        'donorName': donorName,
        'category': category,
        'amount': amount,
      },
    );

    try {
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        print("❌ Error al agregar donación: ${result.exception.toString()}");
        return null;
      }

      return result.data?['addDonation'];
    } catch (e) {
      print("🔥 Error inesperado: $e");
      return null;
    }
  }
}