import 'dart:async'; //For StreamController/Stream
import 'dart:io'; //InternetAddress utility

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      new ConnectionStatusSingleton._internal();

  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This check if initialized.
  bool isInit = false;

  //This check if message is shown.
  static bool isShown = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController =
      new StreamController.broadcast();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    //_connectivity.onConnectivityChanged.listen(_connectionChange);
    Future.delayed(Duration(seconds: 5), () async {
      await checkConnection();
      isInit = true;
      Timer.periodic(Duration(seconds: 5), (timer) {
        checkConnection();
      });
    });
    //checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection || !isInit) {
      connectionChangeController.add(hasConnection);
    }
    connectionChanged(hasConnection);
    return hasConnection;
  }

  static void connectionChanged(dynamic hasConnection) {
    if (hasConnection) {
      try {
        // TODO:  Hide notification.
        isShown = false;
      } catch (ex) {}
    } else {
      if (!isShown) {
        try {
          // TODO:  Show notification.
          isShown = true;
        } catch (ex) {}
      }
    }
  }
}
