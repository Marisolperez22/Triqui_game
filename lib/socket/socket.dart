import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

//constructor privado llamado _internal
  SocketClient._internal() {
    //inicializa la conexión del socket utilizando la dirección del backend
    socket = IO.io('ws://triqui-backend.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    // Intenta conectar el socket
    socket!.connect();
  }

  // Método para enviar un unirse a una sala
  void joinGame(String room) {
    print('Entro a la sala');
    // Utiliza la función 'emit' para enviar un evento llamado 'message' al servidor
    socket!.emit('join_game', {'room': room});
  }

  //Método para hacer un movimiento
  void movement(List<dynamic> boxes, String room) {
    socket!.emit('movement', {'table': boxes, 'room': room});
  }

  void listenMovement(Function(List<dynamic>) onMovementReceived) {
    // Utiliza la función 'on' para escuchar el evento 'message' del servidor
    socket!.on('updateTable', (data) {
      print(data);
      onMovementReceived(data);
    });
  }

  void winner(Function(String) onWinner) {
    // Utiliza la función 'on' para escuchar el evento 'message' del servidor
    socket!.on('winner', (data) {
      onWinner(data);
    });
  }

  //getter estático para obtener la instancia única de la clase SocketClient.
  //Al utilizar el método estático SocketClient.instance,
  //puedes acceder a la instancia única de la clase en cualquier parte de tu código.
  // Método de fábrica para obtener la instancia única del SocketClient
  factory SocketClient() {
    _instance ??= SocketClient._internal();
    return _instance!;
  }

  void main() {
    SocketClient socketClient = SocketClient();
    // Accede al socket
    IO.Socket? socket = socketClient.socket;

    // Puedes verificar la conexión en cualquier momento
    if (socket?.connected ?? false) {
      print('Socket is connected');
    } else {
      print('Socket is not connected');
    }
  }
}
