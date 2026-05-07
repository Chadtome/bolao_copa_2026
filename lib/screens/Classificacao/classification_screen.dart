// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ClassificationScreen extends StatefulWidget {
//   const ClassificationScreen({super.key});

//   @override
//   State<ClassificationScreen> createState() => _ClassificationScreenState();
// }

// class _ClassificationScreenState extends State<ClassificationScreen> {
//   static const grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
//   int _rodada = 1;

//   void _rodadaAnterior() {
//     if (_rodada > 1) setState(() => _rodada--);
//   }

//   void _proximaRodada() {
//     if (_rodada < 3) setState(() => _rodada++);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Título
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.chevron_left),
//                 onPressed: () {},
//               ),
//               const SizedBox(width: 300),
//               Text(
//                 'FASE DE GRUPOS',
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               const SizedBox(width: 300),
//               IconButton(
//                 icon: const Icon(Icons.chevron_right),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),

//         // Conteúdo
//         Expanded(
//           child: ListView(
//             padding: const EdgeInsets.all(12),
//             children: [
//               for (int i = 0; i < 12; i++)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 12),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Esquerda
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Grupo ${grupos[i]}',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Container(
//                               height: 250,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 40,
//                                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                                     child: const Row(
//                                       children: [
//                                         SizedBox(width: 24),
//                                         Expanded(flex: 3, child: Text('Classificação', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('P', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('J', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('V', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('E', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('D', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('GP', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('GC', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                         Expanded(flex: 1, child: Text('SG', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
//                                       ],
//                                     ),
//                                   ),
//                                   Divider(height: 1, color: Theme.of(context).dividerColor),
//                                   Expanded(
//                                     child: Column(
//                                       children: [
//                                         _TeamRow(pos: 1, name: 'México'),
//                                         Divider(height: 1, color: Theme.of(context).dividerColor),
//                                         _TeamRow(pos: 2, name: 'Coreia do Sul'),
//                                         Divider(height: 1, color: Theme.of(context).dividerColor),
//                                         _TeamRow(pos: 3, name: 'África do Sul'),
//                                         Divider(height: 1, color: Theme.of(context).dividerColor),
//                                         _TeamRow(pos: 4, name: 'República Tcheca'),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       // Divider
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                         child: SizedBox(
//                           height: 287,
//                           child: VerticalDivider(
//                             width: 1,
//                             color: Colors.grey.shade300,
//                           ),
//                         ),
//                       ),
//                       // Direita
//                       Expanded(
//                         child: Column(
//                           children: [
//                             const SizedBox(height: 38),
//                             Container(
//                               height: 250,
//                               decoration: BoxDecoration(
//                                 color: Theme.of(context).colorScheme.surfaceContainerHighest,
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   // Navegação de rodada
//                                   Container(
//                                     height: 40,
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(Icons.chevron_left, size: 28),
//                                           onPressed: _rodadaAnterior,
//                                         ),
//                                         const SizedBox(width: 200),
//                                         Text(
//                                           '${_rodada}º RODADA',
//                                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                                         ),
//                                         const SizedBox(width: 200),
//                                         IconButton(
//                                           icon: const Icon(Icons.chevron_right, size: 28),
//                                           onPressed: _proximaRodada,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Divider(height: 1, color: Theme.of(context).dividerColor),
//                                   // Jogos
//                                   Expanded(
//                                     child: Column(
//                                       children: [
//                                         const _JogoResultado(
//                                           home: 'México',
//                                           away: 'África do Sul',
//                                           homeFlag: '🇲🇽',
//                                           awayFlag: '🇿🇦',
//                                         ),
//                                         Divider(height: 1, color: Theme.of(context).dividerColor),
//                                         const _JogoResultado(
//                                           home: 'Coreia do Sul',
//                                           away: 'República Tcheca',
//                                           homeFlag: '🇰🇷',
//                                           awayFlag: '🇨🇿',
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TeamRow extends StatelessWidget {
//   final int pos;
//   final String name;
//   const _TeamRow({required this.pos, required this.name});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         child: Row(
//           children: [
//             SizedBox(width: 24, child: Text('$pos', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
//             const SizedBox(width: 8),
//             Expanded(flex: 3, child: Text(name, style: const TextStyle(fontSize: 18), overflow: TextOverflow.ellipsis)),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//             const Expanded(flex: 1, child: Text('0', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _JogoResultado extends StatelessWidget {
//   final String home;
//   final String away;
//   final String homeFlag;
//   final String awayFlag;

//   const _JogoResultado({
//     required this.home,
//     required this.away,
//     required this.homeFlag,
//     required this.awayFlag,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Flexible(child: Text(home, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
//                   const SizedBox(width: 6),
//                   Text(homeFlag, style: const TextStyle(fontSize: 20)),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Text('   ', style: TextStyle(fontSize: 20, letterSpacing: 2)),
//             const SizedBox(width: 8),
//             const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
//             const SizedBox(width: 8),
//             const Text('   ', style: TextStyle(fontSize: 20, letterSpacing: 2)),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(awayFlag, style: const TextStyle(fontSize: 20)),
//                   const SizedBox(width: 6),
//                   Flexible(child: Text(away, style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  static const grupos = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'];
  int _rodada = 1;

  void _rodadaAnterior() {
    if (_rodada > 1) setState(() => _rodada--);
  }

  void _proximaRodada() {
    if (_rodada < 3) setState(() => _rodada++);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Título
        Padding(
  padding: const EdgeInsets.symmetric(vertical: 12),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
      Expanded(
        child: Text(
          'FASE DE GRUPOS',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
    ],
  ),
),
        // Conteúdo
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              if (isWide) {
                // ========== DESKTOP ==========
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
                            Expanded(child: _buildRightCard()),
                          ],
                        ),
                      ),
                  ],
                );
              }

              // ========== MOBILE ==========
              return ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  for (int i = 0; i < 12; i++) ...[
                    _buildLeftCard(i),
                    const SizedBox(height: 12),
                    _buildRightCard(isMobile: true),
                    const SizedBox(height: 24),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // ========== CARD ESQUERDA (CLASSIFICAÇÃO) ==========
  Widget _buildLeftCard(int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grupo ${grupos[i]}',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600),
        ),
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
              Expanded(
                child: Column(
                  children: [
                    _TeamRow(pos: 1, name: 'México'),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    _TeamRow(pos: 2, name: 'Coreia do Sul'),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    _TeamRow(pos: 3, name: 'África do Sul'),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    _TeamRow(pos: 4, name: 'República Tcheca'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ========== CARD DIREITA (JOGOS) ==========
  Widget _buildRightCard({bool isMobile = false}) {
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
                    IconButton(icon: const Icon(Icons.chevron_left, size: 28), onPressed: _rodadaAnterior),
                    Expanded(
                      child: Text(
                        '${_rodada}º RODADA',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.chevron_right, size: 28), onPressed: _proximaRodada),
                  ],
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              Expanded(
                child: Column(
                  children: [
                    const _JogoResultado(home: 'México', away: 'África do Sul', homeFlag: '🇲🇽', awayFlag: '🇿🇦'),
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                    const _JogoResultado(home: 'Coreia do Sul', away: 'República Tcheca', homeFlag: '🇰🇷', awayFlag: '🇨🇿'),
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
            SizedBox(width: 24, child: Text('$pos', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18))),
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

  const _JogoResultado({
    required this.home,
    required this.away,
    required this.homeFlag,
    required this.awayFlag,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            const SizedBox(width: 12),
            const Text('   ', style: TextStyle(fontSize: 20, letterSpacing: 2)),
            const SizedBox(width: 8),
            const Text('x', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Text('   ', style: TextStyle(fontSize: 20, letterSpacing: 2)),
            const SizedBox(width: 12),
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
    );
  }
}