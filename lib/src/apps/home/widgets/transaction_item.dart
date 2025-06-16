import 'package:flutter/material.dart';
import 'package:mukai/brick/models/transaction.model.dart';
import 'package:mukai/theme/theme.dart';
import 'package:mukai/widget/render_supabase_image.dart';

class TransactionItem extends StatefulWidget {
  Transaction transaction;
  TransactionItem({super.key, required this.transaction});

  @override
  State<TransactionItem> createState() => _MarketTraderState();
}

class _MarketTraderState extends State<TransactionItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSpace,
        productDetail(widget.transaction),
        heightSpace,
        maketAnalytics(widget.transaction),
        heightSpace,
        LinearProgressIndicator(
          value: 1,
          backgroundColor: primaryColor.withOpacity(0.2),
          color: redColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ],
    );
  }

  productDetail(Transaction transaction) {
    double height = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              transaction.sending_profile_avatar != null
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
              widthSpace,
              width5Space,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category!.toUpperCase(),
                      style: semibold12black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    height5Space,
                    Text(
                      '${transaction.amount}',
                      style: semibold16Primary,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  maketAnalytics(Transaction transaction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Status',
                style: semibold12black,
                overflow: TextOverflow.ellipsis,
              ),
              height5Space,
              Text(
                '${transaction.status}',
                style: semibold16Primary,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
        Expanded(
          child: Column(
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
        ),
        Expanded(
          child: Column(
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
        ),
      ],
    );
  }
}
