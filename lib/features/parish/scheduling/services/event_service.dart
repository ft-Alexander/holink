import 'dart:convert';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/scheduling/model/regularEvent.dart';
import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';
import 'package:http/http.dart' as http;

class EventService {
  final localhost localhostInstance = localhost();

  Future<int?> saveRegularEvent(RegularEvent event) async {
    final url = Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/saveRegularEvent.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['id'] is int) {
        return responseBody['id'];
      } else if (responseBody['id'] is String) {
        return int.tryParse(responseBody['id']);
      }
    }
    return null;
  }

  Future<bool> saveRegularEventDate(RegularEventDate eventDate) async {
    final url = Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/saveRegularEventDate.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(eventDate.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['message'] == "Event date saved successfully";
    }
    return false;
  }

  // Future<List<RegularEvent>> fetchRegularEvents() async {
  //   final response = await http.get(Uri.parse(
  //       'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getRegularEvents.php'));

  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     if (jsonResponse['success']) {
  //       List<dynamic> eventsJson = jsonResponse['events'];
  //       return eventsJson.map((json) => RegularEvent.fromJson(json)).toList();
  //     } else {
  //       throw Exception('Failed to load events');
  //     }
  //   } else {
  //     throw Exception('Failed to load events');
  //   }
  // }
}
