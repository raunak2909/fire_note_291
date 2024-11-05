import 'dart:io';

void main(){

  /*List<String> vowels = ["a","i", "o", "e", "u"];

  if(vowels.contains(value.toLowerCase().toString())){

  }
*/
  List<int> mNo = [2,3,4,5,6,7,8,9,10];


    for(int i = 1; i<=10; i++){
      for(int j=0; j<=mNo.length-1; j++){
        stdout.write("${mNo[j]} x $i = ${mNo[j]*i}\t");
      }
      stdout.write("\n");
    }

}