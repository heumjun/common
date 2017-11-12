<%--  
§DESCRIPTION: 담당자 변경
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentReceiveChangeProcesser.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%--========================== JSP =========================================--%>

<%!
	// 하나의 수신문서에 대한 타부서 정보를 얻어옴.
	private ArrayList getRevNoDept(String rev_no, String team_name) throws Exception
	{
		if (StringUtil.isNullString(rev_no)) throw new Exception("Rev No. is null");

		java.sql.Connection conn = null;
		java.sql.Statement stmt = null;
		java.sql.ResultSet rset = null;

        ArrayList resultArrayList = new ArrayList();

        try {
			conn = DBConnect.getDBConnection("SDPS");
            StringBuffer queryStr = new StringBuffer();
            queryStr.append("SELECT SEND_RECEIVE_DEPT                                     \n"); 
            queryStr.append("  FROM STX_OC_RECEIVE_DOCUMENT                                \n");
            queryStr.append("  WHERE 1=1                                                   \n");
            queryStr.append("    AND REV_NO = '" + rev_no + "'                             \n");
		if(!"".equals(team_name))
			queryStr.append("    AND SEND_RECEIVE_DEPT NOT LIKE '" + team_name + "%'       \n");

            stmt = conn.createStatement();
            rset = stmt.executeQuery(queryStr.toString());

			while (rset.next())
            {
				java.util.HashMap resultMap = new java.util.HashMap();
				resultMap.put("SEND_RECEIVE_DEPT", rset.getString(1) == null ? "" : rset.getString(1));
				resultArrayList.add(resultMap);
            }
        } catch( Exception ex ) {
            ex.printStackTrace();
        }finally{
            try {
                if ( rset != null ) rset.close();
                if ( stmt != null ) stmt.close();
                DBConnect.closeConnection( conn );
            } catch( Exception ex ) { }
        }
        return resultArrayList;
    }
%>

<%

String sSelect_seq_no = StringUtil.setEmptyExt(request.getParameter("select_seq_no"));
String sSelect_rev_no = StringUtil.setEmptyExt(request.getParameter("select_rev_no"));
String sWorkUser = StringUtil.setEmptyExt(request.getParameter("workUser"));
//String sUserName = StringUtil.setEmptyExt(request.getParameter("userName"));
String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("userName")),"UTF-8");
//String sTeamName = StringUtil.setEmptyExt(request.getParameter("teamName"));
String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("teamName")),"UTF-8");
String processUser = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("processUser")),"UTF-8");
String processUserName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("processUserName")),"UTF-8");
String deptName = URLDecoder.decode(StringUtil.setEmptyExt(request.getParameter("deptName")),"UTF-8");


ArrayList getRevNoDeptList = new ArrayList();
getRevNoDeptList = getRevNoDept(sSelect_rev_no, sTeamName);
String revNoDeptList = "";

%>



<%--========================== HTML HEAD ===================================--%>
<html>
<!-- <link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css> -->
<jsp:include page="/WEB-INF/jsp/common/commonStyle.jsp" flush="false"></jsp:include>

<head>
<title>담당자 변경</title>
</head>
<%--========================== HTML BODY ===================================--%>
<body>

<form name="designReceiveForm">

<input type="hidden" name="select_seq_no" value="<%=sSelect_seq_no%>">
<input type="hidden" name="select_rev_no" value="<%=sSelect_rev_no%>">
<input type="hidden" name="workUser" value="<%=sWorkUser%>">
<input type="hidden" name="userName" value="<%=sUserName%>">
<input type="hidden" name="teamName" value="<%=sTeamName%>">

<div id="mainDiv">
	<div class="subtitle">
		담당자 변경
	</div>
	<table class="searchArea conSearch">
	   <tr height="30">
		   <td>
				<div class="button endbox">
					<input type="button" value='변 경' class="btn_blue" onclick="designReceiveAction();">
					<input type="button" value="닫 기" class="btn_blue" onclick="javascript:window.close();">
				</div>
		   </td>
	   </tr>
	</table>
	<table class="detailArea" style="margin-top:10px">
		<tr>
			<th>접수부서</th>
			<td><%=sTeamName%></td>
		</tr>
		<tr>
			<th>접수자</th>
			<td><%=sUserName%></td>
		</tr>
		<tr>
			<th>접수NO.</th>
			<td><%=sSelect_rev_no%></td>
		</tr>
		<tr>
			<th>처리 담당자</th>
			<td>
				<input type="text" style="border:0;width:180px" name="processPersonInfo" readonly value="<%=processUserName%>(<%=deptName%>)">
				<input type="hidden" name="processPerson" value="<%=processUser %>">
				<input type="button" value='담당자지정' class="btn_gray2" onclick="searchProcessPerson();">
			</td>
		</tr>
	</table>
