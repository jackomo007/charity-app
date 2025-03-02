import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/graphql_service.dart';
import '../models/charity.dart';

final graphQLServiceProvider = Provider<GraphQLService>((ref) {
  return GraphQLService();
});

final charityViewModelProvider = StateNotifierProvider<CharityViewModel, List<Charity>>((ref) {
  final graphQLService = ref.read(graphQLServiceProvider);
  return CharityViewModel(graphQLService);
});

class CharityViewModel extends StateNotifier<List<Charity>> {
  final GraphQLService _graphQLService;

  CharityViewModel(this._graphQLService) : super([]) {
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    final donationsData = await _graphQLService.fetchDonations();

    if (donationsData.isEmpty) {
      return;
    }

    state = donationsData.map((donation) => Charity.fromJson(donation)).toList();
  }

  Future<void> createNewDonation({
    required String donorName,
    required String category,
    required double amount,
  }) async {
    final newDonationData = await _graphQLService.addDonation(
      donorName: donorName,
      category: category,
      amount: amount,
    );

    if (newDonationData != null) {
      final newDonation = Charity.fromJson(newDonationData);
      state = [...state, newDonation];
    }
  }
}