import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownSearchExt extends StatelessWidget {
  Mode _mode;
  bool _showSelectionItem;
  bool _showSearchBox;
  List _items;
  String _label;
  String _hint;
  Function _onChanged;
  dynamic _selectedItem;

  DropdownSearchExt(
    Mode mode,
    bool showSelectionItem,
    bool showSearchBox,
    List items,
    String label,
    String hint,
    Function onChanged,
    dynamic selectedItem,
  ) {
    this._mode = mode;
    this._showSelectionItem = showSelectionItem;
    this._showSearchBox = showSearchBox;
    this._items = items;
    this._label = label;
    this._hint = hint;
    this._onChanged = onChanged;
    this._selectedItem = selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
      child: DropdownSearch(
          mode: _mode,
          //showSelectedItem: true,
          searchBoxDecoration:
              InputDecoration(hintText: 'Pesquisar um estado...'),
          showSearchBox: _showSearchBox,
          items: _items,
          label: _label,
          hint: _hint,
          //popupItemDisabled: (String s) => s.startsWith('I'),
          onChanged: _onChanged,
          selectedItem: _selectedItem),
    );
  }
}
