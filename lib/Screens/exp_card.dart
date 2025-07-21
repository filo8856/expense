import 'package:expense1/Screens/auth.dart';
import 'package:expense1/Screens/global.dart';
import 'package:flutter/material.dart';
import 'card_class.dart';
import 'package:intl/intl.dart';
import 'package:expense1/Screens/expenselist.dart';

class ExpCard extends StatefulWidget {
  final Exp info;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  ExpCard({
    super.key,
    required this.info,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<ExpCard> createState() => _ExpCardState();
}

class _ExpCardState extends State<ExpCard> {
  bool expand=false;
  Icon _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icon(Icons.restaurant, size: 50);
      case 'transport':
        return Icon(Icons.directions_car, size: 50);
      case 'shopping':
        return Icon(Icons.shopping_bag, size: 50);
      case 'entertainment':
        return Icon(Icons.movie, size: 50);
      case 'bills':
        return Icon(Icons.receipt, size: 50);
      default:
        return Icon(Icons.question_mark, size: 50);
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> setState(() {
        expand=!expand;
      }),
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _getCategoryIcon(widget.info.cat ?? ''),
                      Text(
                        widget.info.cat ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          // color:Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(width: 20),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '₹${widget.info.amount.toString()}',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.info.desc ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            // color: Colors.black,
                          ),
                          maxLines: expand ? null : 1,
                          overflow: expand
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        DateFormat('d MMM yy').format(widget.info.date),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.black,
                            iconSize: 30,
                            onPressed: widget.onEdit,
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.black,
                            iconSize: 30,
                            onPressed: widget.onDelete,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
