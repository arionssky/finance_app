import 'package:flutter/material.dart';
import 'package:finance_app/common/constants/app_colors.dart';
import 'package:finance_app/common/constants/app_text_styles.dart';
import 'package:finance_app/common/widgets/app_header.dart';
import 'package:finance_app/common/widgets/base_page.dart';
import 'package:finance_app/common/widgets/custom_circular_progress_indicator.dart';
import 'package:finance_app/common/widgets/transaction_listview/transaction_listview.dart';
import 'package:finance_app/locator.dart';
import 'package:finance_app/features/home/home_controller.dart';
import 'package:finance_app/features/home/widgets/balance_card/balance_card_widget_controller.dart';
import 'package:finance_app/features/home/widgets/balance_card/balance_card_widget_state.dart';
import 'package:finance_app/features/wallet/connect_wallet_page.dart';
import 'package:finance_app/features/wallet/wallet_controller.dart';
import 'package:finance_app/features/wallet/wallet_state.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  final walletController = locator.get<WalletController>();
  final balanceController = locator.get<BalanceCardWidgetController>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    walletController.getAllTransactions();
    balanceController.getBalances();

    walletController.addListener(() {
      if (walletController.state is WalletStateError) {
        // Handle error state
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
            title: 'Түрийвч',
            onPressed: () {
              locator.get<HomeController>().pageController.jumpToPage(0);
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 165.0,
            bottom: 0,
            child: BasePage(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 48.0),
                child: Column(
                  children: [
                    Text(
                      'Нийт үлдэгдэл',
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
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.add,
                          label: 'Нэмэх',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectWalletPage()),
                            );
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.payment,
                          label: 'Төлөх',
                          onTap: () {
                            // Handle "Pay" action
                          },
                        ),
                        _buildActionButton(
                          icon: Icons.send,
                          label: 'Илгээх',
                          onTap: () {
                            // Handle "Send" action
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.green,
                      labelColor: AppColors.green,
                      unselectedLabelColor: AppColors.darkGrey,
                      tabs: const [
                        Tab(text: 'Гүйлгээнүүд'),
                        Tab(text: 'Хүлээгдэж буй гүйлгээ'),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildTransactionListView(),
                          _buildUpcomingTransactionListView(context),
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
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
          return const CustomCircularProgressIndicator(color: AppColors.green);
        }
        if (walletController.state is WalletStateError) {
          return const Center(child: Text('An error has occurred'));
        }
        if (walletController.state is WalletStateSuccess &&
            walletController.transactions.isNotEmpty) {
          return TransactionListView(
            transactionList: walletController.transactions,
            itemCount: walletController.transactions.length,
            isLoading: walletController.isLoading,
            onLoading: (value) {
              if (value) {
                // Corrected: Added parentheses to call the method
              }
            },
          );
        }
        return const Center(child: Text('Гүйлгээ хийгдээгүй байна.'));
      },
    );
  }

  Widget _buildUpcomingTransactionListView(BuildContext context) {
    // Mocked list of upcoming transactions for demonstration purposes
    final upcomingTransactions = [
      {
        'icon': Icons.phone,
        'title': 'Phone Bill',
        'date': 'Apr 5, 2022',
        'price': 40.00,
        'fee': 2.00,
        'amount': 42.00,
      },
      {
        'icon': Icons.subscriptions,
        'title': 'Netflix',
        'date': 'Apr 10, 2022',
        'price': 12.99,
        'fee': 1.00,
        'amount': 13.99,
      },
      {
        'icon': Icons.car_rental,
        'title': 'Car Loan',
        'date': 'Apr 15, 2022',
        'price': 300.00,
        'fee': 10.00,
        'amount': 310.00,
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
          title: Text(
            transaction['title'] as String,
            style: AppTextStyles.mediumText18,
          ),
          subtitle: Text(
            transaction['date'] as String,
            style: AppTextStyles.smallText13,
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${transaction['amount']?.toStringAsFixed(2)}",
                style: AppTextStyles.mediumText18.apply(color: AppColors.green),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailsPage(
                        title: transaction['title'] as String,
                        date: transaction['date'] as String,
                        price: transaction['price'] as double,
                        fee: transaction['fee'] as double,
                        total: transaction['amount'] as double,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  minimumSize: const Size(80, 30),
                ),
                child: Text(
                  'Pay Now',
                  style: AppTextStyles.smallText13.apply(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PaymentDetailsPage extends StatelessWidget {
  final String title;
  final String date;
  final double price;
  final double fee;
  final double total;

  const PaymentDetailsPage({
    Key? key,
    required this.title,
    required this.date,
    required this.price,
    required this.fee,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Bill Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Information
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.subscriptions, color: Colors.red, size: 32),
              ),
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                date,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),

            // Price Details
            _buildPriceRow("Price", price),
            const SizedBox(height: 8),
            _buildPriceRow("Fee", fee),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            _buildPriceRow("Total", total, isBold: true),

            const SizedBox(height: 24),

            // Payment Method Section
            const Text(
              "Select payment method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Debit Card
            _buildPaymentMethod(
                context, "Debit Card", Icons.credit_card, true),

            const SizedBox(height: 8),

            // PayPal
            _buildPaymentMethod(
                context, "Paypal", Icons.paypal, false),

            const Spacer(),

            // Pay Now Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Handle payment action here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Payment Successful!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text(
                "Pay Now",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Colors.black : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
      BuildContext context, String method, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // Handle payment method selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.white,
          border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey[300]!, width: 1.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.teal : Colors.grey, size: 24),
            const SizedBox(width: 16),
            Text(
              method,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.teal : Colors.grey[700],
              ),
            ),
            const Spacer(),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: isSelected ? Colors.teal : Colors.grey[700],
            ),
          ],
        ),
      ),
    );
  }
}
