import 'package:hive/hive.dart';

part 'file_class.g.dart';

@HiveType(typeId: 0)
class monitoring_doc {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String mon_docN;

  @HiveField(2)
  final String doc_time;

  @HiveField(3)
  final int pr_serial;

  monitoring_doc(this.name, this.mon_docN, this.doc_time, this.pr_serial);
}

@HiveType(typeId: 1)
class rd {
  @HiveField(0)
  final String rname;

  @HiveField(1)
  final String rdoc_num;

  @HiveField(2)
  final String rdoc_time;

  @HiveField(3)
  final int ra_serial;

  rd(this.rname, this.rdoc_num, this.rdoc_time, this.ra_serial);
}
