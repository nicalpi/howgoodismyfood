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

  //Home search display default text and toggle display
  var home_input = $("#homepage #search input[type='text']");
  home_input.val("Enter your product barcode");
  home_input.addClass('inactive');
  home_input.focus(function(){
      home_input.addClass('active');
      home_input.removeClass('inactive');
      if ($(this).val() == "Enter your product barcode"){
        $(this).val("");
      }
      });


  home_input.blur(function(){
      if($(this).val() == "Enter your product barcode")
      {
      $(this).addClass('inactive')
      $(this).removeClass('active');
      }
      if($(this).val() == ""){
        $(this).addClass('inactive')
        $(this).removeClass('active');
        $(this).val("Enter your product barcode");
      }
      });
});


