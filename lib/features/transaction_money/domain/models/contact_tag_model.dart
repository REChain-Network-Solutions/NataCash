import 'package:azlistview/azlistview.dart';
import 'package:flutter_contacts/contact.dart';

class ContactTagModel extends ISuspensionBean{
  final Contact? contact;
  final String tag;
  ContactTagModel({required this.contact, required this.tag});

  @override
  String getSuspensionTag()=> tag;
}