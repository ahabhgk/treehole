import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treehole/components/header.dart';
import 'package:treehole/models/post.dart';
import 'package:treehole/services/publish_post.dart';
import 'package:treehole/utils/ui.dart';
import 'package:treehole/utils/validator.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({Key? key}) : super(key: key);

  static const String route = '/add_post';

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formKey = GlobalKey<FormState>();
  Permission _permission = Permission.self;

  void _publish(BuildContext context, PublishPostState state) async {
    if (state is PublishPostDraft) {
      await BlocProvider.of<PublishPostCubit>(context)
          .publishPost(state.content, _permission);
      Navigator.of(context).pop();
      context.showSnackbar('Publish post success.');
    } else if (state is PublishPostEmpty) {
      context.showSnackbar('Post content can\'t be empty.');
    }
  }

  void _updatePostContent(String content) {
    BlocProvider.of<PublishPostCubit>(context).updateContent(content);
  }

  void _cancel(PublishPostState state) async {
    if (state is PublishPostDraft) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Save this draft'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                BlocProvider.of<PublishPostCubit>(context).clearContent();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublishPostCubit, PublishPostState>(
      listener: (context, state) {
        if (state is PublishPostError) {
          context.showErrorSnackbar(state.message);
        }
      },
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Header(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _cancel(state),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: state is PublishPostPublishing
                          ? null
                          : () => _publish(context, state),
                      child: Text(state is PublishPostPublishing
                          ? 'Publishing...'
                          : 'Publish'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      minLines: 10,
                      maxLines: 20,
                      initialValue:
                          state is PublishPostDraft ? state.content : '',
                      onChanged: _updatePostContent,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: 'Share your feelings...',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: Validator.postContent,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Permission: '),
                    DropdownButton(
                      value: _permission,
                      items: const [
                        DropdownMenuItem(
                          child: Text('Only for yourself'),
                          value: Permission.self,
                        ),
                        DropdownMenuItem(
                          child: Text('Anonymous for pals'),
                          value: Permission.anonymousForPals,
                        ),
                        DropdownMenuItem(
                          child: Text('For pals'),
                          value: Permission.pal,
                        ),
                        DropdownMenuItem(
                          child: Text('Anonymous for anyone'),
                          value: Permission.anonymousForAnyone,
                        ),
                        DropdownMenuItem(
                          child: Text('For anyone'),
                          value: Permission.anyone,
                        ),
                      ],
                      onChanged: (Permission? value) {
                        if (value != null) {
                          setState(() {
                            _permission = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
