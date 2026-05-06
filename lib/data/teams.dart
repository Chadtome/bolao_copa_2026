class Team {
  final String name;
  final String flag;

  const Team({
    required this.name,
    required this.flag,
  });
}

class Teams {
  static const Map<String, Team> all = {
    // Grupo A
    'México': Team(name: 'México', flag: '🇲🇽'),
    'Coreia do Sul': Team(name: 'Coreia do Sul', flag: '🇰🇷'),
    'África do Sul': Team(name: 'África do Sul', flag: '🇿🇦'),
    'República Tcheca': Team(name: 'República Tcheca', flag: '🇨🇿'),
    // Grupo B
    'Canadá': Team(name: 'Canadá', flag: '🇨🇦'),
    'Suíça': Team(name: 'Suíça', flag: '🇨🇭'),
    'Catar': Team(name: 'Catar', flag: '🇶🇦'),
    'Bósnia': Team(name: 'Bósnia', flag: '🇧🇦'),
    // Grupo C
    'Brasil': Team(name: 'Brasil', flag: '🇧🇷'),
    'Marrocos': Team(name: 'Marrocos', flag: '🇲🇦'),
    'Escócia': Team(name: 'Escócia', flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿'),
    'Haiti': Team(name: 'Haiti', flag: '🇭🇹'),
    // Grupo D
    'Estados Unidos': Team(name: 'Estados Unidos', flag: '🇺🇸'),
    'Austrália': Team(name: 'Austrália', flag: '🇦🇺'),
    'Paraguai': Team(name: 'Paraguai', flag: '🇵🇾'),
    'Turquia': Team(name: 'Turquia', flag: '🇹🇷'),
    // Grupo E
    'Alemanha': Team(name: 'Alemanha', flag: '🇩🇪'),
    'Equador': Team(name: 'Equador', flag: '🇪🇨'),
    'Costa do Marfim': Team(name: 'Costa do Marfim', flag: '🇨🇮'),
    'Curaçao': Team(name: 'Curaçao', flag: '🇨🇼'),
    // Grupo F
    'Holanda': Team(name: 'Holanda', flag: '🇳🇱'),
    'Japão': Team(name: 'Japão', flag: '🇯🇵'),
    'Tunísia': Team(name: 'Tunísia', flag: '🇹🇳'),
    'Suécia': Team(name: 'Suécia', flag: '🇸🇪'),
    // Grupo G
    'Bélgica': Team(name: 'Bélgica', flag: '🇧🇪'),
    'Irã': Team(name: 'Irã', flag: '🇮🇷'),
    'Egito': Team(name: 'Egito', flag: '🇪🇬'),
    'Nova Zelândia': Team(name: 'Nova Zelândia', flag: '🇳🇿'),
    // Grupo H
    'Espanha': Team(name: 'Espanha', flag: '🇪🇸'),
    'Uruguai': Team(name: 'Uruguai', flag: '🇺🇾'),
    'Arábia Saudita': Team(name: 'Arábia Saudita', flag: '🇸🇦'),
    'Cabo Verde': Team(name: 'Cabo Verde', flag: '🇨🇻'),
    // Grupo I
    'França': Team(name: 'França', flag: '🇫🇷'),
    'Senegal': Team(name: 'Senegal', flag: '🇸🇳'),
    'Noruega': Team(name: 'Noruega', flag: '🇳🇴'),
    'Iraque': Team(name: 'Iraque', flag: '🇮🇶'),
    // Grupo J
    'Argentina': Team(name: 'Argentina', flag: '🇦🇷'),
    'Áustria': Team(name: 'Áustria', flag: '🇦🇹'),
    'Argélia': Team(name: 'Argélia', flag: '🇩🇿'),
    'Jordânia': Team(name: 'Jordânia', flag: '🇯🇴'),
    // Grupo K
    'Portugal': Team(name: 'Portugal', flag: '🇵🇹'),
    'Colômbia': Team(name: 'Colômbia', flag: '🇨🇴'),
    'Uzbequistão': Team(name: 'Uzbequistão', flag: '🇺🇿'),
    'RD Congo': Team(name: 'RD Congo', flag: '🇨🇩'),
    // Grupo L
    'Inglaterra': Team(name: 'Inglaterra', flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
    'Croácia': Team(name: 'Croácia', flag: '🇭🇷'),
    'Panamá': Team(name: 'Panamá', flag: '🇵🇦'),
    'Gana': Team(name: 'Gana', flag: '🇬🇭'),
  };

  static Team get(String name) {
    return all[name] ?? Team(name: name, flag: '⚽');
  }
}
