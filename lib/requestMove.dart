import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RequestMove {
  Future<http.Response> getMove(Map<int, Map<int, String>> grid) async {
    String state = '';
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        state += grid[i][j] == '0' ? '-' : (grid[i][j] == '1' ? 'X' : 'O');
      }
    }
    return http.get('https://stujo-tic-tac-toe-stujo-v1.p.rapidapi.com/$state/O',
        headers: <String, String>{
          "X-RapidAPI-Host": "stujo-tic-tac-toe-stujo-v1.p.rapidapi.com",
          "X-RapidAPI-Key": "8540c17c1bmsh717b79867fcb68bp197aedjsn1f9f3c08db95"
        });
  }

  int getRecommendation(http.Response response){
    return convert.jsonDecode(response.body)["recommendation"];
  }
}
