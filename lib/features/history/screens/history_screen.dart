import 'package:six_cash/common/widgets/custom_app_bar_widget.dart';
import 'package:six_cash/features/history/controllers/transaction_history_controller.dart';
import 'package:six_cash/features/history/domain/models/transaction_model.dart';
import 'package:six_cash/features/history/widgets/transaction_type_button_widget.dart';
import 'package:six_cash/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_cash/features/history/widgets/transaction_list_widget.dart';

class HistoryScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final Transactions? transactions;
  HistoryScreen({Key? key, this.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<TransactionHistoryController>().setIndex(0);
    return Scaffold(
      appBar: CustomAppbarWidget(title: 'history'.tr, onlyTitle: true),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await Get.find<TransactionHistoryController>().getTransactionData(1,reload: true);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [

              SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverDelegate(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        height: 50, alignment: Alignment.centerLeft,
                        child: GetBuilder<TransactionHistoryController>(
                          builder: (historyController){
                            return ListView(
                              shrinkWrap: true,
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  TransactionTypeButtonWidget(text: 'all'.tr, index: 0, transactionHistoryList : historyController.transactionList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'send_money'.tr, index: 1, transactionHistoryList: historyController.sendMoneyList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'cash_in'.tr, index: 2, transactionHistoryList: historyController.cashInMoneyList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'add_money'.tr, index: 3, transactionHistoryList: historyController.addMoneyList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'received_money'.tr, index: 4, transactionHistoryList: historyController.receivedMoneyList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'cash_out'.tr, index: 5, transactionHistoryList: historyController.cashOutList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'withdraw'.tr, index: 6, transactionHistoryList: historyController.withdrawList),
                                  const SizedBox(width: 10),

                                  TransactionTypeButtonWidget(text: 'payment'.tr, index: 7, transactionHistoryList: historyController.paymentList),
                                  const SizedBox(width: 10),

                                ]);
                          },

                        ),
                      ))),
              SliverToBoxAdapter(
                child: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: TransactionListWidget(scrollController: _scrollController,isHome: false),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}