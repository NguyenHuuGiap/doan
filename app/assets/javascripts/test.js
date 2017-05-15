// if(localStorage.getItem("counter")){
//   if(localStorage.getItem("counter") <= 0){
//     var value = 10;
//   }else{
//     var value = localStorage.getItem("counter");
//   }
// }else{
//   var value = 0;
// }

// if(localStorage.getItem("hours")){
//   console.log(localStorage.getItem("hours"));
//   if(localStorage.getItem("hours") <= 0 && localStorage.getItem("counter") <= 0){
//     var hours = 1;
//   }
//   else if(localStorage.getItem("hours") <= 0 && localStorage.getItem("counter") > 0 ){
//     var hours = localStorage.getItem("hours");
//   }
//   else{
//     var hours = localStorage.getItem("hours");
//   }
// }else{
//   var hours = 0;
// }

// time = hours + ' : ' + value;
// $('#divCounter').html(time);

// var counter = function (){
//   if(value <= 0){
//     if( hours <= 0){
//       localStorage.setItem("counter", 0);
//       value = 0;
//       localStorage.setItem("hours", 0);
//       hours = 0;
//       $('form#test_form').submit();
//     }
//     else{
//       hours = parseInt(hours)-1;
//       localStorage.setItem("hours", hours);
//       localStorage.setItem("counter", 10);
//       value = 10;
//     }
//   }else{
//     value = parseInt(value)-1;
//     localStorage.setItem("counter", value);
//     localStorage.setItem("hours", hours);
//   }
//   time = hours + ' : ' + value;
//   $('#divCounter').html(time);
// };

// var interval = setInterval(function (){counter();}, 1000);

