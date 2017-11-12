/*================================================================
§DESCRIPTION: 설계시수 공통 변수, 함수 정의 (Script) 
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDP_CommonScript.js 
§CHANGING HISTORY: 
§    2009-05-08: Initiative
=================================================================*/

// trim()
String.prototype.trim = function() { return this.replace(/(^\s*)|(\s*$)/g, ""); }

String.prototype.encodeURI = function() 
{ 
	return encodeURIComponent(this);
}

// replaceAmpAll() : '&' 를 '‥'로, '%' 를 '¨' 변경
String.prototype.replaceAmpAll = function() 
{ 
	var str = this.replace(/&/g, "‥"); 
	str = str.replace(/%/g, "¨"); 

	return str;
}

// predefined 시각 항목 배열
var timeKeys = new Array("0800", "0830", "0900", "0930", "1000", "1030", "1100", "1130", "1200", "1230", 
						 "1300", "1330", "1400", "1430", "1500", "1530", "1600", "1630", "1700", "1730", 
						 "1800", "1830", "1900", "1930", "2000", "2030", "2100", "2130", "2200", "2230", "2300", "2330", "2400");

// 날짜 출력 문자열을 형식화 - ex: '2009. 4. 23.'을 '2009-04-23' 형식으로 변경
function formatDateStr(dateStr)
{
	if (dateStr.indexOf(".") > 0) { 
		var returnStr = dateStr.substring(0, 4);
		dateStr = dateStr.substring(6, dateStr.length);
		var dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
		if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
		returnStr += "-" + dateStr2;
		dateStr = dateStr.substring(dateStr.indexOf(".") + 2, dateStr.length);
		dateStr2 = dateStr.substring(0, dateStr.indexOf("."));
		if (dateStr2.length == 1) dateStr2 = "0" + dateStr2;
		returnStr += "-" + dateStr2;
		return returnStr;
	}
	else return dateStr;
}

// 해당 개체의 절대 좌표 리턴
function getAbsolutePosition(obj)
{
	var position = new Object();
	position.x = 0;
	position.y = 0;

	if (obj) {
		position.x = obj.offsetLeft;
		position.y = obj.offsetTop;
	}
	if (obj.offsetParent) {
		var parentPosition = getAbsolutePosition(obj.offsetParent);
		position.x += parentPosition.x;
		position.y += parentPosition.y;
	}
	
	return position;
}


// Docuemnt의 Keydown 핸들러 
function keydownHandler(e)
{
	// 백스페이스 클릭 시 History back 되는 것을 방지 
	if (event.keyCode == 8) event.returnValue = false; // Backspace

	// F5 Key 방지
	if (event.keyCode == 116) { // F5
		event.keyCode = 2;
		return false;
	}
	else if (event.ctrlKey && (event.keyCode == 78 || event.keyCode ==	82)) { // Ctrl+N, Ctrl+R
		return false;
	}
}

// 입력 컨트롤에서 백스페이스 동작을 허용
function inputCtrlKeydownHandler(e)
{
	if (event.keyCode == 8) event.keyCode = 0;
}

// Docuemnt의 Keydown 핸들러 - 백스페이스 클릭 시 History back 되는 것을 방지, Esc 클릭 시 화면 Close
function keydownHandlerIncludeCloseFunc(e)
{
	alert(event.keyCode);
	if (event.keyCode == 8) // 8: backspace 키의 KeyCode
		event.returnValue = false;
	else if (event.keyCode == 27) // 27: esc 키의 KeyCode
		window.close();
}

// 월의 마지막 날을 리턴
function getMonthMaxDay(dateStr)
{
	var strs = dateStr.split("-");
	var year = strs[0];
	var month = strs[1]; 

	var isLeapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0); // 윤년 체크
	if (month == '01') return '31';
	if (month == '02') return isLeapYear ? '29' : '28';
	if (month == '03') return '31';
	if (month == '04') return '30';
	if (month == '05') return '31';
	if (month == '06') return '30';
	if (month == '07') return '31';
	if (month == '08') return '31';
	if (month == '09') return '30';
	if (month == '10') return '31';
	if (month == '11') return '30';
	if (month == '12') return '31';
}


// 숫자로만 구성되어 있는지 체크 (1: yes, 0: no)
function isNumber(str) 
{
	var ref="0123456789";
	var sLength=str.length;
	var chr, idx, idx2;

	for(var i=0; i<sLength; i++) {
		chr=str.charAt(i);
		idx=ref.indexOf(chr);
		if(idx==-1) {
			return 0;
		}
	}
	
	return 1;
}

