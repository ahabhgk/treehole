import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/repositories/authentication.dart';
import 'package:treehole/repositories/post.dart';
import 'package:treehole/repositories/profile.dart';

abstract class PublishPostState {}

class PublishPostEmpty extends PublishPostState {}

class PublishPostDraft extends PublishPostState {
  PublishPostDraft({required this.content});

  final String content;
}

class PublishPostPublishing extends PublishPostState {}

class PublishPostError extends PublishPostState {
  PublishPostError({required this.message});

  final String message;
}

class PublishPostCubit extends Cubit<PublishPostState> {
  PublishPostCubit({
    required PostRepository postRepo,
    required AuthenticationRepository authRepo,
    required ProfileRepository profileRepo,
  })  : _postRepo = postRepo,
        _authRepo = authRepo,
        _profileRepo = profileRepo,
        super(PublishPostEmpty());

  final PostRepository _postRepo;
  final AuthenticationRepository _authRepo;
  final ProfileRepository _profileRepo;

  Future<void> publishPost(String content, Permission permission) async {
    final authorId = _authRepo.userId();
    try {
      emit(PublishPostPublishing());
      final postEmotion = await _postRepo.analyzePostEmotion(content);
      await _postRepo.publishPost(
        authorId: authorId,
        content: content,
        emotion: postEmotion,
        permission: permission,
      );
      final postCount = await _postRepo.fetchPostsCountByAuthorId(authorId);
      await _profileRepo.updateUserEomtion(authorId, postEmotion, postCount);
      emit(PublishPostEmpty());
    } on PlatformException catch (err) {
      emit(PublishPostError(message: err.message ?? 'Error publish post.'));
    } catch (err) {
      emit(PublishPostError(message: 'Error publish post.'));
    }
  }

  void updateContent(String content) {
    if (content.isNotEmpty) {
      emit(PublishPostDraft(content: content));
    } else {
      emit(PublishPostEmpty());
    }
  }

  void clearContent() {
    emit(PublishPostEmpty());
  }
}
