String getDate(DateTime dt){
  List months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[dt.month - 1] + " " + dt.day.toString() + ", " + dt.year.toString(); 
}