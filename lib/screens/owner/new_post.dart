import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:select_form_field/select_form_field.dart';

enum ItemType { ingredient, dish }

final List<Map<String, dynamic>> _items = [
  {
    'value': 'jp',
    'label': 'Japanese',
  },
  {
    'value': 'italy',
    'label': 'Italian',
  },
  {
    'value': 'france',
    'label': 'France',
  },
];

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _subscriptionPriceController = TextEditingController();
  NumberFormat numFormat = NumberFormat('###,###.00', 'en_US');
  NumberFormat numSanitizedFormat = NumberFormat('en_US');
  var currency = 'USD';
  var defaultPrice = '0.00';

  // form variables
  XFile? _image;
  String? itemName;
  String? itemPrice;
  DateTime? expiredAt;
  ItemType _itemType = ItemType.ingredient;
  String? foodType;

  final picker = ImagePicker();

  Future _getImageFromGallery() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future _getImageFromCamera() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _getImageFromGallery,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.collections,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      GestureDetector(
                        onTap: _getImageFromCamera,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.camera,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ItenNameForm(),
              PriceForm(
                currency: currency,
                subscriptionPriceController: _subscriptionPriceController,
                defaultPrice: defaultPrice,
                numSanitizedFormat: numSanitizedFormat,
                numFormat: numFormat,
              ),
              BasicDateTimeField(),
              Column(
                children: [
                  const Text(
                    'Item Type',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: const Text(
                            'Ingredient',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          leading: Radio<ItemType>(
                            value: ItemType.ingredient,
                            groupValue: _itemType,
                            onChanged: (ItemType? value) {
                              setState(() {
                                _itemType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: const Text(
                            'Dish',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          leading: Radio<ItemType>(
                            value: ItemType.dish,
                            groupValue: _itemType,
                            onChanged: (ItemType? value) {
                              setState(() {
                                _itemType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    const Text(
                      'Food Type',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 21,
                      ),
                    ),
                    SelectFormField(
                      type: SelectFormFieldType.dropdown, // or can be dialog
                      initialValue: 'jp',
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.format_shapes,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      labelText: 'Food Type',
                      items: _items,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      onChanged: (val) => print(val),
                      onSaved: (val) => print(val),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 100,
                child: (_image == null)
                    ? Image.asset(
                        "assets/images/no-photo.png",
                        width: 100,
                      )
                    : Image.file(
                        File(_image!.path),
                        width: 100,
                      ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Center(
                  child: Text(
                    'Create New Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd  HH:mm");

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Text(
        'Expired Time',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
          ),
          child: DateTimeField(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "Date Time",
            ),
            format: format,
            onShowPicker: (context, currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
              if (date != null) {
                final time = await showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                );
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
            onSaved: (dateTime) {},
          ),
        ),
      ),
    ]);
  }
}

class ItenNameForm extends StatelessWidget {
  const ItenNameForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          icon: Icon(
            Icons.ramen_dining,
            color: Colors.black,
          ),
          hintText: 'put your product name',
          label: Text(
            'Item Name *',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 19,
            ),
          ),
        ),
        validator: (String? value) {
          return (value != null && value.contains('@'))
              ? 'Do not use the @ char.'
              : null;
        },
        onChanged: (String value) {},
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class PriceForm extends StatelessWidget {
  const PriceForm({
    Key? key,
    required this.currency,
    required TextEditingController subscriptionPriceController,
    required this.defaultPrice,
    required this.numSanitizedFormat,
    required this.numFormat,
  })  : _subscriptionPriceController = subscriptionPriceController,
        super(key: key);

  final String currency;
  final TextEditingController _subscriptionPriceController;
  final String defaultPrice;
  final NumberFormat numSanitizedFormat;
  final NumberFormat numFormat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          icon: const Icon(
            LineIcons.wallet,
            color: Colors.black,
          ),
          prefixText:
              NumberFormat.simpleCurrency(name: currency).currencySymbol,
          label: const Text(
            'Item Price *',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (cost) {
          if (cost == null || cost.isEmpty) {
            return 'Empty';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        controller: _subscriptionPriceController..text = defaultPrice,
        onTap: () {
          var textFieldNum = _subscriptionPriceController.value.text;
          var numSanitized = numSanitizedFormat.parse(textFieldNum);
          _subscriptionPriceController.value = TextEditingValue(
            /// Clear if TextFormField value is 0
            text: numSanitized == 0 ? '' : '$numSanitized',
            selection: TextSelection.collapsed(offset: '$numSanitized'.length),
          );
        },
        onFieldSubmitted: (price) {
          /// Set value to 0 if TextFormField value is empty
          if (price == '') price = '0';
          final formattedPrice = numFormat.format(double.parse(price));
          _subscriptionPriceController.value = TextEditingValue(
            text: formattedPrice,
            selection: TextSelection.collapsed(offset: formattedPrice.length),
          );
        },
      ),
    );
  }
}