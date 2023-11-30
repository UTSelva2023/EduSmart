// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class Respuestas extends StatefulWidget {
  final String incisos;
  final bool isSelected;
  final bool isDisable;
  final ValueChanged<bool> onTap; 
  final ValueChanged<String> onTapRespuesta;
  const Respuestas({
    Key? key,
    required this.incisos,
    required this.isDisable,
    required this.isSelected,
    required this.onTap,
    required this.onTapRespuesta,
  }):super(key: key);

  @override
  _RespuestasState createState() => _RespuestasState();
}
class _RespuestasState extends State<Respuestas> {
  int? selectedIndex;
   // Cambiar a verdadero cuando se selecciona
 Color get _selectedColorRight =>
     widget.isSelected ? AppColors.darkGreen : AppColors.darkRed;

  Color get _selectedBorderRight =>
      widget.isSelected ? AppColors.lightGreen : AppColors.lightRed;

  Color get _selectedColorCardRight =>
      widget.isSelected ? AppColors.lightGreen : AppColors.lightRed;

  Color get _selectedBorderCardRight =>
      widget.isSelected? AppColors.green : AppColors.red;

  TextStyle get _selectedTextStyleRight =>
      widget.isSelected? AppTextStyles.bodyDarkGreen : AppTextStyles.bodyDarkRed;

  IconData get _selectedIconRight => widget.isSelected ? Icons.check : Icons.close;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: IgnorePointer(
      ignoring: widget.isDisable,
      child: GestureDetector(
      onTap: () {
        setState(() {
           widget.onTap(!widget.isSelected);
           //print('Se selecciono: ${widget.incisos}');
           widget.onTapRespuesta(widget.incisos);
        });
       
      },
        child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isSelected ? _selectedColorCardRight : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.fromBorderSide(
                BorderSide(
                  color:
                      widget.isSelected ? _selectedBorderCardRight : AppColors.border,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.incisos,
                    style: widget.isSelected
                        ? _selectedTextStyleRight
                        : AppTextStyles.body,
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isSelected ? _selectedColorRight : AppColors.white,
                    borderRadius: BorderRadius.circular(500),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: widget.isSelected
                            ? _selectedBorderRight
                            : AppColors.border,
                      ),
                    ),
                  ),
                  child: widget.isSelected
                      ? Icon(
                          _selectedIconRight,
                          color: AppColors.white,
                          size: 16,
                        )
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}