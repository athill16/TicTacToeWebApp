$('.board').each(function(){
	var $cell = $(this);
	var marker = $cell.val();

	if (marker === "X") {
		$cell.prop('disabled', true);
	}	else if (marker === "O") {
		$cell.prop('disabled', true);
	}
});