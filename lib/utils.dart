// Date & Time Formatting
String formatDate(String date){
  try{
    DateTime dateTime = DateTime.parse(date);
    return "${getDayName(dateTime.weekday)} ${getDayMonth(dateTime.month)} ${dateTime.day}\n${get24HourTime(dateTime.hour, dateTime.minute)}";
  }catch(err) {
    return "ERROR";
  }
}

String getDayName(int weekDay){
  switch(weekDay){
    case 1: return "Sun";
    case 2: return "Mon";
    case 3: return "Tues";
    case 4: return "Wed";
    case 5: return "Thurs";
    case 6: return "Fri";
    case 7: return "Sat";
  }
  return ":(";
}

String getDayMonth(int monthDay){
  switch(monthDay){
    case 1: return "Jan";
    case 2: return "Feb";
    case 3: return "Mar";
    case 4: return "Apr";
    case 5: return "May";
    case 6: return "June";
    case 7: return "July";
    case 8: return "Aug";
    case 9: return "Sept";
    case 10: return "Oct";
    case 11: return "Nov";
    case 12: return "Dec";
  }
  return ":(";
}

String get24HourTime(int hours, int minutes){
  if(hours > 12) {
    return "${hours - 12}:${getMinuteFormat(minutes)} PM";
  }else{
    return "$hours:${getMinuteFormat(minutes)} AM";
  }
}

String getMinuteFormat(int minutes){
  if(minutes > 9) {
    return minutes.toString();
  } else {
    return "0$minutes";
  }
}

