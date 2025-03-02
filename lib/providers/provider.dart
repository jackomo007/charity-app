import 'package:charity_app/core/models/charity.dart';
import 'package:charity_app/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/graphql_service.dart';

// GraphQL Service Provider
final graphQLServiceProvider = Provider<GraphQLService>((ref) {
  return GraphQLService();
});

// Charity ViewModel Provider
final charityViewModelProvider = StateNotifierProvider<CharityViewModel, List<Charity>>((ref) {
  final graphQLService = ref.read(graphQLServiceProvider);
  return CharityViewModel(graphQLService);
});