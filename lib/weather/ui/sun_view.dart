import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bean/he_weather.dart';
import 'package:flutter_app/custom_widgets/sunrise_sunset_view.dart';
import 'package:flutter_app/service/api_service.dart';
import 'package:flutter_app/ui/line.dart';
import 'package:common_utils/common_utils.dart';

class SunView extends StatefulWidget {
  final String cityname;

  SunView(this.cityname, {Key key}) : super(key: key);

  @override
  createState() => _SunViewState();
}

class _SunViewState extends State<SunView>
    with AutomaticKeepAliveClientMixin<SunView> {
  @override
  bool get wantKeepAlive => true;

  HeWeather weather;
  SunriseSunset sunrise_sunset = null;

  int totalMin = 0;
  int progressMin = 0;

  @override
  void initState() {
    super.initState();

    getSunData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      color: Color(0x2a000000),
      padding: EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('日出日落', style: TextStyle(color: Colors.white)),
            Line(),
            Container(
                height: 160,
                child: sunrise_sunset == null
                    ? Center()
                    : SunriseSunsetView(
                        progress: totalMin == 0 ? 0 : progressMin / totalMin),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10)),
            Row(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FeatherIcons.sunrise, color: Colors.white),
                    Text('日出${sunrise_sunset?.sr}',
                        style: TextStyle(color: Colors.white))
                  ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(FeatherIcons.sunset, color: Colors.white),
                    Text('日落${sunrise_sunset?.ss}',
                        style: TextStyle(color: Colors.white))
                  ]),
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
          ]),
    );
  }

  void getSunData() async {
    weather = await ApiService.getSunriseSunset(widget.cityname);

    setState(() {
      sunrise_sunset = weather.sunrise_sunset[0];

      String nowTime = DateUtil.getDateStrByDateTime(DateTime.now(),
          format: DateFormat.HOUR_MINUTE);

      /// 当前时间
      int currentHour = int.parse('${nowTime.substring(0, 2)}');
      int currentMin = int.parse('${nowTime.substring(3)}');

      /// 日落
      int ssHour = int.parse('${sunrise_sunset?.ss.substring(0, 2)}');
      int ssMin = int.parse('${sunrise_sunset?.ss.substring(3)}');

      /// 日出
      int srHour = int.parse('${sunrise_sunset?.sr.substring(0, 2)}');
      int srMin = int.parse('${sunrise_sunset?.sr.substring(3)}');

      /// 日出到日落间的总时间（分钟）
      totalMin = (ssHour - srHour) * 60 + (ssMin - srMin);

      if (currentHour - ssHour > 0 && currentMin - ssMin > 0) {
        /// 当前时间太阳已经下山
        progressMin = totalMin;
      } else if (currentHour - srHour < 0 && currentMin - srMin < 0) {
        /// 太阳还未升起
        progressMin = 0;
      } else {
        /// 太阳已经升起
        progressMin = (currentHour - srHour) * 60 + (currentMin - srMin);
      }
    });
  }
}
