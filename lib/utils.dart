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