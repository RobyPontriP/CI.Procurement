$(function () {	
	$(document).on('click', '.dropdown-toggle', function(e) {
		//$(".btn-group").each(function(){
			//$(this).removeClass('open');
		//})
		var parentDiv = $(this).parent();
		
		if(!$(parentDiv).hasClass('open')){
			$(parentDiv).addClass('open');
		}
		else{
			$(parentDiv).removeClass('open');
		}
		e.stopPropagation();
	});
});