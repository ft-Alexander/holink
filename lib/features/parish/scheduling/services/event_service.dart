import 'dart:convert';
import 'package:holink/dbConnection/localhost.dart';
import 'package:holink/features/parish/scheduling/model/lector.dart';
import 'package:holink/features/parish/scheduling/model/priest.dart';
import 'package:holink/features/parish/scheduling/model/regularEvent.dart';
import 'package:holink/features/parish/scheduling/model/regularEventDate.dart';
import 'package:holink/features/parish/scheduling/model/sacristan.dart';
import 'package:holink/features/parish/scheduling/model/get_all_event.dart';
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
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/saveRegularEvent.php');

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

  Future<List<FetchEvents>> fetchAllRegularEventDates() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getRegularEvents.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> eventsJson = jsonResponse['events'];
        return eventsJson.map((json) => FetchEvents.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<List<RegularEventDate>> fetchRegularEventDates() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getRegularEvents.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> eventsJson = jsonResponse['events'];
        return eventsJson
            .map((json) => RegularEventDate.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load events');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future<void> archiveRegularEvent(int eventId) async {
    final url =
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/archiveRegularEvent.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'eventId': eventId.toString()},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['message'] != null) {
          print(jsonResponse['message']); // Print success message
        } else if (jsonResponse['error'] != null) {
          print(jsonResponse['error']); // Print error message
        } else {
          print('Unexpected response format'); // Handle unexpected response
        }
      } else {
        print('Failed to archive regular event: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during archive request: $e'); // Handle exceptions
    }
  }

  Future<List<Priest>> fetchAllPriests() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getAllPriests.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> priestsJson = jsonResponse['priests'];
        return priestsJson.map((json) => Priest.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load priests');
      }
    } else {
      throw Exception('Failed to load priests');
    }
  }

  Future<List<Lector>> fetchAllLectors() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getAllLectors.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> lectorsJson = jsonResponse['lectors'];
        return lectorsJson.map((json) => Lector.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Lectors');
      }
    } else {
      throw Exception('Failed to load Lectors');
    }
  }

  Future<List<Sacristan>> fetchAllSacristans() async {
    final response = await http.get(Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/getAllSacristan.php'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        List<dynamic> sacristanJson = jsonResponse['sacristan'];
        return sacristanJson.map((json) => Sacristan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sacristan');
      }
    } else {
      throw Exception('Failed to load sacristan');
    }
  }

  Future<Map<String, dynamic>> saveSelectedPersons(
    int eventDateId,
    List<int> priestIds,
    List<int> lectorIds,
    List<int> sacristanIds,
  ) async {
    final url = Uri.parse(
        'http://${localhostInstance.ipServer}/dashboard/myfolder/scheduling/saveSelectedPersons.php');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'event_date_id': eventDateId,
        'priests': priestIds,
        'lectors': lectorIds,
        'sacristans': sacristanIds,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to save selected persons');
    }
  }
}
