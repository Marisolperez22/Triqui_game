import 'package:flutter/material.dart';
import 'package:triki_game/alert_dialog.dart';
import 'package:triki_game/socket/socket.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final socket = SocketClient();

  int filledBox = 0;
  List<dynamic> boxes = ['', '', '', '', '', '', '', '', ''];
  String code = '';
  String player = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Obtener los argumentos de la ruta en didChangeDependencies
    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    code = arguments['code'];
    player = arguments['player'];

    // Mueve socket.joinGame(code) aquí para ejecutarlo después de que el árbol de widgets esté construido
    socket.joinGame(code);

    socket.listenMovement((choices) {
      setState(() {
        boxes = choices;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void showAlerta(String title, String message) {
      showAlert(
          context: context,
          title: title,
          message: message,
          buttonText: 'Acepto',
          onPressed: () {
            Navigator.of(context).pop();
          });
    }

    void checkWinner() {
      if (filledBox == 9) {
        showAlerta('Empate', '');
      }
    }

    socket.winner((winner) => showAlerta('Ganador', winner));

    void tapAction(int index) {
      setState(() {
        if ('$player' == '1' && boxes[index] == '') {
          boxes[index] = 'o';
          filledBox += 1;
        } else if ('$player' == '2' && boxes[index] == '') {
          boxes[index] = 'x';
          filledBox += 1;
          checkWinner();
        }
      });
      socket.movement(boxes, code);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Triki game',
            style: TextStyle(fontSize: 30),
          )),
          backgroundColor: const Color.fromARGB(210, 19, 59, 119),
        ),
        backgroundColor: const Color.fromARGB(210, 19, 59, 119),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Text(
                  'Jugador $player',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        tapAction(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white)),
                        child: Center(
                            child: Text(
                          boxes[index],
                          style: TextStyle(
                              color: boxes[index] == 'x'
                                  ? Colors.white
                                  : Colors.red,
                              fontSize: 40),
                        )),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Sala: $code',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Container(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        ('$player' == '1')
                            ? 'Turno jugador 1'
                            : 'Turno jugador 2',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
