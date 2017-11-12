/**
 * button 활성화
 * */
function fn_buttonEnable( arrObj ) {
	for( var i = 0; i < arrObj.length; i++ ) {	
		$( arrObj[i] ).removeAttr( "disabled" );
		$( arrObj[i] ).removeClass( "btn_gray" );
		$( arrObj[i] ).addClass( "btn_blue" );
	}
}

/**
 * button 활성화2
 * */
function fn_buttonEnable2( arrObj ) {
	for( var i = 0; i < arrObj.length; i++ ) {	
		$( arrObj[i] ).removeAttr( "disabled" );
		$( arrObj[i] ).removeClass( "btn_disable" );
		$( arrObj[i] ).addClass( "btn_blue2" );
	}
}

/**
 * button 비활성화
 * */
function fn_buttonDisabled( arrObj ) {
	for( var i = 0; i < arrObj.length; i++ ) {	
		$( arrObj[i] ).attr( "disabled", true );
		$( arrObj[i] ).removeClass( "btn_blue" );
		$( arrObj[i] ).addClass( "btn_gray" );
	}
}

/**
 * button 비활성화2
 * */
function fn_buttonDisabled2( arrObj ) {
	for( var i = 0; i < arrObj.length; i++ ) {	
		$( arrObj[i] ).attr( "disabled", true );
		$( arrObj[i] ).removeClass( "btn_blue2" );
		$( arrObj[i] ).addClass( "btn_disable" );
	}
}

/**
 * button 활성화
 * */
function fn_buttonClassEnable( className ) {
	$( '.' + className ).each( function( index ) {
		var input = $(this);
//		input.attr("class", input.attr("class") + " readonly");
//		input.attr("readonly", "readonly");	
		
		input.removeAttr( "disabled" );
		input.removeClass( "btn_gray" );
		input.addClass( "btn_blue" );
	} );
	
	
	
//	$( ".only_bom" ).prop('disabled', false );
//	
//	for( var i = 0; i < arrObj.length; i++ ) {	
//		$( arrObj[i] ).removeAttr( "disabled" );
//		$( arrObj[i] ).removeClass( "btn_gray" );
//		$( arrObj[i] ).addClass( "btn_blue" );
//	}
}

/**
 * button 비활성화
 * */
function fn_buttonClassDisabled( className ) {
	$( '.' + className ).each( function( index ) {
		var input = $(this);
//		input.attr("class", input.attr("class") + " readonly");
//		input.attr("readonly", "readonly");	

		input.attr( "disabled", true );
		input.removeClass( "btn_blue" );
		input.addClass( "btn_gray" );
	} );
	
//	$( ".only_bom" ).prop('disabled', true );
//	
//	for( var i = 0; i < arrObj.length; i++ ) {	
//		$( arrObj[i] ).attr( "disabled", true );
//		$( arrObj[i] ).removeClass( "btn_blue" );
//		$( arrObj[i] ).addClass( "btn_gray" );
//	}
}