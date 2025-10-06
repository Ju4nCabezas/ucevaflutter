// main.dart
// Flutter demo app showing:
// 1) Async with Future / async-await (simulated service with Future.delayed)
// 2) Timer-based stopwatch (start/pause/resume/reset)
// 3) CPU-bound task executed in an Isolate
//
// How to use:
// - Create a new Flutter app and replace lib/main.dart with this file
// - `flutter run`

import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async / Timer / Isolate Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({Key? key}) : super(key: key);

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async / Timer / Isolate Demo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Async (Future)'),
            Tab(text: 'Timer (Stopwatch)'),
            Tab(text: 'Isolate (Heavy)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [AsyncDemo(), TimerDemo(), IsolateDemo()],
      ),
    );
  }
}

// -------------------------
// 1) Async / Future demo
// -------------------------

class AsyncDemo extends StatefulWidget {
  const AsyncDemo({Key? key}) : super(key: key);

  @override
  State<AsyncDemo> createState() => _AsyncDemoState();
}

enum AsyncState { idle, loading, success, error }

class _AsyncDemoState extends State<AsyncDemo> {
  AsyncState _state = AsyncState.idle;
  String _data = '';

  // Simulated service: waits 2.5 seconds and returns data (or throws)
  Future<String> _fakeService({bool fail = false}) async {
    print('Service: called (before delay)');
    await Future.delayed(const Duration(milliseconds: 2500));
    print('Service: after delay');
    if (fail) throw Exception('Simulated service error');
    return 'Datos recibidos a las ${DateTime.now()}';
  }

  // Example using async/await
  Future<void> _fetchData() async {
    print('Fetch: before');
    setState(() => _state = AsyncState.loading);
    try {
      print('Fetch: awaiting service...');
      final result = await _fakeService(); // await without blocking UI
      print('Fetch: after await (got result)');
      setState(() {
        _state = AsyncState.success;
        _data = result;
      });
    } catch (e) {
      print('Fetch: caught error -> $e');
      setState(() => _state = AsyncState.error);
    } finally {
      print('Fetch: finally block');
    }
    print('Fetch: after');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Demostración de async / await con Future.delayed',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _fetchData(),
            icon: const Icon(Icons.download),
            label: const Text('Consultar servicio simulado'),
          ),
          const SizedBox(height: 12),
          _buildStateWidget(),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Consola: el orden de ejecución aparece en la salida de debug.',
          ),
        ],
      ),
    );
  }

  Widget _buildStateWidget() {
    switch (_state) {
      case AsyncState.idle:
        return const Text('Estado: Inactivo');
      case AsyncState.loading:
        return Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 12),
            Text('Cargando...'),
          ],
        );
      case AsyncState.success:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Éxito:'), Text(_data)],
        );
      case AsyncState.error:
        return const Text(
          'Error: al obtener datos',
          style: TextStyle(color: Colors.red),
        );
    }
  }
}

// -------------------------
// 2) Timer demo (stopwatch)
// -------------------------

class TimerDemo extends StatefulWidget {
  const TimerDemo({Key? key}) : super(key: key);

  @override
  State<TimerDemo> createState() => _TimerDemoState();
}

