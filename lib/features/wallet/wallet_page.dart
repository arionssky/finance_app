import 'package:finance_app/common/widgets/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../common/constants/app_colors.dart';
import '../../common/constants/app_text_styles.dart';
import '../../common/constants/routes.dart';
import '../../common/extensions/sizes.dart';
import '../../common/widgets/app_header.dart';
import '../../common/widgets/base_page.dart';
import '../../common/widgets/custom_circular_progress_indicator.dart';
import '../../common/widgets/transaction_listview/transaction_listview.dart';
import '../../locator.dart';
import '../home/home_controller.dart';
import '../home/widgets/balance_card/balance_card_widget_controller.dart';
import '../home/widgets/balance_card/balance_card_widget_state.dart';
import 'connect_wallet_page.dart';
import 'wallet_controller.dart';
import 'wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin, CustomModalSheetMixin {
  final walletController = locator.get<WalletController>();
  final balanceController = locator.get<BalanceCardWidgetController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    walletController.getAllTransactions();
    balanceController.getBalances();

    walletController.addListener(() {
      if (walletController.state is WalletStateError) {
        showCustomModalBottomSheet(
          context: context,
          content: (walletController.state as WalletStateError).message,
          buttonText: 'Нэвтрэх',
          isDismissible: false,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            NamedRoute.signIn,
            ModalRoute.withName(NamedRoute.initial),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    locator.resetLazySingleton<WalletController>();
    locator.resetLazySingleton<BalanceCardWidgetController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        locator.get<HomeController>().pageController.jumpToPage(0);
        return false;
      },
      child: Stack(
        children: [
          AppHeader(
            title: 'Түрийвч', // Wallet
            onPressed: () {
              locator.get<HomeController>().pageController.jumpToPage(0);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 165.h,
            bottom: 0,
            child: BasePage(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 48.0,
                ),
                child: Column(
                  children: [
                    Text(
                      'Нийт үлдэгдэл', // Total Balance
                      style: AppTextStyles.inputLabelText
                          .apply(color: AppColors.grey),
                    ),
                    const SizedBox(height: 8.0),
                    AnimatedBuilder(
                        animation: balanceController,
                        builder: (context, _) {
                          if (balanceController.state
                          is BalanceCardWidgetStateLoading) {
                            return const CustomCircularProgressIndicator();
                          }
                          return Text(
                            '\$ ${balanceController.balances.totalBalance.toStringAsFixed(2)}',
                            style: AppTextStyles.mediumText30
                                .apply(color: AppColors.blackGrey),
                          );
                        }),
                    const SizedBox(height: 24.0),
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          context,
                          icon: Icons.add,
                          label: 'Нэмэх', // Add
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectWalletPage()),
                          ),
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.payment,
                          label: 'Төлөх', // Pay
                          onTap: () {},
                        ),
                        _buildActionButton(
                          context,
                          icon: Icons.send,
                          label: 'Илгээх', // Send
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.green,
                      labelColor: AppColors.green,
                      unselectedLabelColor: AppColors.darkGrey,
                      tabs: [
                        Tab(text: 'Гүйлгээнүүд'), // Transactions
                        Tab(text: 'Хүлээгдэж буй гүйлгээ'), // Upcoming Transactions
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    // Transactions or Upcoming Transactions
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTransactionListView(), // Transactions
                          _buildUpcomingTransactionListView(), // Upcoming Transactions
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required IconData icon,
        required String label,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.iceWhite,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.green, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.mediumText18.apply(color: AppColors.blackGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListView() {
    return AnimatedBuilder(
      animation: walletController,
      builder: (context, _) {
        if (walletController.state is WalletStateLoading) {
          return const CustomCircularProgressIndicator(
            color: AppColors.green,
          );
        }
        if (walletController.state is WalletStateError) {
          return const Center(
            child: Text('An error has occurred'),
          );
        }
        if (walletController.state is WalletStateSuccess &&
            walletController.transactions.isNotEmpty) {
          return TransactionListView(
            transactionList: walletController.transactions,
            itemCount: walletController.transactions.length,
            isLoading: walletController.isLoading,
            onLoading: (value) {
              if (value) {
                walletController.fetchMore;
              }
            },
          );
        }
        return const Center(
          child: Text('Гүйлгээ хийгдээгүй байна.'), // No Transactions
        );
      },
    );
  }

  Widget _buildUpcomingTransactionListView() {
    // Temporary upcoming transactions list for UI
    final upcomingTransactions = [
      {
        'icon': Icons.phone,
        'title': 'Phone Bill',
        'date': 'Apr 5, 2022',
        'amount': '\$40.00',
      },
      {
        'icon': Icons.subscriptions,
        'title': 'Netflix',
        'date': 'Apr 10, 2022',
        'amount': '\$12.99',
      },
      {
        'icon': Icons.car_rental,
        'title': 'Car Loan',
        'date': 'Apr 15, 2022',
        'amount': '\$300.00',
      },
    ];

    return ListView.builder(
      itemCount: upcomingTransactions.length,
      itemBuilder: (context, index) {
        final transaction = upcomingTransactions[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.iceWhite,
            child: Icon(transaction['icon'] as IconData, color: AppColors.green),
          ),
          title: Text(transaction['title'] as String,
              style: AppTextStyles.mediumText18),
          subtitle: Text(transaction['date'] as String,
              style: AppTextStyles.smallText13),
          trailing: Text(
            transaction['amount'] as String,
            style: AppTextStyles.mediumText18.apply(color: AppColors.green),
          ),
        );
      },
    );
  }
}
