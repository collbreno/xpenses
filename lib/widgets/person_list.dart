import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

class PersonList extends StatefulWidget {
  final Money totalValue;
  const PersonList({
    super.key,
    required this.totalValue,
  });

  @override
  State<PersonList> createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  late final List<String> _list;

  @override
  void initState() {
    _list = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_list.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 6),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  title: Row(
                    children: [
                      const Expanded(flex: 3, child: Text('Você')),
                      Expanded(
                        flex: 2,
                        child: Text(
                          (widget.totalValue / (_list.length + 1)).toString(),
                        ),
                      ),
                    ],
                  ),
                  trailing: const IconButton(
                    icon: Icon(Icons.abc, color: Colors.transparent),
                    onPressed: null,
                  ),
                ),
                ..._list.map((e) => ListTile(
                      dense: true,
                      title: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {},
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(e),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {},
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  (widget.totalValue / (_list.length + 1))
                                      .toString(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            _list.remove(e);
                          });
                        },
                      ),
                    ))
              ],
            ),
          )
      ],
    );
  }
}
