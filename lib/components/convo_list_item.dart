import 'package:flutter/material.dart';
import 'package:porto_space/misc/misc_index.dart';

class ConvoListItem extends StatelessWidget {
  const ConvoListItem({
    super.key,
    required this.othersName,
    required this.othersId,
    required this.convoId,
    required this.itemCount,
    required this.itemName,
    required this.itemLastMessage,
    required this.timestamp,
  });

  final List<String?>? othersName;
  final List<String?>? othersId;
  final List<String?>? convoId;
  final int? itemCount;
  final String? itemName;
  final String? itemLastMessage;
  final List<Widget>? timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: Constants.borderSideSoft,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: itemCount,
                    shrinkWrap: false,
                    itemBuilder: (context, index) {
                      final len = itemCount!;
                      return index != len - 1
                      ? Text(
                        "${itemName![index]}, ",
                        style:
                          TextStyle(fontSize: Constants.textM),
                      )
                      : Text(
                        itemName![index],
                        style:
                          TextStyle(fontSize: Constants.textSL),
                      );
                    },
                  ),
                ),
                Text(
                  itemLastMessage!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Constants.textM,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: timestamp!,
            )
          )
        ],
      ),
    );
  }
}