$("#slideshow > img:gt(0)").hide();

setInterval(function() {
  $('#slideshow > img:first-child')
    .next('img')
    .end()
    .appendTo('#slideshow');
},  9000);
