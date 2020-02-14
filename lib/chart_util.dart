import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:flutter/services.dart';



class ChartUtil {

  static String sensorValue;
  static String dateValue;
  static String tripSensorValue;
  static String tripDateValue;

  static charts.TimeSeriesChart _createChartData(List<LinearReport> vibrationData, bool isVibrationData) {

    var data = [
      new charts.Series<LinearReport, DateTime>(
        id: 'Desktop',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearReport sales, _) => sales.time,
        measureFn: (LinearReport sales, _) => sales.value,
        data: vibrationData,
      ),
    ];

    return charts.TimeSeriesChart(
      data,
      behaviors: [
        LinePointHighlighter(symbolRenderer: isVibrationData ? CustomCircleSymbolRenderer() : TripCustomCircleSymbolRenderer())
      ],
      selectionModels: [
        SelectionModelConfig(changedListener: (SelectionModel model) {
          if (model.hasDatumSelection) {
            if (isVibrationData) {
              sensorValue = dp(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index), 1)
                  .toString();
              dateValue = getDate(model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index)
                  .toString());
            } else {
              tripSensorValue = dp(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index), 1).toInt()
                  .toString();
              tripDateValue = getDate(model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index)
                  .toString());
            }
          }
        })
      ],
      defaultRenderer: new charts.LineRendererConfig(
          includeArea: true, stacked: true),
      animate: false,
      domainAxis: new charts.DateTimeAxisSpec(renderSpec: charts.NoneRenderSpec()),);
  }
}

/// Sample linear data type.
class LinearReport {
  final DateTime time;
  final double value;

  LinearReport(this.time, this.value);
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {

  @override
  void paint(ChartCanvas canvas, Rectangle bounds,
      {List dashPattern,
        Color fillColor,
        Color strokeColor,
        double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 100,
            bounds.height + 40),
        fill: Color.black,
        roundBottomLeft: true,
        roundBottomRight: true,
        roundTopLeft: true,
        roundTopRight: true,
        radius: 4.0);
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement(ChartUtil.dateValue, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 24).round());

    canvas.drawText(
        TextElement(ChartUtil.sensorValue, style: textStyle),
        (bounds.left + 36).round(),
        (bounds.top - 4).round());
  }
}

class TripCustomCircleSymbolRenderer extends CircleSymbolRenderer {

  @override
  void paint(ChartCanvas canvas, Rectangle bounds,
      {List dashPattern,
        Color fillColor,
        Color strokeColor,
        double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 100,
            bounds.height + 40),
        fill: Color.black,
        roundBottomLeft: true,
        roundBottomRight: true,
        roundTopLeft: true,
        roundTopRight: true,
        radius: 4.0);
    var textStyle = style.TextStyle();
    textStyle.color = Color.white;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement(ChartUtil.tripDateValue, style: textStyle),
        (bounds.left).round(),
        (bounds.top - 24).round());

    canvas.drawText(
        TextElement(ChartUtil.tripSensorValue, style: textStyle),
        (bounds.left + 28).round(),
        (bounds.top - 4).round());
  }
}

}

double dp(double val, int places) {
  double mod = pow(10.0, places);
  return ((val * mod).round().toDouble() / mod);
}

Future<String>_loadFromAsset() async {
  return await rootBundle.loadString("assets/chart_data.json");
}

Future<List<>> parseJson() async {
  String jsonString = await _loadFromAsset();
  final jsonResponse = jsonDecode(jsonString);
}