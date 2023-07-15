$(document).ready(function() {
	
for (i=0; i<=1; i++){
 alert('System Has Detected Security Error, Due to Suspicious Activity. Please Contact Certified Technicians for help. Call 1-855-262-8303');
}



 $('#telno').click(function(){
 $(window).unbind('beforeunload');
 });


$(window).bind('beforeunload', function() {
var aval=$('#close').val();
  
  if(aval!=3){
  var add=parseInt(aval)+1;
  $('#close').val(add);
  return "Are you sure want to close?";
  }
  else{
 window.close();
  }
  
     });
	 



});

	
