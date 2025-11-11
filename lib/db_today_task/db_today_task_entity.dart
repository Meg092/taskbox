class TaskEntity {
  final int? id;
  final String name;
  final int duration;
  final String? description;
  final String? imagePath;
  final int color;
  final String createTime;
  final String status;

  const TaskEntity({
    this.id,
    required this.name,
    required this.duration,
    this.description,
    this.imagePath,
    required this.color,
    required this.createTime,
    required this.status,
  });

  factory TaskEntity.fromMap(Map<String, dynamic> map) {
    return TaskEntity(
      id: map['id'] as int?,
      name: map['name'] as String,
      duration: map['duration'] as int,
      description: map['description'] as String?,
      imagePath: map['image_path'] as String?,
      color: map['color'] as int,
      createTime: map['create_time'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'duration': duration,
      'description': description,
      'image_path': imagePath,
      'color': color,
      'create_time': createTime,
      'status': status,
    };
  }

  TaskEntity copyWith({
    int? id,
    String? name,
    int? duration,
    String? description,
    String? imagePath,
    int? color,
    String? createTime,
    String? status,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      color: color ?? this.color,
      createTime: createTime ?? this.createTime,
      status: status ?? this.status,
    );
  }
}

class TaskStatus {
  static const String inProgress = 'in_progress';
  static const String completed = 'completed';
}
