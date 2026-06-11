/// RSVP motor çıktısı — packages/contracts/schemas/token.json ile uyumlu.
class TokenData {
  const TokenData({
    required this.token,
    required this.focusIndex,
    required this.paceMs,
    this.flags = const [],
  });

  final String token;
  final int focusIndex;
  final int paceMs;
  final List<String> flags;

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      token: json['token'] as String,
      focusIndex: json['focus_index'] as int,
      paceMs: json['pace_ms'] as int,
      flags: (json['flags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'focus_index': focusIndex,
        'pace_ms': paceMs,
        if (flags.isNotEmpty) 'flags': flags,
      };
}
