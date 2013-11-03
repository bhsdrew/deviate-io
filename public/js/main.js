Zepto(function($){
 	$(".menu.circle-logo").click(function(e){
 		if(!$(this).hasClass('open')){
			$(this).addClass('open');
 			$("#wrap").addClass('open');
 			$("#back-panel").addClass('open');
 			$("body").addClass('background');
 			e.stopPropagation();
 		}
 		else{
 			$(this).removeClass('open');
 			$("#wrap.open").removeClass('open');
 		}
 	});

 	$("#wrap").click(function() {
 		if($(this).hasClass('open')){
 			$(this).removeClass('open');
 			$(".menu.circle-logo.open").removeClass('open');
	 	}
 	});
})