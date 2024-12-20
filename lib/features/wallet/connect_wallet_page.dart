import 'package:flutter/material.dart';

class ConnectWalletPage extends StatefulWidget {
  @override
  _ConnectWalletPageState createState() => _ConnectWalletPageState();
}

class _ConnectWalletPageState extends State<ConnectWalletPage> {
  bool showCards = true; // Toggle between Cards and Accounts
  int selectedAccountIndex = -1; // Track the selected account option (-1 means none)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF5F7), // Light background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Connect Wallet',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Card and Accounts Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showCards = true;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: showCards ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: showCards
                            ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                            : [],
                      ),
                      child: Text(
                        'Cards',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: showCards ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showCards = false;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !showCards ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: !showCards
                            ? [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                            : [],
                      ),
                      child: Text(
                        'Accounts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: !showCards ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            // Show either Cards or Accounts section
            showCards ? _buildCardsSection() : _buildAccountsSection(),
          ],
        ),
      ),
    );
  }

  // Unchanged Cards Section
  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Debit Card Widget
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF009688), // Card background color
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Debit Card',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '6219 8610 2888 8075',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'IRVAN MOSES',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '22/01',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        // Add Debit Card Form
        Text(
          'Add your debit Card',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'This card must be connected to a bank account under your name',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 24),
        // Form Fields
        _buildTextField(label: 'Name on Card', placeholder: 'IRVAN MOSES'),
        SizedBox(height: 16),
        _buildTextField(label: 'Debit Card Number', placeholder: 'Enter card number'),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(label: 'CVC', placeholder: '123'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(label: 'Expiration MM/YY', placeholder: 'MM/YY'),
            ),
          ],
        ),
        SizedBox(height: 16),
        _buildTextField(label: 'ZIP', placeholder: 'Enter ZIP Code'),
        SizedBox(height: 32),
        // Add Card Button
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Color(0xFF009688),
            ),
            child: Text(
              'Add Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Updated Accounts Section
  Widget _buildAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountTile(
          icon: Icons.account_balance,
          title: 'Bank Link',
          subtitle: 'Connect your bank account to deposit & fund',
          index: 0,
        ),
        _buildAccountTile(
          icon: Icons.attach_money,
          title: 'Microdeposits',
          subtitle: 'Connect bank in 5-7 days',
          index: 1,
        ),
        _buildAccountTile(
          icon: Icons.paypal,
          title: 'PayPal',
          subtitle: 'Connect your PayPal account',
          index: 2,
        ),
        SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: selectedAccountIndex == -1
                ? null
                : () {
              // Proceed with selected account
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor:
              selectedAccountIndex == -1 ? Colors.grey : Color(0xFF009688),
            ),
            child: Text(
              'Next',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: selectedAccountIndex == -1
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccountIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedAccountIndex == index
              ? Color(0xFFE0F7FA)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedAccountIndex == index
                ? Color(0xFF009688)
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 36,
              color: selectedAccountIndex == index
                  ? Color(0xFF009688)
                  : Colors.grey,
            ),
            SizedBox(width: 16),
            Expanded( // Prevent overflow by limiting the text space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: selectedAccountIndex == index
                          ? Color(0xFF009688)
                          : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),
            if (selectedAccountIndex == index)
              Icon(
                Icons.check_circle,
                color: Color(0xFF009688),
              ),
          ],
        ),
      ),
    );
  }


  // Reusable TextField Builder
  Widget _buildTextField({required String label, required String placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF009688)),
            ),
          ),
        ),
      ],
    );
  }
}
