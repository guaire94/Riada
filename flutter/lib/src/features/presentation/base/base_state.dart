import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseState<T extends StatefulWidget, B extends Bloc>
    extends State<T> {
  late B bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<B>();
  }
}
