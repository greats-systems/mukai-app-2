import 'package:mukai/src/controllers/file_service_controller.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RenderSupabaseImageIdWidget extends StatelessWidget {
  final String filePath;
  RenderSupabaseImageIdWidget({super.key, required this.filePath});
  final FileServiceController fileServiceController =
      Get.put(FileServiceController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ClipRRect(
      child: Stack(
        children: [
          Obx(() => SizedBox.fromSize(
                size: Size.fromHeight(height),
                child: Image.network(
                  '${fileServiceController.supabase_url}/storage/v1/object/public/${filePath}',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                        width: width * 0.8,
                        child:
                            const LoadingShimmerWidget()); // Your custom shimmer widget
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300], // Fallback color
                      child: const SizedBox(
                          height: 2,
                          child: Icon(
                            size: 37,
                            Icons.person_2_outlined,
                            color: whiteColor,
                          )),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }
}
