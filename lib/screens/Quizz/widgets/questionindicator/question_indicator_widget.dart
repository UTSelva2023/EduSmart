import 'dart:async';

import 'package:edusmart/screens/Quizz/widgets/questionindicator/progress_indicator_widget.dart';
import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';


class QuestionIndicatorWidget extends StatefulWidget {
  final int currentPage;
  final int length;

  const QuestionIndicatorWidget({
    Key? key,
    required this.currentPage,
    required this.length,
  }) : super(key: key);
  @override
  State<QuestionIndicatorWidget> createState() => _QuestionIndicatorWidgetState();
}
class _QuestionIndicatorWidgetState extends State<QuestionIndicatorWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Se muestra el número que se lleva del cuestionario
                Text(
                  "Pregunta ${widget.currentPage}",
                  style: AppTextStyles.body,
                ),
                //Se muestra la cantidad total del cuestionario
                Text(
                  "de ${widget.length}",
                  style: AppTextStyles.body,
                ),
              ],
            ),
           const SizedBox(
              height: 16,
            ),
            ProgressIndicatorWidget(
              value: widget.currentPage / widget.length,
            ),
          ],
        ));
  }
}
