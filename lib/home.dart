import 'dart:async';
import 'package:bottlebucks/addaccount.dart';
import 'package:bottlebucks/login.dart';
import 'package:bottlebucks/redeemgift.dart';
import 'package:bottlebucks/scanner.dart';
import 'package:bottlebucks/services/loginapi.dart';
import 'package:bottlebucks/services/profileapi.dart';
import 'package:bottlebucks/viewreward.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  Map<String, dynamic> profileMap = {};
  bool isLoading = true;

  late AnimationController _textController;
  late AnimationController _gridController;
  late Animation<double> _textAnimation;
  late Animation<double> _gridAnimation;
  late PageController _pageController;

  int _currentPage = 0;
  final List<String> _bannerImages = [
    "https://plus.unsplash.com/premium_photo-1664297616271-108d12531317?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDF8fGJvdHRsZSUyMHJlbGF0ZWQlMjBpbWFnZXN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
    "https://images.unsplash.com/photo-1616268198462-50a80c4785d0?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGJvdHRsZSUyMHJlbGF0ZWQlMjBpbWFnZXN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=600",
    "https://images.unsplash.com/photo-1641169126642-f99b68fb419a?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Ym90dGxlJTIwcmVsYXRlZCUyMGltYWdlc3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=600",
  ];

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );
    _gridAnimation = CurvedAnimation(
      parent: _gridController,
      curve: Curves.easeOut,
    );

    _textController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _gridController.forward();
    });

    _pageController = PageController(initialPage: 0);
    _autoSlideBanner();

    loadProfile();
  }

  Future<void> loadProfile() async {
    final data = await fetchProfilee();
    setState(() {
      profileMap = data;
      isLoading = false;
    });
  }

  void _autoSlideBanner() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _gridController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("BottleBucks"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                profileMap['name'] ?? 'No Name',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "Email: ${profileMap['email'] ?? 'No Email'}",
                style: const TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage:
                    profileMap['profileImage'] != null &&
                            profileMap['profileImage'].toString().isNotEmpty
                        ? NetworkImage('$baseUrl${profileMap['profileImage']}')
                        : const AssetImage('assets/default_profile.png')
                            as ImageProvider,
              ),
              decoration: const BoxDecoration(color: Colors.deepPurple),
            ),

            // Home
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),

            // Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile page
              },
            ),

            // Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),

            // Optional: Show points as a separate tile for more visibility
            ListTile(
              leading: const Icon(Icons.star),
              title: Text("Points: ${profileMap['points'] ?? 0}"),
              onTap: () {},
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: _bannerImages.length,
                      onPageChanged:
                          (index) => setState(() => _currentPage = index),
                      itemBuilder:
                          (context, index) => Image.network(
                            _bannerImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _bannerImages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 20 : 8,
                            decoration: BoxDecoration(
                              color:
                                  _currentPage == index
                                      ? Colors.white
                                      : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            FadeTransition(
              opacity: _textAnimation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Points: ${profileMap['points'] ?? 0}",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      List<Map<String, dynamic>> accounts = [];
                      bool isLoadingAccounts = true;

                      // Step 1: Fetch accounts from API
                      try {
                        final response = await Dio().get(
                          '$baseUrl/api/Viewaccount/$loginId',
                        );

                        if (response.statusCode == 200) {
                          final List<dynamic> data = response.data;
                          print(response.data);
                          accounts =
                              data.map((item) {
                                return {
                                  "accountId":
                                      item['id'], // assuming API returns account ID
                                  "accountNo": item['accountno'] ?? "",
                                  "ifsc": item['IFSC_code'] ?? "",
                                  "bank": item['bank_name'] ?? "",
                                };
                              }).toList();
                        }
                      } catch (e) {
                        print("Error fetching accounts: $e");
                        accounts = [];
                      } finally {
                        isLoadingAccounts = false;
                      }

                      // Step 2: Show account selection dialog
                      final selectedAccount = await showDialog<
                        Map<String, dynamic>
                      >(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text("Select Account"),
                              content: SizedBox(
                                width: double.maxFinite,
                                child:
                                    isLoadingAccounts
                                        ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                        : accounts.isEmpty
                                        ? const Center(
                                          child: Text("No accounts found"),
                                        )
                                        : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: accounts.length,
                                          itemBuilder: (context, index) {
                                            final acc = accounts[index];
                                            return ListTile(
                                              title: Text(
                                                "${acc['bank']} - ${acc['accountNo']}",
                                              ),
                                              subtitle: Text(
                                                "IFSC: ${acc['ifsc']}",
                                              ),
                                              onTap:
                                                  () => Navigator.pop(ctx, acc),
                                            );
                                          },
                                        ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, null),
                                  child: const Text("Cancel"),
                                ),
                              ],
                            ),
                      );

                      // Step 3: Show confirmation dialog
                      if (selectedAccount != null) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text("Confirm Redemption"),
                                content: Text(
                                  "Do you want to redeem your points using account ${selectedAccount['bank']} - ${selectedAccount['accountNo']}?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text("Confirm"),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          try {
                            // Step 4: Call redeem API
                            final response = await Dio().post(
                              '$baseUrl/api/creditpoints/',
                              data: {
                                "user_id": loginId,
                                "account_id": selectedAccount['accountId'],
                                "points":
                                    profileMap['points'], // redeem all points
                              },
                            );

                            if (response.statusCode == 200) {
                              final remainingPoints =
                                  response.data['remaining_points'];
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Points redeemed successfully! Remaining: $remainingPoints",
                                  ),
                                ),
                              );

                              // Update local points
                              setState(() {
                                profileMap['points'] = remainingPoints;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to redeem points"),
                                ),
                              );
                            }
                          } catch (e) {
                            print("Error redeeming points: $e");
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Error redeeming points"),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text("Redeem"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            FadeTransition(
              opacity: _textAnimation,
              child: const Text(
                "Here’s what you can do today",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _gridAnimation,
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCard(
                    icon: Icons.card_giftcard_sharp,
                    label: "Redeem Gift",
                    color: Colors.orange,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RedeemGift(),
                        ),
                      );
                      if (result == true) {
                        await loadProfile();
                      }
                    },
                  ),
                  _buildCard(
                    icon: Icons.money,
                    label: "Add Account",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Addaccount(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.store,
                    label: "View Rewards",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewReward(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    icon: Icons.qr_code_scanner,
                    label: "Qr Scan",
                    color: Colors.redAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScannerPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
