import 'package:bottlebucks/services/loginapi.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'loginapi.dart'; // contains baseUrl & loginId

class RedeemGift extends StatefulWidget {
  const RedeemGift({super.key});

  @override
  State<RedeemGift> createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  List<dynamic> gifts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGifts();
  }

  Future<void> fetchGifts() async {
    final dio = Dio();

    try {
      final response = await dio.get('$baseUrl/api/gifts/');
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Fetch Success: ${response.data}");
        setState(() {
          gifts = response.data;
          isLoading = false;
        });
      } else {
        print("Fetch Failed: ${response.data}");
        setState(() => isLoading = false);
      }
    } on DioException catch (e) {
      print('Error Response: ${e.response?.data ?? e.message}');
      setState(() => isLoading = false);
    } catch (e) {
      print('Unexpected Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redeem Gifts"),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : gifts.isEmpty
              ? const Center(
                  child: Text(
                    "No gifts available right now.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                    itemCount: gifts.length,
                    itemBuilder: (context, index) {
                      final gift = gifts[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  '$baseUrl${gift['Image'] ?? ''}',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.card_giftcard, size: 60, color: Colors.deepPurple),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gift['Giftname'] ?? 'Unknown Gift',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      gift['Description'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      'Points: ${gift['Points'].toString()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          _showRedeemDialog(context, gift['title'] ?? 'Gift');
                                        },
                                        icon: const Icon(Icons.card_giftcard),
                                        label: const Text("Redeem"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _showRedeemDialog(BuildContext context, String giftName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Confirm Redemption"),
        content: Text("Do you want to redeem \"$giftName\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("You have redeemed \"$giftName\" successfully!"),
                  backgroundColor: Colors.deepPurple,
                ),
              );
            },
            child: const Text("Redeem"),
          ),
        ],
      ),
    );
  }
}
