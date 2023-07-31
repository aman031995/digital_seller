// App Menu Modal
class AppMenuModel {
  final List<Menu>? appMenu;
  final String? menuVersion;

  AppMenuModel({this.appMenu, this.menuVersion});

  factory AppMenuModel.fromJson(Map<String, dynamic> json) {
    return AppMenuModel(
        appMenu: List<Menu>.from(
          json['appMenu'].map((menu) => Menu.fromJson(menu)),
        ),
        menuVersion: json['version']
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
