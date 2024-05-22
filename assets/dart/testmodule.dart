void sendImage(Function callback, List<List<int>> bitmap) {
  callback({
    'body': {
      'image': bitmap
    },
    'method':'post',
    'url':'http://localhost:3000/setImage',
    'headers': {
      'Content-Type': 'application/json'
    },
    'timeout': 10000,
  });
}

void getInfo(Function callback) {
  callback({
    'name': 'Test module',
    'description': 'Simulated device',
    'version': '1.0.0',
    'author': 'LedCtrl',
    'colorDeph': 0,
    'size': {
      'width': 9,
      'height': 9
    },
  });
}