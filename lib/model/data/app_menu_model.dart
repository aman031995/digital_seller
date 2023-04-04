class AppMenuModel {
  final List<Menu>? appMenu;

  AppMenuModel({this.appMenu});

  factory AppMenuModel.fromJson(Map<String, dynamic> json) {
    return AppMenuModel(
      appMenu: List<Menu>.from(
        json['appMenu'].map((menu) => Menu.fromJson(menu)),
      ),
    );
  }
}

class Menu {
  final String? title;
  final String? url;
  final String? icon;
  final List<Menu>? childNodes;

  Menu({
    this.title,
    this.url,
    this.icon,
    this.childNodes,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      title: json['title'],
      url: json['url'],
      icon: json['icon'],
      childNodes: json['childNodes'] != null ? List<Menu>.from(json['childNodes'].map((menu) => Menu.fromJson(menu)),
      ) : null,
    );
  }
}
