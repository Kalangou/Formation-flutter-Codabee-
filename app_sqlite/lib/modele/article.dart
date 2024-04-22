class Article {
  late int? id;
  late String? nom;
  late int? item;
  var prix = null;
  late String? magasin;
  late String? image;

  Article();

  void fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom = map['nom'];
    this.item = map['item'];
    this!.prix = map['prix'];
    this.magasin = map['magasin'];
    this.image = map['image'];
  }

  Map<String, dynamic>? toMap() {
    Map<String, dynamic> map = {
      'nom': this.nom,
      'item': this.item,
      'magasin': this.magasin,
      'image': this.image,
      'prix': this.prix
    };

    if (id != null) {
      map['id'] = this.id;
    }

    return map;
  }
}
