jQuery(document).ready(function(){

  $("input[type='radio'][name='product[kind]']").click(function(){
    if($(this).val() == "food") {
      //Type is food so the unit needs to be gr
      $(".per").each(function(){
        $(this).html($(this).html().replace(/100ml/,"100g"));  
        $(this).html($(this).html().replace(/in ml/,"in g"));
        
      });
    }
    else{
      //Type is drink so the unit needs to be ml
      $(".per").each(function(){
        $(this).html($(this).html().replace(/100g/,"100ml"));  
        $(this).html($(this).html().replace(/in g/,"in ml"));
      });
    }
    
    added_sugar_test();
  });

  if($("#product_kind_drink").is(':checked')){
    
      $(".per").each(function(){
        $(this).html($(this).html().replace(/100g/,"100ml"));  
        $(this).html($(this).html().replace(/in g/,"in ml"));
      });
  }
  added_sugar_test();

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

  $('#product_sugar').keyup(function(){
    added_sugar_test();
  });
});

function added_sugar_test(){

    if(($("#product_sugar").val() > 5 && $("#product_kind_food").is(':checked')) || ($("#product_sugar").val()>2.5 && $("#product_kind_drink").is(':checked'))){
      $(".added_sugar").show();
    }
    else
    {
      $(".added_sugar").hide();
    }
  }



