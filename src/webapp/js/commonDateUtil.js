//일주일 단위로 초기 셋팅
function fn_weekDate( date_start, date_end ) {
	var url = 'selectWeekList.do';

	$.post( url, "", function( data ) {
		$( "#" + date_start ).val( data.created_date_start );
	  	$( "#" + date_end ).val( data.created_date_end );
	}, "json" );
}

function fn_toDate( to_date ) {
	var url = 'selectWeekList.do';

	$.post( url, "", function( data ) {
		$( "#" + to_date ).val( data.created_date_end );
	}, "json" );
}

function fn_addDate( to_date, chk_date, add_day ) {
	var url = 'selectAddDay.do?'+"add_day="+add_day;

	$.post( url, "", function( data ) {
		$( "#" + to_date ).val( data.add_date);
		$( "#" + chk_date ).val( data.add_date_val );
	}, "json" );
}

function fn_monthDate(date_start,date_end){
	var url = 'selectWeekList.do';
	$.post( url, "", function( data ) {
		$( "#" + date_start ).val( data.created_date_end );
		var to_date_ary = data.created_date_end.split("-");
		$( "#" + date_end ).val(to_date_ary[0]+"-"+to_date_ary[1]+"-"+( new Date( to_date_ary[0], to_date_ary[1], 0) ).getDate());
	}, "json" );
}

function fn_twoMonthDate(date_start,date_end){
	var url = 'selectWeekList.do';
	$.post( url, "", function( data ) {
		
		// 두달전 날짜
		var prevDate = new Date(new Date().setMonth(new Date().getMonth()-2)); 
		var prevMon = dateToYYYYMMDD(prevDate);
		$( "#" + date_start ).val( prevMon );
		$( "#" + date_end ).val( data.created_date_end );
	}, "json" );
}

function dateToYYYYMMDD(date) {
    return date.getFullYear() + '-' + pad(date.getMonth()+1) + '-' + pad(date.getDate());
}

function pad(num) {
    num = num + '';
    return num.length < 2 ? '0' + num : num;
}

function fn_lastMonthDate(date_start,date_end){
	var to_date_ary = null; 
	if( $( "#" + date_start ).val() == ""){
		var date = new Date();
		var firstDayOfMonth = new Date( date.getFullYear(), date.getMonth() , 1 );
		var lastMonth = new Date ( firstDayOfMonth.setDate( firstDayOfMonth.getDate() -1 ) );
		var chan_val = lastMonth.getFullYear() + "-" + (lastMonth.getMonth()+1)+"-01";
	    to_date_ary = chan_val.split("-");
	}
	else {
		to_date_ary = $( "#" + date_start ).val().split("-");
	}
	$( "#" + date_start ).val( to_date_ary[0]+"-"+to_date_ary[1]+"-"+"01" );
	$( "#" + date_end ).val(to_date_ary[0]+"-"+to_date_ary[1]+"-"+( new Date( to_date_ary[0], to_date_ary[1], 0) ).getDate());
}