class Site {
  final String id;
  final String name;

  const Site({
    this.id = '',
    this.name = '',
  });

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
        id: json['site_id'] as String, name: json['site_name'] as String);
  }
}

class Coperate {
  final String id;
  final String name;
  final String shortname;
  final List<Site> sites;

  const Coperate(
      {this.id = '',
      this.name = '',
      this.shortname = '',
      this.sites = const [Site()]});

  factory Coperate.fromJson(Map<String, dynamic> json) {
    final raw = json['site'] as List<dynamic>;
    final sites =
        raw.map((e) => Site.fromJson(e as Map<String, dynamic>)).toList();

    return Coperate(
        id: json['corp_id'] as String,
        shortname: json['corp_short_name'] as String,
        name: json['corp_name'] as String,
        sites: sites);
  }
}