class _TimerDemoState extends State<TimerDemo> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  late DateTime _lastTickTime; // helps to handle resume accurately

  // Update interval: 1000 ms for 1s updates. Change to 100 for ms precision.
  static const int _tickMs = 1000;

  void _start() {
    if (_isRunning) return;
    print('Timer: start');
    _isRunning = true;
    _lastTickTime = DateTime.now();
    _timer = Timer.periodic(Duration(milliseconds: _tickMs), _onTick);
    setState(() {});
  }

  void _onTick(Timer t) {
    final now = DateTime.now();
    final delta = now.difference(_lastTickTime);
    _lastTickTime = now;
    setState(() {
      _elapsed += delta;
    });
  }

  void _pause() {
    if (!_isRunning) return;
    print('Timer: pause');
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    setState(() {});
  }

  void _resume() {
    if (_isRunning) return;
    print('Timer: resume');
    _isRunning = true;
    _lastTickTime = DateTime.now();
    _timer = Timer.periodic(Duration(milliseconds: _tickMs), _onTick);
    setState(() {});
  }

  void _reset() {
    print('Timer: reset');
    _timer?.cancel();
    _timer = null;
    _elapsed = Duration.zero;
    _isRunning = false;
    setState(() {});
  }

  @override
  void dispose() {
    print('TimerDemo: dispose -> cancelling timer');
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms =
        (d.inMilliseconds.remainder(1000) ~/
                (1000 ~/ (_tickMs == 100 ? 10 : 1)))
            .toString()
            .padLeft(2, '0');
    // If tickMs==1000 we show mm:ss
    if (_tickMs >= 1000) {
      return '$minutes:$seconds';
    } else {
      return '$minutes:$seconds.$ms';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text('Cronómetro (Timer.periodic)'),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                _formatDuration(_elapsed),
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _start, child: const Text('Iniciar')),
              ElevatedButton(
                onPressed: _isRunning ? _pause : null,
                child: const Text('Pausar'),
              ),
              ElevatedButton(
                onPressed: !_isRunning && _elapsed > Duration.zero
                    ? _resume
                    : null,
                child: const Text('Reanudar'),
              ),
              ElevatedButton(onPressed: _reset, child: const Text('Reiniciar')),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Nota: El timer se cancela en dispose para liberar recursos.',
          ),
        ],
      ),
    );
  }
}

// -------------------------
// 3) Isolate demo (heavy work)
// -------------------------

class IsolateDemo extends StatefulWidget {
  const IsolateDemo({Key? key}) : super(key: key);

  @override
  State<IsolateDemo> createState() => _IsolateDemoState();
}

class _IsolateDemoState extends State<IsolateDemo> {
  bool _isWorking = false;
  String _result = '';
  Isolate? _isolate;
  ReceivePort? _receivePort;

  // Example heavy function: compute sum of 1..n with delay to simulate heavy CPU work
  // We will run this in an isolate.
  static void _heavyWorkEntry(dynamic message) {
    // message is a List where [SendPort, int n]
    final sendPort = message[0] as SendPort;
    final n = message[1] as int;

    // Do a CPU-bound task (sum of squares can be heavy for very large n)
    // We'll do it in a way that takes noticeable time for demonstration.
    int64Sum(int x) {
      // using BigInt to avoid overflow when n is huge
      BigInt sum = BigInt.zero;
      for (int i = 1; i <= x; i++) {
        sum += BigInt.from(i);
      }
      return sum;
    }

    final start = DateTime.now();
    final computed = int64Sum(n);
    final elapsed = DateTime.now().difference(start);

    // Send back a textual result
    sendPort.send(
      'Resultado: suma 1..$n = $computed (took ${elapsed.inMilliseconds} ms)',
    );
  }

  Future<void> _startHeavyJob(int n) async {
    if (_isWorking) return;
    setState(() {
      _isWorking = true;
      _result = 'Iniciando isolate...';
    });

    _receivePort = ReceivePort();

    // When main isolate receives a message from the spawned isolate
    _receivePort!.listen((message) {
      print('Main isolate received: $message');
      setState(() {
        _result = message.toString();
        _isWorking = false;
      });
    });

    // Spawn the isolate and pass [sendPort, n]
    _isolate = await Isolate.spawn(_heavyWorkEntry, [
      _receivePort!.sendPort,
      n,
    ]);
  }

  void _stopIsolate() {
    if (_isolate != null) {
      print('Killing isolate');
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
    _receivePort?.close();
    _receivePort = null;
    setState(() {
      _isWorking = false;
      _result = 'Isolate detenido';
    });
  }

  @override
  void dispose() {
    _stopIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Isolate para trabajo CPU-bound'),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _isWorking
                ? null
                : () => _startHeavyJob(200000), // tune n for heavier work
            child: const Text('Ejecutar trabajo pesado (sum 1..n)'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _isWorking ? _stopIsolate : null,
            child: const Text('Detener isolate'),
          ),
          const SizedBox(height: 12),
          if (_isWorking) const LinearProgressIndicator(),
          const SizedBox(height: 12),
          Text(_result),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Observaciones:'),
          const Text(
            '- El trabajo pesado se ejecuta en un Isolate para no bloquear la UI.',
          ),
          const Text(
            '- Ajusta el parámetro n en el botón para aumentar o reducir el tiempo de CPU requerido.',
          ),
        ],
      ),
    );
  }
}
