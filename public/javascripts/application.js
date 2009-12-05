jQuery(document).ready(function(){

  $("input[type='radio'][name='product[kind]']").click(function(){
    if($(this).val() == "food") {
      //Type is food so the unit needs to be gr
      $(".per").each(function(){
        $(this).html($(this).html().replace(/ml/,"g"));  
      });
    }
    else{
      //Type is drink so the unit needs to be ml
      $(".per").each(function(){
        $(this).html($(this).html().replace(/g/,"ml"));  
      });
    }
    
    
  });

});


