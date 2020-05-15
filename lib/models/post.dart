import 'package:uuid/uuid.dart';

enum Category { all, electronics, clothes, textbook }

enum Status { open, sold }

class Post {
  ///The title of the post.
  String title;

  ///The category of the post.
  Category category;

  ///The content of post.
  String content;
  double price;
  String postId;
  String postUserId;
  String postUserDisplayName;

  ///The status of the post.
  //Status status;

  ///The bytes data of images of the post.
  List<List<int>> imageBytes;
  List<String> imagePaths;

  DateTime postedDate;

  bool isSold = false;

  Post(
      {this.content,
      this.title,
      this.postId,
      this.postUserId,
      this.postUserDisplayName,
      this.price,
      this.postedDate,
      this.imageBytes,
      this.imagePaths,
      this.category,
      //this.status,
      this.isSold = false});

  Post.createNewPost({this.content, this.title, this.postUserId, this.postUserDisplayName, this.price, this.category})
      : postId = Uuid().v4(),
        postedDate = DateTime.now();
  //status = Status.open;

  Post.fromMap(Map map) {
    print("Inside fromMap : ${map['imagePaths']}");
    imagePaths = map['imagePaths'] == null ? [] : (map['imagePaths'] as List).cast<String>();

    //status = Status.values.elementAt(map['statusIndex'] ?? 0);
    title = map['title'];
    content = map['content'];
    category = Category.values.elementAt(map['categoryIndex']);
    price = map['price'] * 1.0;
    postId = map['id'];
    postUserId = map['postUserUid'];
    postUserDisplayName = map['postUserDisplayName'];

    postedDate = DateTime.parse(map['postedDate'] ?? "2020-04-09").toLocal();

    isSold = map['isSold'] ?? false;
  }
}

String categoryToString(Category category) {
  switch (category) {
    case Category.all:
      return 'All';
    case Category.electronics:
      return 'Electronics';
    case Category.clothes:
      return 'Clothes';
    case Category.textbook:
      return 'Textbook';
    default:
      throw Exception('Category not matched.');
  }
}

List<String> categoryToLabels(Category category) {
  switch (category) {
    case Category.all:
      return ['All'];
    case Category.electronics:
      return ['Electronics', 'Electronic', 'Technology', 'Gadget'];
    case Category.clothes:
      return ['Clothes', 'Cloth', 'Shirt', 'Dress', 'Jacket', 'Blazer', 'Outerwear', 'Clothing', 'Suit'];
    case Category.textbook:
      return ['Textbook', 'Book', 'Books', 'Text', 'Novel', 'Publication'];
    default:
      throw Exception('Category not matched.');
  }
}
