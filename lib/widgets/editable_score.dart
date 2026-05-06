import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditableScore extends StatefulWidget {
  final int? homeBet;
  final int? awayBet;
  final Function(int home, int away)? onChanged;

  const EditableScore({
    super.key,
    this.homeBet,
    this.awayBet,
    this.onChanged,
  });

  @override
  State<EditableScore> createState() => _EditableScoreState();
}

class _EditableScoreState extends State<EditableScore> {
  late TextEditingController _homeController;
  late TextEditingController _awayController;

  @override
  void initState() {
    super.initState();
    _homeController = TextEditingController(
      text: widget.homeBet?.toString() ?? '',
    );
    _awayController = TextEditingController(
      text: widget.awayBet?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _homeController.dispose();
    _awayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: TextField(
              controller: _homeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.all(2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onChanged: (_) => _notifyChange(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'x',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          SizedBox(
            width: 28,
            height: 28,
            child: TextField(
              controller: _awayController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.all(2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onChanged: (_) => _notifyChange(),
            ),
          ),
        ],
      ),
    );
  }

  void _notifyChange() {
    int? home = int.tryParse(_homeController.text);
    int? away = int.tryParse(_awayController.text);
    if (home != null && away != null && widget.onChanged != null) {
      widget.onChanged!(home, away);
    }
  }
}