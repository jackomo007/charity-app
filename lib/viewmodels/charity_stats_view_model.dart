import 'package:charity_app/core/models/charity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/charity_repository.dart';

class CharityViewModel extends StateNotifier<AsyncValue<List<Charity>>> {
  final CharityRepository _repository;

  CharityViewModel(this._repository) : super(const AsyncValue.loading()) {
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    try {
      final donations = await _repository.fetchDonations();
      state = AsyncValue.data(donations);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addDonation(String donorName, String category, double amount) async {
    try {
      final newDonation = await _repository.addDonation(donorName, category, amount);
      state = AsyncValue.data([...?state.value, newDonation]);
    } catch (e) {
       state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final charityViewModelProvider =
    StateNotifierProvider<CharityViewModel, AsyncValue<List<Charity>>>((ref) {
  final repository = ref.watch(charityRepositoryProvider);
  return CharityViewModel(repository);
});