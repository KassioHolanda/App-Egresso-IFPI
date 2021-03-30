import 'package:egresso_ifpi/domain/model/curso.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

typedef DeleteTag<T> = void Function(T index);

typedef TagTitle<CourseModel> = Widget Function(CourseModel tag);

class FlutterTagView extends StatefulWidget {
  FlutterTagView(
      {@required this.tags,
      this.minTagViewHeight = 0,
      this.maxTagViewHeight = 150,
      this.tagBackgroundColor = Colors.black12,
      this.selectedTagBackgroundColor = Colors.lightBlue,
      this.deletableTag = true,
      this.onDeleteTag,
      this.tagTitle})
      : assert(
            tags != null,
            'Tags can\'t be empty\n'
            'Provide the list of tags');

  ObservableList<dynamic> tags;

  Color tagBackgroundColor;

  Color selectedTagBackgroundColor;

  bool deletableTag;

  double maxTagViewHeight;

  double minTagViewHeight;

  DeleteTag<int> onDeleteTag;

  TagTitle<CursoModel> tagTitle;

  @override
  _FlutterTagViewState createState() => _FlutterTagViewState();
}

class _FlutterTagViewState extends State<FlutterTagView> {
  int selectedTagIndex = -1;

  @override
  Widget build(BuildContext context) {
    return getTagView();
  }

  Widget getTagView() {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5.0,
        direction: Axis.horizontal,
        children: buildTags(),
      ),
    );
  }

  List<Widget> buildTags() {
    List<Widget> tags = <Widget>[];

    for (int i = 0; i < widget.tags.length; i++) {
      tags.add(createTag(i, widget.tags[i]));
    }

    return tags;
  }

  Widget createTag(int index, CursoModel tagTitle) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTagIndex = index;
        });
      },
      child: Chip(
        backgroundColor: widget.tagBackgroundColor,
        label: widget.tagTitle == null
            ? Text('${tagTitle.description}')
            : widget.tagTitle(tagTitle),
        deleteIcon: Icon(Icons.cancel),
        onDeleted: null,
      ),
    );
  }
}
