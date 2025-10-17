import 'package:bottlebucks/services/loginapi.dart';
import 'package:bottlebucks/services/profileapi.dart';
import 'package:bottlebucks/viewreward.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class RedeemGift extends StatefulWidget {
  const RedeemGift({super.key});

  @override
  State<RedeemGift> createState() => _RedeemGiftState();
}

class _RedeemGiftState extends State<RedeemGift> {
  List<dynamic> gifts = [];
  bool isLoading = true;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchGifts();
  }

  // ✅ Fetch all gifts
  Future<void> fetchGifts() async {
    try {
      final response = await dio.get('$baseUrl/api/gifts/');
      if (response.statusCode == 200) {
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

  // ✅ Redeem Gift API call
  Future<bool> redeemGift(int giftId, String giftName) async {
    try {
      final response = await dio.post('$baseUrl/api/redeem/$loginId/$giftId/');

      if (response.statusCode == 200) {
        final data = response.data;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🎁 ${data['message']}"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewReward()));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ ${response.data['message'] ?? 'Failed to redeem.'}"),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    } on DioException catch (e) {
      String errorMsg = e.response?.data['message'] ?? 'An error occurred.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ $errorMsg"),
          backgroundColor: Colors.red,
        ),
      );
    }
    return false;
  }

  // ✅ Confirmation dialog
  void _showRedeemDialog(BuildContext context, int giftId, String giftName) {
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
            onPressed: () async {
              Navigator.pop(ctx);
              await redeemGift(giftId, giftName);
              Navigator.pop(ctx, true);
              
              
            },
            child: const Text("Redeem"),
          ),
        ],
      ),
    );
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
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
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
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.card_giftcard, size: 60, color: Colors.deepPurple),
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
                                          _showRedeemDialog(
                                              context,
                                              gift['id'],
                                              gift['Giftname'] ?? 'Gift');
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
}
