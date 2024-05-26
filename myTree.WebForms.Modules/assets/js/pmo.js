function gototag(tag_name) {
	$('html,body').animate({scrollTop: $("#"+tag_name).offset().top-100},'medium');
}

$(function () {
	$('.click-nav > ul').toggleClass('no-js js');
	$('.click-nav .js ul').hide();
	
	$(document).on('click', '.clicker', function(e) {
		var myID = $(this).attr('rel');
		
		$('.pmo-'+myID+'-ph .js ul').slideToggle(200);
		$('.pmo-'+myID+'-link').removeClass('active');			
		$('.pmo-'+myID+'-ph > ul > li > a').toggleClass('arrowup arrowdown');
		
		e.stopPropagation();
	});
	
	$(document).on('click', '.gotolink', function() {
		gototag($(this).attr('rel'));
	});
});