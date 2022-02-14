import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';

abstract class PostState {}

class PostEmpty extends PostState {}

class PostDraft extends PostState {
  PostDraft({required this.content});

  final String content;
}

class PostPublishing extends PostState {}

class PostPublishError extends PostState {
  PostPublishError({required this.message});

  final String message;
}

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        super(PostEmpty());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;

  Future<void> publishPost(String content) async {
    final authorId = _authRepo.userId();
    if (authorId != null) {
      try {
        emit(PostPublishing());
        await _postRepo.publishPost(authorId: authorId, content: content);
        emit(PostEmpty());
      } on PlatformException catch (err) {
        emit(PostPublishError(message: err.message ?? 'Error publish post.'));
      } catch (err) {
        emit(PostPublishError(message: 'Error publish post.'));
      }
    } else {
      throw Exception('publishPost panic.');
    }
  }

  void updateContent(String content) {
    if (content.isNotEmpty) {
      emit(PostDraft(content: content));
    } else {
      emit(PostEmpty());
    }
  }

  void clearContent() {
    emit(PostEmpty());
  }
}
