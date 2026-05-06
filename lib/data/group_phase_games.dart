import 'package:bolao_copa_2026/data/teams.dart';

class GroupPhaseGames {
  static final List<Map<String, dynamic>> groups = [
    // ------------------ Grupo A ---------------------
    {
      'name': 'A',
      'games': [
        _game('México', 'África do Sul', '11/06', '16:00'),
        _game('Coreia do Sul', 'República Tcheca', '11/06', '23:00'),
        _game('República Tcheca', 'África do Sul', '18/06', '13:00'),
        _game('México', 'Coreia do Sul', '18/06', '22:00'),
        _game('África do Sul', 'Coreia do Sul', '24/06', '22:00'),
        _game('República Tcheca', 'México', '24/06', '22:00'),
      ]
    },

    // ------------------ Grupo B ---------------------
    {
    'name': 'B',
    'games': [
      _game('Canadá', 'Bósnia', '12/06', '16:00'),
      _game('Catar', 'Suíça', '13/06', '16:00'),
      _game('Suíça', 'Bósnia', '18/06', '16:00'),
      _game('Canadá', 'Catar', '18/06', '19:00'),
      _game('Suíça', 'Canadá', '24/06', '16:00'),
      _game('Bósnia', 'Catar', '24/06', '16:00'),
    ]
    },

    // ------------------ Grupo C ---------------------
    {
      'name': 'C',
      'games': [
        _game('Brasil', 'Marrocos', '13/06', '19:00'),
        _game('Haiti', 'Escócia', '13/06', '22:00'),
        _game('Escócia', 'Marrocos', '19/06', '19:00'),
        _game('Brasil', 'Haiti', '19/06', '21:30'),
        _game('Marrocos', 'Haiti', '24/06', '19:00'),
        _game('Escócia', 'Brasil', '24/06', '19:00')
      ]
    },

    // ------------------ Grupo D ---------------------
    {
      'name': 'D',
      'games': [
        _game('Estados Unidos', 'Paraguai', '12/06', '22:00'),
        _game('Austrália', 'Turquia', '14/06', '01:00'),
        _game('Estados Unidos', 'Austrália', '19/06', '16:00'),
        _game('Turquia', 'Paraguai', '20/06', '01:00'),
        _game('Turquia', 'Estados Unidos', '25/06', '23:00'),
        _game('Paraguai', 'Austrália', '25/06', '23:00'),
      ]
    },

    // ------------------ Grupo E ---------------------
    {
      'name': 'E',
      'games': [
        _game('Alemanha', 'Curaçao', '14/06', '14:00'),
        _game('Costa do Marfim', 'Equador', '14/06', '20:00'),
        _game('Alemanha', 'Costa do Marfim', '20/06', '17:00'),
        _game('Equador', 'Curaçao', '20/06', '21:00'),
        _game('Equador', 'Alemanha', '25/06', '17:00'),
        _game('Curaçao', 'Costa do Marfim', '25/06', '17:00')
      ]
    },

    // ------------------ Grupo F ---------------------
    {
      'name': 'F',
      'games': [
        _game('Holanda', 'Japão', '14/06', '17:00'),
        _game('Suécia', 'Tunísia', '14/06', '23:00'),
        _game('Holanda', 'Suécia', '20/06', '14:00'),
        _game('Tunísia', 'Japão', '21/06', '01:00'),
        _game('Tunísia', 'Holanda', '25/06', '20:00'),
        _game('Japão', 'Suécia', '25/06', '20:00'),        
      ]
    },

    // ------------------ Grupo G ---------------------
    {
      'name': 'G',
      'games': [
        _game('Bélgica', 'Egito', '15/06', '16:00'),
        _game('Irã', 'Nova Zelândia', '15/06', '22:00'),
        _game('Bélgica', 'Irã', '21/06', '16:00'),
        _game('Nova Zelândia', 'Egito', '21/06', '22:00'),
        _game('Egito', 'Irã', '27/06', '00:00'),
        _game('Nova Zelândia', 'Bélgica', '27/06', '00:00'),
      ]
    },

    // ------------------ Grupo H ---------------------
    {
      'name': 'H',
      'games': [
        _game('Espanha', 'Cabo Verde', '15/06', '13:00'),
        _game('Arábia Saudita', 'Uruguai', '15/06', '19:00'),
        _game('Espanha', 'Arábia Saudita', '21/06', '13:00'),
        _game('Uruguai', 'Cabo Verde', '21/06', '19:00'),
        _game('Cabo Verde', 'Arábia Saudita', '26/06', '21:00'),
        _game('Uruguai', 'Espanha', '26/06', '21:00')
      ]
    },

    // ------------------ Grupo I ---------------------
    {
      'name': 'I',
      'games': [
        _game('França', 'Senegal', '16/06', '16:00'),
        _game('Iraque', 'Noruega', '16/06', '19:00'),
        _game('França', 'Iraque', '22/06', '18:00'),
        _game('Noruega', 'Senegal', '22/06', '21:00'),
        _game('Senegal', 'Iraque', '26/06', '16:00'),
        _game('Noruega', 'França', '26/06', '16:00'),
      ]
    },

    // ------------------ Grupo J ---------------------
    {
      'name': 'J',
      'games': [
        _game('Argentina', 'Argélia', '16/06', '22:00'),
        _game('Áustria', 'Jordânia', '17/06', '01:00'),
        _game('Argentina', 'Áustria', '22/06', '14:00'),
        _game('Jordânia', 'Argélia', '23/06', '00:00'),
        _game('Jordânia', 'Argentina', '27/06', '23:00'),
        _game('Argélia', 'Áustria', '27/06', '23:00'),
      ]
    },

    // ------------------ Grupo K ---------------------
    {
      'name': 'K',
      'games': [
        _game('Portugal', 'RD Congo', '17/06', '14:00'),
        _game('Uzbequistão', 'Colômbia', '17/06', '23:00'),
        _game('Portugal', 'Uzbequistão', '23/06', '14:00'),
        _game('Colômbia', 'RD Congo', '23/06', '23:00'),
        _game('RD Congo', 'Uzbequistão', '27/06', '20:30'),
        _game('Colômbia', 'Portugal', '27/06', '20:30'),
      ]
    },

    // ------------------ Grupo L ---------------------
    {
      'name': 'L',
      'games': [
        _game('Inglaterra', 'Croácia', '17/06', '17:00'),
        _game('Gana', 'Panamá', '17/06', '20:00'),
        _game('Inglaterra', 'Gana', '23/06', '17:00'),
        _game('Panamá', 'Croácia', '23/06', '20:00'),
        _game('Croácia', 'Gana', '27/06', '18:00'),
        _game('Panamá', 'Inglaterra', '27/06', '18:00')
      ]
    },

  ];

  static Map<String, dynamic> _game(String home, String away, String date, String time) {
    return {
      'homeTeam': home,
      'awayTeam': away,
      'homeFlag': Teams.get(home).flag,
      'awayFlag': Teams.get(away).flag,
      'date': date,
      'time': time,
      'status': 'open',
      'homeBet': null,
      'awayBet': null,
      'homeScore': null,
      'awayScore': null,      
    };
  }
}