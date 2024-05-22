import 'package:dio/dio.dart';
import 'package:network_discovery/network_discovery.dart';

class NetworkInterface {
  List<NetworkAddress> addreses = [];
  final Dio dio = Dio();
  void scanForIPAddress({
    int port = 80,
    String subnet = '192.168.0',
    void Function()? callback,
  }) {
    final stream = NetworkDiscovery.discover(subnet, port);
    stream.listen((NetworkAddress addr) {
      addreses.add(addr);
      if (callback != null) {
        callback();
      }
    });
  }
}
