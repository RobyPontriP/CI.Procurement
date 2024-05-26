/*
$(document).on('click', '#zoomBtn', function() {
  $('.zoom-btn-sm').toggleClass('scale-out');
  if (!$('.zoom-card').hasClass('scale-out')) {
    $('.zoom-card').toggleClass('scale-out');
  }
});
*/

$('.zoom-btn-sm').click(function() {
  var btn = $(this);
  var card = $('.zoom-card');

  if ($('.zoom-card').hasClass('scale-out')) {
    $('.zoom-card').toggleClass('scale-out');
  }
  if (btn.hasClass('zoom-btn-person')) {
    card.css('background-color', '#d32f2f');
  } else if (btn.hasClass('zoom-btn-doc')) {
    card.css('background-color', '#fbc02d');
  } else if (btn.hasClass('zoom-btn-tangram')) {
    card.css('background-color', '#388e3c');
  } else if (btn.hasClass('zoom-btn-report')) {
    card.css('background-color', '#1976d2');
  } else {
    card.css('background-color', '#7b1fa2');
  }
});

var zoom_workspace_top = '105px';
if (location.href.toLowerCase().indexOf('blankmode=1') >= 0) {
    //zoom_workspace_top = '0px';
    $('.zoom-workspace').css('top', zoom_workspace_top);

}

window.addEventListener('scroll', function() {
    var scrollPos = window.scrollY || document.body.scrollTop;
    
    if (scrollPos > 105) {
            $('.zoom-workspace').css('position', 'fixed');
            $('.zoom-workspace').css('top', '0');
    } else {
        $('.zoom-workspace').css('position', 'absolute');
        $('.zoom-workspace').css('top', zoom_workspace_top);
    }
});
