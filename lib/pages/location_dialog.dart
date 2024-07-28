import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/env/env.dart';
import 'package:weather_app/utils/button.dart';
import 'package:weatherapi/weatherapi.dart';

String inputString = "";

class SelectLocation extends StatelessWidget {
  final Function(String) ChangeLocationFunction;
  const SelectLocation({super.key, required this.ChangeLocationFunction});

  @override
  Widget build(BuildContext context) {
    void ButtonPressed() {
      ChangeLocationFunction(inputString);
      Navigator.of(context).pop();
    }

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
      content: SizedBox(
        height: 200,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Choose your location', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20.0),
            _AsyncAutocomplete(),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustumButton(
                  OnPressed: ButtonPressed,
                  ButtonText: "OK",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AsyncAutocomplete extends StatefulWidget {
  const _AsyncAutocomplete();

  @override
  State<_AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState extends State<_AsyncAutocomplete> {
  // The query currently being searched for. If null, there is no pending
  // request.
  String? _currentQuery;

  // The most recent options received from the API.
  late Iterable<String> _lastOptions = <String>[];

  late final _Debounceable<Iterable<String>?, String> _debouncedSearch;

  // Calls the "remote" API to search with the given query. Returns null when
  // the call has been made obsolete.
  Future<Iterable<String>?> _search(String query) async {
    _currentQuery = query;

    // In a real application, there should be some error handling here.
    final Iterable<String> options = await WeatherAPI.search(_currentQuery!);

    // If another search happened after this one, throw away these options.
    if (_currentQuery != query) {
      return null;
    }
    _currentQuery = null;

    return options;
  }

  @override
  void initState() {
    super.initState();
    _debouncedSearch = _debounce<Iterable<String>?, String>(_search);
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        inputString = textEditingValue.text;
        final Iterable<String>? options =
            await _debouncedSearch(textEditingValue.text);
        if (options == null) {
          return _lastOptions;
        }
        _lastOptions = options;
        return options;
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
      },
    );
  }
}

// API.
class WeatherAPI {
  static const String key = Env.apikey;

  static Future<Iterable<String>> search(String query) async {
    if (query == '') {
      return const Iterable<String>.empty();
    }

    List<String> kOptions = [];
    WeatherRequest wr = WeatherRequest(key);
    SearchResults sr = await wr.getResultsByCityName(query);
    for (LocationResultData location in sr.locations) {
      kOptions
          .add("${location.name!}, ${location.region!}, ${location.country!}");
    }
    return kOptions;
  }
}

typedef _Debounceable<S, T> = Future<S?> Function(T parameter);

/// Returns a new function that is a debounced version of the given function.
///
/// This means that the original function will be called only after no calls
/// have been made for the given Duration.
_Debounceable<S, T> _debounce<S, T>(_Debounceable<S?, T> function) {
  _DebounceTimer? debounceTimer;

  return (T parameter) async {
    if (debounceTimer != null && !debounceTimer!.isCompleted) {
      debounceTimer!.cancel();
    }
    debounceTimer = _DebounceTimer();
    try {
      await debounceTimer!.future;
    } catch (error) {
      if (error is _CancelException) {
        return null;
      }
      rethrow;
    }
    return function(parameter);
  };
}

// A wrapper around Timer used for debouncing.
class _DebounceTimer {
  _DebounceTimer() {
    _timer = Timer(const Duration(milliseconds: 500), _onComplete);
  }

  late final Timer _timer;
  final Completer<void> _completer = Completer<void>();

  void _onComplete() {
    _completer.complete();
  }

  Future<void> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void cancel() {
    _timer.cancel();
    _completer.completeError(const _CancelException());
  }
}

// An exception indicating that the timer was canceled.
class _CancelException implements Exception {
  const _CancelException();
}
