String getLevel(int status){
  if (status ==0){
    return "C级";
  }
  if (status ==1){
    return "B级";
  }
  if (status ==2){
    return "A级";
  }
  if (status ==30){
    return "D级";
  }
  if (status ==5){
    return "M级";
  }
  if (status ==-1){
    return "P级";
  }
  return "";
}