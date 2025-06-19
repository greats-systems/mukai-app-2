import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/utils/utils.dart';
// import 'package:mukai/widget/render_supabase_image.dart';

class AdminTransactionItem extends StatefulWidget {
  Transaction transaction;
  AdminTransactionItem({super.key, required this.transaction});

  @override
  State<AdminTransactionItem> createState() => _MarketTraderState();
}

class _MarketTraderState extends State<AdminTransactionItem> {
  @override
  Widget build(BuildContext context) {
    return productDetail(widget.transaction);
  }

  productDetail(Transaction transaction) {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        maxWidth: double.infinity,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /*
                transaction.sending_profile_avatar != null
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              SizedBox.fromSize(
                                size: Size.fromHeight(height),
                                child: RenderSupabaseImageIdWidget(
                                  filePath: transaction.sending_profile_avatar!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.image,
                        size: 50.0,
                        color: Colors.grey,
                      ),
                    */
                  widthSpace,
                  width5Space,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Innocent Greats',
                        style: semibold12black,
                        overflow: TextOverflow.ellipsis,
                      ),
                      height5Space,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                Utils.formatDateTime(DateTime.parse(
                                    transaction.createdAt ??
                                        DateTime.now().toString())),
                                style: semibold12black,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                Utils.formatTime(DateTime.parse(
                                    transaction.createdAt ??
                                        DateTime.now().toString())),
                                style: semibold12black,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${transaction.category ?? 'No category'}- ${transaction.status ?? 'initiated'}',
                    style: semibold12black,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                    style: semibold16Primary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            ],
          ),
          // Add other content here if needed
        ],
      ),
    );
  }

  maketAnalytics(Transaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Transfer Mode',
              style: semibold12black,
              overflow: TextOverflow.ellipsis,
            ),
            height5Space,
            Text(
              '${transaction.transferMode}',
              style: semibold16Primary,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Purpose',
              style: semibold12black,
              overflow: TextOverflow.ellipsis,
            ),
            height5Space,
            Text(
              '${transaction.purpose}',
              style: semibold16Primary,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ],
    );
  }
}
