<%--  
§DESCRIPTION: 설계시수결재 - 시수 입력율 조회 화면 Header Toolbar 부분
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDPApproval_InputRateViewHeader.jsp
§CHANGING HISTORY: 
§    2009-04-09: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>

<%--========================== JSP =========================================--%>
<%
%>

<%--========================== HTML HEAD ===================================--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>시수입력율 조회</title>
</head>
<link rel=StyleSheet HREF="/AddOn/DP/stxPECDP.css" type=text/css title=stxPECDP_css>
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="/js/stxPECDP_CommonScript.js"></script>

<script language="javascript">
</script>

<%--========================== HTML BODY ===================================--%>
<body>
<form name="DPInputRateViewHeader">

    <table class="searchArea conSearch">
        <tr>
        	<th>일자</th>
            <td><input style="width:0px;border:0;" readonly="readonly">
                <input type="text" name="dateSelectedFrom" id="dateSelectedFrom" value="" class="input_small" style="width:70px;" readonly="readonly">
                
                    &nbsp;~&nbsp;
                <input type="text" name="dateSelectedTo" id="dateSelectedTo" value="" class="input_small" style="width:70px;" readonly="readonly">
                
            </td>
            <td style="text-align:right; padding-right:10px;">
                <input type="button" class="btn_blue" name="viewButton" value="조 회" onclick="viewInputRateList();" />
                <input type="button" class="btn_blue" name="printButton" value="출 력" onclick="viewReport();" />
                <input type="button" value="확 인" class="btn_blue" onclick="javascript:window.close();">
            </td>
        </tr>
	</table>
	<table class="searchArea2">
        <tr>
            <td>
                <input type="radio" name="selectRate" value="all" id="selectRate1" /><label for="selectRate1">전 체&nbsp;&nbsp;</label>
                <input type="radio" name="selectRate" value="under100" checked id="selectRate2" /><label for="selectRate2">입력율 < 100</label>
            </td>
        </tr>
    </table>
    <iframe id="DP_RATE_MAIN" src="" frameborder=0 marginwidth=0 marginheight=0 width=100% height=310px style=""></iframe>
</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="javascript">    
//달력 초기화 설정
$(function() {
	$("#dateSelectedFrom").datepicker({
		dateFormat : 'yy-mm-dd',
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],

		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		showMonthAfterYear : true, //년 뒤에 월 표시
	});
	$("#dateSelectedTo").datepicker({
		dateFormat : 'yy-mm-dd',
		monthNamesShort : [ '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월' ],
		dayNamesMin : [ '일', '월', '화', '수', '목', '금', '토' ],

		changeMonth : true, //월변경가능
		changeYear : true, //년변경가능
		showMonthAfterYear : true, //년 뒤에 월 표시
	});
});
    var deptCode = (window.dialogArguments).deptCode;
    var deptName = (window.dialogArguments).deptName;

    // 칼렌다를 통해 날짜변경 시 날짜 출력 문자열을 형식화
    function dateChanged()
    {
        var tmpStr1 = DPInputRateViewHeader.dateSelectedFrom.value;
        if (tmpStr1.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedFrom.value = formatDateStr(tmpStr1);
        }
        var tmpStr2 = DPInputRateViewHeader.dateSelectedTo.value;
        if (tmpStr2.indexOf('.') >= 0) {
            DPInputRateViewHeader.dateSelectedTo.value = formatDateStr(tmpStr2);
        }
    }

    // From 날짜 변경 시 To 날짜는 해당 월 말일로 자동 변경
    function dateChangedFrom()
    {
        dateChanged();

        var tmpStr = DPInputRateViewHeader.dateSelectedFrom.value;
        var maxDay = getMonthMaxDay(tmpStr);
        var tmpStrs = tmpStr.split("-");
        DPInputRateViewHeader.dateSelectedTo.value = tmpStrs[0] + "-" + tmpStrs[1] + "-" + maxDay;

    }

    // 입력율조회 실행 - 메인화면(Content 화면)을 로드한다
    function viewInputRateList()
    {
        var urlStr = "stxPECDPApproval_InputRateViewMain.do";
        urlStr += "?deptCode=" + deptCode;
        urlStr += "&deptName=" + escape(encodeURIComponent(deptName));
        urlStr += "&fromDate=" + DPInputRateViewHeader.dateSelectedFrom.value;
        urlStr += "&toDate=" + DPInputRateViewHeader.dateSelectedTo.value;
        urlStr += "&selectRate=";
        urlStr += DPInputRateViewHeader.selectRate[0].checked  ? "all" : "under100";

        /* parent.DP_RATE_MAIN.location = urlStr; */
        $("#DP_RATE_MAIN").attr("src", urlStr);
    }

    // 프린트(리포트 출력)
    function viewReport()
    {
        var paramStr = deptCode + ":::" + 
                       DPInputRateViewHeader.dateSelectedFrom.value + ":::" + 
                       DPInputRateViewHeader.dateSelectedTo.value + ":::";
        paramStr += DPInputRateViewHeader.selectRate[1].checked  ? "Y" : "";
                       
        var urlStr = "http://172.16.2.13:7777/j2ee/STXDP/WebReport.jsp?src=http://172.16.2.13:7777/j2ee/STXDP/mrd/stxPECDPApproval_InputRatesView.mrd&param=" + paramStr;
        window.open(urlStr, "", "");
    }

    /* 화면(기능)이 실행되면 초기 상태를 해당 월 1일 ~ 오늘 기준으로 설정 */   
    // 오늘 날짜
    var today = new Date();
    var y1 = today.getFullYear().toString();
    var m1 = (today.getMonth() + 1).toString();
    if (m1.length == 1) m1 = 0 + m1;
    var d1 = today.getDate().toString();
    if (d1.length == 1) d1 = 0 + d1;
    var toYMD = y1 + "-" + m1 + "-" + d1;
    // 해당 월 1일
    var fromYMD = y1 + "-" + m1 + "-01";    
    // 초기 From, To 날짜 설정
    DPInputRateViewHeader.dateSelectedTo.value = toYMD;
    DPInputRateViewHeader.dateSelectedFrom.value = fromYMD;

    // 조회 창을 로드
    viewInputRateList();

</script>


</html>