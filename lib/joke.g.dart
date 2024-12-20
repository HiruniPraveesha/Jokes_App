part of 'joke.dart';

Joke _$JokeFromJson(Map<String, dynamic> json) => Joke(
      setup: json['setup'] as String,
      punchline: json['punchline'] as String,
    );

Map<String, dynamic> _$JokeToJson(Joke instance) => <String, dynamic>{
      'setup': instance.setup,
      'punchline': instance.punchline,
    };
