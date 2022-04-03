import 'package:cached_network_image/cached_network_image.dart';
import 'package:fin_clever/fin_clever_icons_icons.dart';
import 'package:fin_clever/models/invest/stock.dart';
import 'package:fin_clever/utils/format.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StockItem extends StatelessWidget {
  const StockItem({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: FinDimen.horizontal,
        top: FinDimen.horizontal,
        right: FinDimen.horizontal,
        bottom: FinDimen.vertical,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: FinColor.iconBg,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                imageUrl:
                    "https://ui-avatars.com/api?name=${stock.ticker}+&color=03314B",
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        stock.companyName,
                        style: FinFont.medium.copyWith(fontSize: 14),
                      ),
                      Text(
                        " • ${stock.amount}",
                        style: FinFont.medium.copyWith(
                            fontSize: 12, color: FinColor.secondaryText),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        stock.purchasePrice.formatMoney(currency: "\$"),
                        style: FinFont.regular.copyWith(fontSize: 12),
                      ),
                      Text(
                        ' ➔ ',
                        style: FinFont.regular.copyWith(fontSize: 12),
                      ),
                      Text(
                        stock.currentPrice.formatMoney(currency: "\$"),
                        style: FinFont.regular.copyWith(fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                stock.totalCurrentPrice().formatMoney(currency: "\$"),
                style: FinFont.semibold.copyWith(
                  fontSize: 14,
                  color: stock.difference().priceColor(),
                ),
              ),
              Text(
                stock.difference().formatPercentDifference(),
                style: FinFont.regular.copyWith(
                  fontSize: 12,
                  color: stock.difference().priceColor(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
