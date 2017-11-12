/*================================================================
��DESCRIPTION: Ajax ó������ ���� ��ũ��Ʈ �Լ� ����
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDP_GeneralAjaxScript.js
��CHANGING HISTORY: 
��    2009-06-04: Initiative
=================================================================*/

	/* stxPECDP_CommonScript.js Required! */


	// �ش������� ���Ͽ���(����,����,4H)�� �����Ͽ� ����
	function getWorkingDayYN(dateStr)
	{
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetWorkingDayYN&dateStr=" + dateStr, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null) return resultMsg.trim();
        } 
		return "ERROR";
	}

	// �ش������� ���Ͽ��θ� �����Ͽ� �ѱ�ǥ������ ��ȯ�� ��(���ڿ�)���� ����
	function getWorkingDayYNString(dateStr)
	{
		var workingDayYN = getWorkingDayYN(dateStr);

        if (workingDayYN == 'Y') return  "����";
        else if (workingDayYN == 'N') return "����";
        else return workingDayYN;
	}

	// Ajax ���ν��� ȣ���ϴ� ���� �޼ҵ�(�Ķ���� 1 �� Only)
	function callDPCommonAjaxProc(procName, paramName, paramValue)
	{
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=" + procName + "&" + paramName + "=" + paramValue, false);
		xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            var resultMsg = xmlHttp.responseText;            
            if (resultMsg != null) return resultMsg.trim();
        } 
		return "ERROR";
	}

	// DP ���� Post ������� Ajax ���ν��� ȣ���ϴ� ���� �޼ҵ�
	function callDPCommonAjaxPostProc(procName, params)
	{
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // POST ��� ����
        xmlHttp.open("POST", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=" + procName , false);
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

	// DP ���� Post ������� Ajax ���ν��� ȣ���ϴ� ���� �޼ҵ�
	function callDPCommonAjaxPostProc2(procName, params)
	{
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        // POST ��� ����
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

	// ȣ�� + ���鿡 ���� �⵵���� ��ȸ
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

    // �ش� ������ ����/���� ���ο� ���翩�� ���� �����Ͽ� ����� ����
    function getDateDPInfo(dpDesignerID, dateSelected)
    {
        var xmlHttp;
		if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        var urlStr = "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetWorkingDayInfoAndConfirmYN";
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

    // ��� + �Ⱓ�� ����Ϸ�� �Է½ü��� �����ϴ��� ����
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
