//숫자만 입력 받기
function numbersonly(e, decimal) {
    var key;
    var keychar;

    if (window.event) {
        key = window.event.keyCode;
    } else if (e) {
        key = e.which;
    } else {
        return true;
    }
    keychar = String.fromCharCode(key);

    if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) {
        return true;
    } else if ((("0123456789").indexOf(keychar) > -1)) {
        return true;
    } else if (decimal && (keychar == ".")) {
        return true;
    } else
        return false;
}


function  handlerNum(){
 E = window.event;
 if(E.keyCode >47 && E.keyCode <58){   
  if(E.keyCode == 48){
   if(document.eduReg.ATTENDANT.value == "" ) E.returnValue=false;
   else return;
   }else return; 
 }else{
  E.returnValue=false;
 }
}


//특수기호 제거
var inputCheckSpecialChar = function(obj){
	var ft = "true";
	
	var strobj = $(obj).val(); //입력값을 담을변수.
	re = /[~!@\#$%<>^&*\()\-=+_\']/gi;
	
	if(re.test(strobj)){
		alert("특수문자는 입력하실수 없습니다.");
		$(obj).val(strobj.replace(re,""));
		$(obj).focus();
		return false;
	}else {
		return true;
	}
}

//lpad('txt', 8, '0');                        // 00000txt
function lpad(str, num, chr) {    

    if (! str || ! chr || str.length >= num) {

        return str;

    }

    var max = num - str.length;

    for (var i = 0; i < max; i++) {

        str = chr + str;

    }

    return str;
}

function rpad(str, num, chr) {  

    if (! str || ! chr || str.length >= num) {

        return str;

    }

    var max = num - str.length;

    for (var i = 0; i < max; i++) {

        str += chr;

    }

    return str;
}

/**
 * input 검색조건 upper 처리
 * */
function fn_all_text_upper() {
	$( "input[type=text]" ).change( function() {
		$(this).val( $(this).val().toUpperCase() );
	} );
}

function fn_only_num_input() {
	$( ".only_num_input" ).numeric();
}

//window.onkeydown = function() {
//	var kcode = event.keyCode;
//	if(kcode == 116) event.returnValue = false;
//};


//참고 http://wowmotty.blogspot.kr/2010/05/jquery-selectors-adding-contains-exact.html
$.extend( $.expr[":"], {
	containsExact : $.expr.createPseudo ? $.expr.createPseudo( function( text ) {
		return function( elem ) {
			return $.trim( elem.innerHTML.toLowerCase() ) === text.toLowerCase();
		};
	} ) :
	// support: jQuery <1.8
	function( elem, i, match ) {
		return $.trim( elem.innerHTML.toLowerCase() ) === match[3].toLowerCase();
	},
	containsExactCase : $.expr.createPseudo ? $.expr.createPseudo( function( text ) {
		return function( elem ) {
			return $.trim( elem.innerHTML ) === text;
		};
	} ) :
	// support: jQuery <1.8
	function( elem, i, match ) {
		return $.trim( elem.innerHTML ) === match[3];
	},
	containsRegex : $.expr.createPseudo ? $.expr.createPseudo( function( text ) {
		var reg = /^\/((?:\\\/|[^\/]) )\/([mig]{0,3})$/.exec( text );
		return function( elem ) {
			return RegExp( reg[1], reg[2] ).test( $.trim( elem.innerHTML ) );
		};
	} ) :
	// support: jQuery <1.8
	function( elem, i, match ) {
		var reg = /^\/((?:\\\/|[^\/]) )\/([mig]{0,3})$/.exec( match[3] );
		return RegExp( reg[1], reg[2] ).test( $.trim( elem.innerHTML ) );
	}
} );