</div>
</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">

	function searchProcessPerson()
	{
		var workUser = document.designReceiveForm.workUser.value; 
		var processUser = document.designReceiveForm.processPerson.value; 		

		var url = "buyerClassCommentReceiveSearchProcessPerson.do?workUser="+workUser+"&selectType=Single&processUser="+processUser;

		var nwidth = 700;
		var nheight = 500;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;

		window.open(url,"",sProperties);

	}


	function designReceiveAction()
	{
		var mainForm = document.designReceiveForm;



		var confirmMsg = "담당자를 변경 하시겠습니까?";
		var processPersonCheck = true;
		var commentsCheck = true;

		

        if (processPersonCheck && mainForm.processPerson.value == "") {
            alert("처리 담당자를 선택하십시오.");
            return;
        }

		var restrictedChars = "\"&\'";

		if(confirm(confirmMsg))
		{
			var xmlHttp;
			if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

			// GET 방식 전송
			var select_seq_no = mainForm.select_seq_no.value;
			var select_rev_no = mainForm.select_rev_no.value;
			var workUser = mainForm.workUser.value;
			var userName = mainForm.userName.value;
			var teamName = mainForm.teamName.value;
			var processPerson = mainForm.processPerson.value;


			var url = "buyerClassCommentChangeProcesserAction.do?select_seq_no=" + select_seq_no;
				url += "&select_rev_no="+select_rev_no;
				url += "&workUser="+workUser;
				url += "&userName="+escape(encodeURIComponent(userName));
				url += "&teamName="+escape(encodeURIComponent(teamName));
				url += "&processPerson="+processPerson;

			
			var rs = window.showModalDialog( url, 
					window,
					"dialogWidth:400px; dialogHeight:450px; center:on; scroll:off; status:off" );
			if ( rs != null ) {
				
			
			/* xmlHttp.open("GET", url, false);
			xmlHttp.send(null);


			if (xmlHttp.readyState == 4)
			{
				if (xmlHttp.status == 200)
				{
					var resultMsg = xmlHttp.responseText;
	
					resultMsg = resultMsg.replace(/\s/g, "");   

					if (resultMsg != "SUCCESS")
					{
						alert(resultMsg);                
						return;
					}
				}
			} */

			
				// 접수 처리 후 Page Reload
				var parentHeadForm = opener.document.commentHeadForm;
		
				var reloadproject                = parentHeadForm.project.value;
				var reloadownerClass             = parentHeadForm.ownerClass.value;
				var reloadfromDate               = parentHeadForm.fromDate.value;
				var reloadtoDate                 = parentHeadForm.toDate.value;
				var reloadrevNo                  = parentHeadForm.revNo.value;
				var reloadsubject                = parentHeadForm.subject.value;
				var reloadreceiveDept            = parentHeadForm.receiveDept.value;
				var reloadrefDept                = parentHeadForm.refDept.value;
				var reloaddesignReceiveFlag      = parentHeadForm.designReceiveFlag.value;
				var reloaddesignReceiveFromDate  = parentHeadForm.designReceiveFromDate.value;
				var reloaddesignReceiveToDate    = parentHeadForm.designReceiveToDate.value;
				var reloadprocessDept            = parentHeadForm.processDept.value;
				var reloadprocessPerson          = parentHeadForm.processPerson.value;
				var reloaddesignProcessFromDate  = parentHeadForm.designProcessFromDate.value;
				var reloaddesignProcessToDate    = parentHeadForm.designProcessToDate.value;
				var reloadstatus                 = parentHeadForm.status.value;
		
				if(reloadownerClass=="All") reloadownerClass = "";
				if(reloaddesignReceiveFlag=="All") reloaddesignReceiveFlag = "";
				if(reloadstatus=="All") reloadstatus = "";
		
		
		        var urlStr = "buyerClassCommentList.do"
				           + "?project=" + reloadproject
						   + "&ownerClass=" + reloadownerClass
						   + "&fromDate=" + reloadfromDate
						   + "&toDate=" + reloadtoDate
						   + "&revNo=" + reloadrevNo
						   + "&subject=" + reloadsubject
						   + "&receiveDept=" + escape(encodeURIComponent(reloadreceiveDept))
						   + "&refDept=" + escape(encodeURIComponent(reloadrefDept))
						   + "&designReceiveFlag=" + reloaddesignReceiveFlag
						   + "&designReceiveFromDate=" + reloaddesignReceiveFromDate
						   + "&designReceiveToDate=" + reloaddesignReceiveToDate
						   + "&processDept=" + escape(encodeURIComponent(reloadprocessDept))
						   + "&processPerson=" + escape(encodeURIComponent(reloadprocessPerson))
						   + "&designProcessFromDate=" + reloaddesignProcessFromDate
						   + "&designProcessToDate=" + reloaddesignProcessToDate
						   + "&status=" + reloadstatus
						   + "&mode=search";
		
				alert("SUCCESS");
				window.close();
				opener.$("#buyerClassCommentList").attr("src",urlStr);
		        //opener.parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;
		
				}
		}
	}
</script>