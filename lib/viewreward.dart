import 'package:bottlebucks/services/loginapi.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ViewReward extends StatefulWidget {
  const ViewReward({super.key});

  @override
  State<ViewReward> createState() => _ViewRewardState();
}

class _ViewRewardState extends State<ViewReward> {
  List<Map<String, dynamic>> rewards = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRewards();
  }

  Future<void> fetchRewards() async {
  setState(() => isLoading = true);
  final dio = Dio();

  try {
    final response = await dio.get('$baseUrl/api/viewreward/$loginId');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = response.data;
      print(response.data);
      rewards = data.map((item) {
        return {
          "giftName": item['product_name'] ?? "Unknown Gift",
          "pointsSpent": item['totalRewardSpend'] ?? 0, 
          "date": item['date'] ?? "",
          "image": item['product_image'] != null
              ? '$baseUrl${item['product_image']}'
              : "https://via.placeholder.com/100"
        };
      }).toList();
    } else {
      rewards = [];
    }
  } catch (e) {
    print("Error fetching rewards: $e");
    rewards = [];
  }

  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Rewards"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : rewards.isEmpty
              ? const Center(
                  child: Text(
                    "No rewards redeemed yet!",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: rewards.length,
                  itemBuilder: (context, index) {
                    final reward = rewards[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                            child: Image.network(
                              reward["image"],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reward["giftName"],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Points Spent: ${reward["pointsSpent"]}",
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Redeemed on: ${reward["date"]}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
