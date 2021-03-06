import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:deeprooted_parikshit/cubits/cubit/repositories/coins_repo.dart';
import 'package:deeprooted_parikshit/models/bids_and_ask.dart';
import 'package:deeprooted_parikshit/models/conversion_brief.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'search_coins_state.dart';

class SearchCoinsCubit extends Cubit<SearchCoinsState> {
  SearchCoinsCubit({this.coinsRepo}) : super(SearchCoinsInitial());
  final CoinsRepo? coinsRepo;
  bool showBids = false;
  void getDataForCoins(
      {String searchKeyword = '', bool showBidsTapped = false}) async {
    if (showBidsTapped) showBids = !showBids;
    try {
      if (searchKeyword.isNotEmpty) {
        emit(LoadingState());
        final convData = await coinsRepo!.getConversionBrief(searchKeyword);
        if (!showBids) {
          emit(LoadedBriefState(convData));
        } else {
          final bidData = await coinsRepo!.getBidsAndAsks(searchKeyword);
          emit(LoadedBidsState(bidData, convData));
        }
      } else {
        emit(ErrorState(errorMessage: "Enter a currency pair to load data"));
        log("Enter a currency pair to load data");
      }
    } catch (e) {
      emit(ErrorState(errorMessage: "Something Went Wrong"));
    }
  }
}
