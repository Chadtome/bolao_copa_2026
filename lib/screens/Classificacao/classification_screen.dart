import 'package:bolao_copa_2026/data/group_phase_games.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  static const grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];

  Map<int, int> _rodadas = {for (int i = 0; i < 12; i++) i: 1};
  int _faseAtual = 0;

  void _rodadaAnterior(int grupoIndex) {
    if (_rodadas[grupoIndex]! > 1) {
      setState(() => _rodadas[grupoIndex] = _rodadas[grupoIndex]! - 1);
    }
  }

  void _proximaRodada(int grupoIndex) {
    if (_rodadas[grupoIndex]! < 3) {
      setState(() => _rodadas[grupoIndex] = _rodadas[grupoIndex]! + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: _faseAtual > 0 ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                onPressed: _faseAtual > 0 ? () => setState(() => _faseAtual--) : null,
              ),
              Expanded(
                child: Text(
                  _faseAtual == 0 ? 'FASE DE GRUPOS' : 'MELHORES TERCEIROS',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: _faseAtual < 1 ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
                onPressed: _faseAtual < 1 ? () => setState(() => _faseAtual++) : null,
              ),
            ],
          ),
        ),
        Expanded(
          child: _faseAtual == 0 ? _buildGroupPhase() :  _BestThirdsTable(),
        ),
      ],
    );
  }

  Widget _buildGroupPhase() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;

        if (isWide) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (int i = 0; i < 12; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildLeftCard(i)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          height: 287,
                          child: VerticalDivider(width: 1, color: Colors.grey.shade300),
                        ),
                      ),
                      Expanded(child: _buildRightCard(grupoIndex: i)),
                    ],
                  ),
                ),
            ],
          );
        }

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            for (int i = 0; i < 12; i++) ...[
              _buildLeftCard(i),
              const SizedBox(height: 12),
              _buildRightCard(grupoIndex: i, isMobile: true),
              const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLeftCard(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grupo ${grupos[i]}', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Row(
                  children: [
                    SizedBox(width: 24),
                    Expanded(flex: 3, child: Text('Classificação', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('J', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('V', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('E', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('D', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('GP', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('GC', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                    Expanded(flex: 1, child: Text('SG', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(child: _buildTeamList(i)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamList(int groupIndex) {
    final group = GroupPhaseGames.groups[groupIndex];
    final games = group['games'] as List;

    final teams = <String>[];
    for (var game in games) {
      if (!teams.contains(game['homeTeam'])) teams.add(game['homeTeam']);
      if (!teams.contains(game['awayTeam'])) teams.add(game['awayTeam']);
    }

    return Column(
      children: [
        for (int j = 0; j < teams.length; j++) ...[
          _TeamRow(pos: j + 1, name: teams[j]),
          if (j < teams.length - 1) Divider(height: 1, color: Theme.of(context).dividerColor),
        ],
      ],
    );
  }

  Widget _buildRightCard({bool isMobile = false, required int grupoIndex}) {
    final rodada = _rodadas[grupoIndex]!;
    final group = GroupPhaseGames.groups[grupoIndex];
    final games = group['games'] as List;
    final startIndex = (rodada - 1) * 2;

    return Column(
      children: [
        if (!isMobile) const SizedBox(height: 38),
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left, size: 28,
                          color: rodada > 1 ? Theme.of(context).colorScheme.primary : Colors.grey),
                      onPressed: () => _rodadaAnterior(grupoIndex),
                    ),
                    Expanded(
                      child: Text('${rodada}º RODADA', textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right, size: 28,
                          color: rodada < 3 ? Theme.of(context).colorScheme.primary : Colors.grey),
                      onPressed: () => _proximaRodada(grupoIndex),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: Column(
                  children: [
                    _JogoResultado(
                      home: games[startIndex]['homeTeam'], away: games[startIndex]['awayTeam'],
                      homeFlag: games[startIndex]['homeFlag'], awayFlag: games[startIndex]['awayFlag'],
                      date: games[startIndex]['date'], time: games[startIndex]['time'],
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    _JogoResultado(
                      home: games[startIndex + 1]['homeTeam'], away: games[startIndex + 1]['awayTeam'],
                      homeFlag: games[startIndex + 1]['homeFlag'], awayFlag: games[startIndex + 1]['awayFlag'],
                      date: games[startIndex + 1]['date'], time: games[startIndex + 1]['time'],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ========== MELHORES TERCEIROS ==========
class _BestThirdsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thirds = _getAllThirdTeams();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final col0Width = isWide ? 300.0 : 160.0;

        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: Colors.orange.shade700, size: isWide ? 28 : 22),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Melhores Terceiros Colocados',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isWide ? 24 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: isWide ? 800 : double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Classificam-se os 8 melhores para as Oitavas de Final',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          columnWidths: {
                            0: FixedColumnWidth(col0Width),
                            1: const FixedColumnWidth(60),
                            2: const FixedColumnWidth(50),
                            3: const FixedColumnWidth(50),
                            4: const FixedColumnWidth(50),
                            5: const FixedColumnWidth(50),
                            6: const FixedColumnWidth(60),
                            7: const FixedColumnWidth(60),
                            8: const FixedColumnWidth(60),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Theme.of(context).dividerColor.withOpacity(0.3)),
                              children: const [
                                _TblCell2('Classificação', bold: true),
                                _TblCell2('P', bold: true),
                                _TblCell2('J', bold: true),
                                _TblCell2('V', bold: true),
                                _TblCell2('E', bold: true),
                                _TblCell2('D', bold: true),
                                _TblCell2('GP', bold: true),
                                _TblCell2('GC', bold: true),
                                _TblCell2('SG', bold: true),
                              ],
                            ),
                            for (int i = 0; i < 12; i++)
                              TableRow(
                                decoration: i == 7
                                    ? BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green.shade700, width: 2)))
                                    : null,
                                children: [
                                  _TblCell2(
                                    '${i + 1}º  ${thirds[i]}',
                                    ellipsis: !isWide,
                                    align: TextAlign.start,
                                    padding: const EdgeInsets.only(left: 8),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: i < 8 ? FontWeight.bold : FontWeight.w400,
                                      color: i < 8 ? Colors.green.shade700 : Colors.grey,
                                    ),
                                  ),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                  const _TblCell2('0', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(width: 12, height: 12,
                              decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 6),
                          Text('Classificados (8 primeiros)',
                              style: GoogleFonts.inter(fontSize: 11, color: Colors.green.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static List<String> _getAllThirdTeams() {
    final thirds = <String>[];
    for (int i = 0; i < 12; i++) {
      final group = GroupPhaseGames.groups[i];
      final games = group['games'] as List;
      final teams = <String>[];
      for (var game in games) {
        if (!teams.contains(game['homeTeam'])) teams.add(game['homeTeam']);
        if (!teams.contains(game['awayTeam'])) teams.add(game['awayTeam']);
      }
      thirds.add(teams[2]);
    }
    return thirds;
  }
}

class _TeamRow extends StatelessWidget {
  final int pos;
  final String name;
  const _TeamRow({required this.pos, required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: pos == 1 ? Colors.green.shade700 : pos == 2 ? Colors.green.shade400 : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('$pos', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: pos <= 2 ? Colors.white : null)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: Text(name, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis)),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
            const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
          ],
        ),
      ),
    );
  }
}

class _JogoResultado extends StatelessWidget {
  final String home;
  final String away;
  final String homeFlag;
  final String awayFlag;
  final String date;
  final String time;
  const _JogoResultado({required this.home, required this.away, required this.homeFlag, required this.awayFlag, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 6), child: Text('$date - $time', style: const TextStyle(fontSize: 10, color: Colors.grey))),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: Text(home, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
                        const SizedBox(width: 6),
                        Text(homeFlag, style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const _PlacarField(),
                  const SizedBox(width: 6),
                  const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 6),
                  const _PlacarField(),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(awayFlag, style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 6),
                        Flexible(child: Text(away, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlacarField extends StatefulWidget {
  const _PlacarField();
  @override
  State<_PlacarField> createState() => _PlacarFieldState();
}

class _PlacarFieldState extends State<_PlacarField> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30, height: 28,
      child: TextField(
        controller: _controller, textAlign: TextAlign.center, keyboardType: TextInputType.number, maxLength: 2,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(counterText: '', isDense: true, contentPadding: EdgeInsets.zero, filled: true, fillColor: Colors.transparent, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
      ),
    );
  }
}

class _TblCell2 extends StatelessWidget {
  final String text;
  final bool bold;
  final TextStyle? style;
  final bool ellipsis;
  final TextAlign align;
  final EdgeInsetsGeometry padding;

  const _TblCell2(
    this.text, {
    this.bold = false,
    this.style,
    this.ellipsis = false,
    this.align = TextAlign.center,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: align,
        overflow: ellipsis ? TextOverflow.ellipsis : null,
        maxLines: 1,
        style: style ?? TextStyle(
          fontSize: 14,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
