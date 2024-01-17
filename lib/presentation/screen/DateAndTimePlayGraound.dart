
import 'package:flutter/material.dart';
import 'package:nadek/presentation/screen/DetailsPlaygroundScreen.dart';
import 'package:nadek/sheard/style/ColorApp.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_range/time_range.dart';

class DateAndTimePlayGraound extends StatefulWidget {
  int play_ground_id;
   DateAndTimePlayGraound({super.key,required this.play_ground_id});

  @override
  State<DateAndTimePlayGraound> createState() => _DateAndTimePlayGraoundState();
}

class _DateAndTimePlayGraoundState extends State<DateAndTimePlayGraound> {
//  DetailsPlaygroundScreen(play_ground_id: d[index].iD!,)

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? day;
  String? month;
  String? year;
  @override
  void initState() {
    // TODO: implement initState
    day  =_focusedDay.day.toString();
    month=_focusedDay.month.toString();
    year =_focusedDay.year.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.black_400,

      appBar:  AppBar(
        elevation: 0,
        backgroundColor: ColorApp.black_400,
        title: const Text('حجز الملعب ',),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Container(
                width: double.infinity,
                  child: const Text('اختيار تاريخ الحجز',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18, color: Colors.white
                    ),
                  )
              ),
            ),
            TableCalendar(
              daysOfWeekHeight: 20,

              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                    color: Colors.white
                ),
                weekendStyle:  TextStyle(
                    color: Colors.white
                ),
              ),
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              locale:'ar_EG',
              headerVisible: false,
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                outsideDecoration:  BoxDecoration(
                  color: ColorApp.selver300,
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle

                ),
                disabledTextStyle: const TextStyle(
                    color: Colors.white
                ),
                rangeHighlightColor: Colors.white,
                defaultTextStyle: const TextStyle(
                  color: Colors.white
                ),
                todayDecoration: BoxDecoration(
                  color: ColorApp.darkRead,
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle
                ) ,
                disabledDecoration:  BoxDecoration(
                    color: ColorApp.darkRead,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),

                ),
                selectedDecoration: BoxDecoration(
                  color: ColorApp.darkRead,
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle

                ),
                defaultDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 2,color: ColorApp.darkRead),
                   shape: BoxShape.rectangle

                )
              ),
              selectedDayPredicate: (day) {

                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onHeaderTapped: (DateTime){
                setState(() {
                  _selectedDay = DateTime;
                  _focusedDay = DateTime;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {

                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  print('${focusedDay!.year} ${focusedDay!.month}  ${focusedDay!.day}');

                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    year =focusedDay.year.toString();
                    month =focusedDay.month.toString();
                    day =focusedDay.day.toString();
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here

                _focusedDay = focusedDay;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8),
              child: Container(
                  width: double.infinity,
                  child: const Text('اختيار وقت الحجز',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18, color: Colors.white
                    ),
                  )
              ),
            ),

            TimeRange(
              fromTitle: Padding(
                padding: const EdgeInsets.only(left: 8,right: 8),
                child: Container(
                  width: double.infinity,
                  child: const Text('من',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              toTitle: Padding(
                padding: const  EdgeInsets.only(left: 8,right: 8),
                child: Container(
                  width: double.infinity,
                  child: const Text('الي',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              titlePadding: 10,
              textStyle: const TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
              activeTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              borderColor: ColorApp.darkRead,
              backgroundColor: Colors.transparent,
              activeBorderColor: Colors.transparent,
              activeBackgroundColor: ColorApp.darkRead,
              firstTime: TimeOfDay(hour: 1, minute: 00),
              lastTime: TimeOfDay(hour: 23, minute: 00),
              timeStep: 60,
              timeBlock: 60,
              onRangeCompleted: (range) => setState(() => print(range!.start)),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                print( '$year-$month-$day');
                Navigator.push(context, MaterialPageRoute(
                    builder: (builder)=>DetailsPlaygroundScreen(
                        play_ground_id: widget.play_ground_id,
                        date: '$year-$month-$day'
                    )
                ));
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: ColorApp.darkRead,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(child: Text("عرض التفاصيل",style: TextStyle(color: Colors.white),)),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
