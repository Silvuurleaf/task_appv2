
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';


//TODO clean this model up and have a better universal ID for todos that integrates well with firebase

class Todo extends Equatable{

  final int id;
  final String title;
  final String description;

  bool? isCompleted;
  bool? isCanceled;
  bool? isRemote;

  String? remoteId;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    this.isRemote,
    this.remoteId,
    this.isCanceled,
    this.isCompleted
  }) {
    isCanceled = isCanceled ?? false;
    isCompleted = isCompleted ?? false;
    isRemote = isRemote ?? false;
    remoteId = remoteId ?? "";
  }


  factory Todo.fromFireStore(DocumentSnapshot snapshot){

    return Todo(
      id: snapshot.get('id'),
      title: snapshot.get('title'),
      description: snapshot.get('description'),
      isCompleted: snapshot.get('isCompleted'),
      isCanceled: snapshot.get('isCanceled'),
      isRemote: snapshot.get('isRemote'),
      remoteId: snapshot.get(snapshot.id),
    );

  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': remoteId,
      'title': title,
      'description': description,
    };
  }


  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    bool? isCanceled,
    bool? isRemote,
    String? remoteId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      isCanceled: isCanceled ?? this.isCanceled,
      isRemote: isRemote ?? this.isRemote,
      remoteId: remoteId ?? this.remoteId,
    );
  }



  //LOCAL DATABASE

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    //isCompleted: json['isCompleted'],
    //isCanceled: json['isCanceled'],
    //isRemote: json['isRemote'],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      //'isCompleted': isCompleted,
      //'isCanceled': isCanceled,
      //'isRemote': isRemote,
    };
  }



  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isCompleted,
    isCanceled,
    isRemote,
    remoteId,
  ];

  factory Todo.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return Todo(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      isCompleted: data['isCompleted'],
      isCanceled: data['isCanceled'],
      isRemote: true,
      remoteId: data['remoteId'],
    );
  }

  factory Todo.fromJson(Map<String, dynamic> map) {

    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'],
      isCanceled: map['isCanceled'],
      isRemote: map['isRemote'],
    );

  }

  toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'isCanceled': isCanceled,
      'isRemote': isRemote,
    };
  }
}