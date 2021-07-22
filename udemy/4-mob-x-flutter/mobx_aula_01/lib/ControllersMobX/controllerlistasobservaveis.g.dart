// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controllerlistasobservaveis.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ControllerListasObservaveis on ControllerListasObservaveisBase, Store {
  final _$novoItemAtom = Atom(name: 'ControllerListasObservaveisBase.novoItem');

  @override
  String get novoItem {
    _$novoItemAtom.reportRead();
    return super.novoItem;
  }

  @override
  set novoItem(String value) {
    _$novoItemAtom.reportWrite(value, super.novoItem, () {
      super.novoItem = value;
    });
  }

  final _$ControllerListasObservaveisBaseActionController =
      ActionController(name: 'ControllerListasObservaveisBase');

  @override
  void setNovoItem(String valor) {
    final _$actionInfo = _$ControllerListasObservaveisBaseActionController
        .startAction(name: 'ControllerListasObservaveisBase.setNovoItem');
    try {
      return super.setNovoItem(valor);
    } finally {
      _$ControllerListasObservaveisBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void adicionarItem() {
    final _$actionInfo = _$ControllerListasObservaveisBaseActionController
        .startAction(name: 'ControllerListasObservaveisBase.adicionarItem');
    try {
      return super.adicionarItem();
    } finally {
      _$ControllerListasObservaveisBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
novoItem: ${novoItem}
    ''';
  }
}
