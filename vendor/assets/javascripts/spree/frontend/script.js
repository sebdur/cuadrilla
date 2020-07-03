document.addEventListener('turbolinks:load', function(){

  $(window).on('turbolinks:load', function(){
   $("#loadPage").delay(300).fadeOut("slow");
  });

  $(window).scroll(function() {
    if ($(this).scrollTop() > 500) {
      $('#toTop').fadeIn();
    } else {
      $('#toTop').fadeOut();
    }
  });

  $("#toTop").click(function() {
    $("html, body").animate({scrollTop: 0}, 1000);
  });

});
