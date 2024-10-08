import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Database Operations/FarmerFinder.dart';

class FarmersList extends StatefulWidget {
  const FarmersList({super.key});

  @override
  State<FarmersList> createState() => _FarmersListState();
}

class _FarmersListState extends State<FarmersList>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> farmers;
  Map<String, dynamic>? selectedFarmer;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    farmers = getFarmer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> deleteFarmer(String farmerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Farmers')
          .doc(farmerId)
          .delete();
      setState(() {
        farmers = getFarmer();
      });
    } catch (e) {
      print('Error deleting farmer: $e');
    }
  }

  void _showFarmerDetails(Map<String, dynamic> farmer) {
    setState(() {
      selectedFarmer = farmer;
    });
    _animationController.forward();
  }

  void _closeFarmerDetails() {
    _animationController.reverse().then((_) {
      setState(() {
        selectedFarmer = null;
      });
    });
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Farmers List',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: farmers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitWaveSpinner(color: Colors.green),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Farmers Found",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                );
              } else {
                List<Map<String, dynamic>> users = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 12.0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    String farmerId = user['id'] ?? "id";

                    return GestureDetector(
                      onTap: () => _showFarmerDetails(user),
                      child: Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green.shade100,
                                radius: 30,
                                child: Text(
                                  '${user['firstName']?[0] ?? 'F'}${user['lastName']?[0] ?? 'L'}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user['firstName'] ?? 'First Name'} ${user['lastName'] ?? 'Last Name'}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.location_city,
                                            color: Colors.grey.shade700,
                                            size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                          user['city'] ?? 'Unknown',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: Colors.grey.shade700,
                                            size: 18),
                                        const SizedBox(width: 6),
                                        Text(
                                          user['phoneNumber'] ?? 'N/A',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outline,
                                    color: Colors.red.shade400),
                                onPressed: () async {
                                  bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                            'Are you sure you want to delete this farmer?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  if (confirmDelete) {
                                    await deleteFarmer(farmerId);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
          if (selectedFarmer != null)
            GestureDetector(
              onTap: _closeFarmerDetails,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animationController.value,
                    child: Container(
                      color: Colors.black54,
                    ),
                  );
                },
              ),
            ),
          if (selectedFarmer != null)
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.all(24.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${selectedFarmer!['firstName'] ?? 'First Name'} ${selectedFarmer!['lastName'] ?? 'Last Name'}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: _closeFarmerDetails,
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.green.shade200,
                            thickness: 1,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.email_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedFarmer!['email'] ??
                                      'Email not available',
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black87),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.location_city_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                selectedFarmer!['city'] ??
                                    'City not available',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                selectedFarmer!['phoneNumber'] ??
                                    'Phone number not available',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.article_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                  selectedFarmer!['aadharUrl'] != null
                                      ? () => _launchUrl(
                                      selectedFarmer!['aadharUrl'])
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('View Aadhar'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.article_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed:
                                  selectedFarmer!['landCertificateUrl'] !=
                                      null
                                      ? () => _launchUrl(
                                      selectedFarmer![
                                      'landCertificateUrl'])
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('View Land Certificate'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.article_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: selectedFarmer!['panUrl'] != null
                                      ? () => _launchUrl(
                                      selectedFarmer!['panUrl'])
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('View PAN'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.landscape_outlined,
                                  color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Text(
                                '${selectedFarmer!['farm'] ?? 'Land details not available'}',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
