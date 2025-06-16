import 'package:auto_size_text/auto_size_text.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
import 'package:mukai/widget/render_supabase_image.dart';
import 'package:flutter/material.dart';

class TradeIconTitleHeaderWidget extends StatelessWidget {
  String? title, bucket_id, logo_id, category;
  TradeIconTitleHeaderWidget(
      {super.key, this.title, this.bucket_id, this.logo_id, this.category});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Row(
      children: [
        logo_id != null
            ? SizedBox(
                height: 50,
                width: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: Stack(
                    children: [
                      SizedBox.fromSize(
                        size: Size.fromHeight(height), // Image size
                        child: RenderSupabaseImageIdWidget(
                          filePath: logo_id!,
                        ),
                      ),
                    ],
                  ),
                ))
            : const Icon(
                Icons.image,
                size: 50.0,
                color: Colors.grey,
              ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              width20Space,
              SizedBox(
                width: 200,
                child: AutoSizeText(
                  textAlign: TextAlign.center,
                  maxFontSize: 15,
                  maxLines: 2,
                  Utils.trimp(title!),
                  style: const TextStyle(color: blackOrignalColor),
                ),
              ),
              SizedBox(
                width: 200,
                child: AutoSizeText(
                  textAlign: TextAlign.center,
                  maxFontSize: 15,
                  maxLines: 2,
                  Utils.trimp(category!),
                  style: const TextStyle(color: blackOrignalColor),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
