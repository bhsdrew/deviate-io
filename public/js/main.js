Zepto(function($){

  //init menu
 	$(".menu.circle-logo").click(function(e){
 		openMenu(e,this);
 	});

 	$("#wrap").click(function(e) {
 		closeMenu(e,this);
 	});

 	function closeMenu(e,elem){
 		if($(this).hasClass('open')){
 			$(this).removeClass('open');
 			$(".menu.circle-logo.open").removeClass('open');
	 	}
 	}

 	function openMenu(e,elem){
 		if(!$(elem).hasClass('open')){
			$(elem).addClass('open');
 			$("#wrap").addClass('open');
 			$("#back-panel").addClass('open');
 			e.stopPropagation();
 		}
 		else{
 			$(elem).removeClass('open');
 			$("#wrap.open").removeClass('open');
 		}
 	}


  //init bigfoot
  $.bigfoot();

})