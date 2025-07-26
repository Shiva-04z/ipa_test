import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/globals.dart' as glb;
import '../../models/apmc_model.dart';

class ApmcSelectionFormController extends GetxController {
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final searchResults = <Apmc>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchResults.value = glb.availableApmcs;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      searchResults.value = glb.availableApmcs;
    } else {
      searchResults.value = glb.availableApmcs.where((apmc) {
        final name = apmc.name?.toLowerCase() ?? '';
        final address = apmc.address?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return name.contains(searchLower) || address.contains(searchLower);
      }).toList();
    }
  }

  void selectApmc(Apmc apmc) {
    Get.back(result: apmc);
  }
}

class ApmcSelectionFormPage extends StatelessWidget {
  ApmcSelectionFormPage({super.key});

  final controller = Get.put(ApmcSelectionFormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select APMC Office'),
        backgroundColor: const Color(0xff548235),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xff548235).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search APMC offices...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: controller.onSearchChanged,
                ),
              ),
              Expanded(
                child: Obx(() => controller.searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'No APMC offices found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.searchResults.length,
                        itemBuilder: (context, index) {
                          final apmc = controller.searchResults[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () => controller.selectApmc(apmc),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.account_balance,
                                          color: Color(0xff548235),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                apmc.name ?? 'N/A',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Signatory : ${apmc.nameOfAuthorizedSignatory ?? 'N/A'}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildInfoRow(
                                      Icons.location_on,
                                      'Address: ${apmc.address ?? 'N/A'}',
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      Icons.phone,
                                      'Contact: ${apmc.officePhoneNo ?? 'N/A'}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}
