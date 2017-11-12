/*================================================================
§DESCRIPTION: Ajax 처리관련 공통 스크립트 함수 정의
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDP_GeneralAjaxScript.js
§CHANGING HISTORY: 
§    2009-06-04: Initiative
=================================================================*/

	/* stxPECDP_CommonScript.js Required! */


	// 해당일자의 휴일여부(평일,휴일,4H)를 쿼리하여 리턴
	function getWorkingDayYN(dateStr)
	{
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=GetWorkingDayYN&dateStr=" + dateStr, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null) return resultMsg.trim();
        } 
		return "ERROR";
	}

	// 해당일자의 휴일여부를 쿼리하여 한글표현으로 변환된 값(문자열)으로 리턴
	function getWorkingDayYNString(dateStr)
	{
		var workingDayYN = getWorkingDayYN(dateStr);

        if (workingDayYN == 'Y') return  "평일";
        else if (workingDayYN == 'N') return "휴일";
        else return workingDayYN;
	}

	// Ajax 프로시저 호출하는 공통 메소드(파라미터 1 개 Only)
	function callDPCommonAjaxProc(procName, paramName, paramValue)
	{
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=" + procName + "&" + paramName + "=" + paramValue, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null) return resultMsg.trim();
        } 
		return "ERROR";
	}

	// DP 관련 Post 방식으로 Ajax 프로시저 호출하는 공통 메소드
	function callDPCommonAjaxPostProc(procName, params)
	{
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // POST 방식 전송
        xmlHttp.open("POST", "stxPECDP_GeneralAjaxProcess.do?requestProc=" + procName , false);
        xmlHttp.setRequestHeader("Accept-Language", "ko");
        xmlHttp.setRequestHeader("Accept-Encoding", "gzip, deflate");
        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        xmlHttp.setRequestHeader("Content-length", params.length);
        xmlHttp.setRequestHeader("Connection", "close");
        xmlHttp.send(params);

        if (xmlHttp.status == 200 && xmlHttp.statusText == "OK") {
            var resultMsg = xmlHttp.responseText;
            if (resultMsg != null && resultMsg.trim() != "ERROR") return "Y";
        }
		return "N";
	}

	// DP 관련 Post 방식으로 Ajax 프로시저 호출하는 공통 메소드
	function callDPCommonAjaxPostProc2(procName, params)
	{
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // POST 방식 전송
        xmlHttp.open("POST", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=" + procName , false);
        xmlHttp.setRequestHeader("Accept-Language", "ko");
        xmlHttp.setRequestHeader("Accept-Encoding", "gzip, deflate");
        xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        xmlHttp.setRequestHeader("Content-length", params.length);
        xmlHttp.setRequestHeader("Connection", "close");
        xmlHttp.send(params);

        if (xmlHttp.status == 200 && xmlHttp.statusText == "OK") {
            var resultMsg = xmlHttp.responseText;
            if (resultMsg != null && resultMsg.trim() != "ERROR") return "Y|" + resultMsg.trim();
        }
		return "N";
	}

	// 호선 + 도면에 대한 출도일자 조회
	function getDrawingWorkStartDate(projectNo, drawingNo)
	{
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        var paramStr = "requestProc=GetDrawingWorkStartDate&projectNo=" + projectNo + "&drawingNo=" + drawingNo;
		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?" + paramStr, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null) return resultMsg.trim();
        } 
		return "ERROR";
	}

    // 해당 일자의 평일/휴일 여부와 결재여부 등을 쿼리하여 결과를 리턴
    function getDateDPInfo(dpDesignerID, dateSelected)
    {
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        var urlStr = "stxPECDP_GeneralAjaxProcess.do?requestProc=GetWorkingDayInfoAndConfirmYN";
		xmlHttp.open("GET", urlStr + "&dpDesignerID=" + dpDesignerID + "&dateStr=" + dateSelected, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;                
                if (resultMsg != null) return resultMsg.trim();
                else return "ERROR";
            }
            else return "ERROR";
        }
        else return "ERROR";
    }

    // 사번 + 기간에 결재완료된 입력시수가 존재하는지 쿼리
    function getDesignMHConfirmExist(dpDesignerID, fromDate, toDate)
    {
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        var urlStr = "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDesignMHConfirmExist";
		xmlHttp.open("GET", urlStr + "&dpDesignerID=" + dpDesignerID + "&fromDate=" + fromDate + "&toDate=" + toDate, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;                
                if (resultMsg != null) return resultMsg.trim();
                else return "ERROR";
            }
            else return "ERROR";
        }
        else return "ERROR";
    }
