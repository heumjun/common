<%--  
§DESCRIPTION: 담당자 변경
§AUTHOR (MODIFIER): Kang seonjung
§FILENAME: stxPECBuyerClassCommentResultManagementDesignReceiveChangeProcesser.jsp
§CHANGING HISTORY: 
§    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

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

String sSelect_seq_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_seq_no"));
String sSelect_rev_no = StringUtil.setEmptyExt(emxGetParameter(request, "select_rev_no"));
String sWorkUser = StringUtil.setEmptyExt(emxGetParameter(request, "workUser"));
//String sUserName = StringUtil.setEmptyExt(emxGetParameter(request, "userName"));
String sUserName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "userName")),"UTF-8");
//String sTeamName = StringUtil.setEmptyExt(emxGetParameter(request, "teamName"));
String sTeamName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "teamName")),"UTF-8");
String processUser = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "processUser")),"UTF-8");
String processUserName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "processUserName")),"UTF-8");
String deptName = URLDecoder.decode(StringUtil.setEmptyExt(emxGetParameter(request, "deptName")),"UTF-8");


ArrayList getRevNoDeptList = new ArrayList();
getRevNoDeptList = getRevNoDept(sSelect_rev_no, sTeamName);
String revNoDeptList = "";

%>



<%--========================== HTML HEAD ===================================--%>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>



<%--========================== HTML BODY ===================================--%>
<body style="background-color:#eeeeee">

<form name="designReceiveForm">

<input type="hidden" name="select_seq_no" value="<%=sSelect_seq_no%>">
<input type="hidden" name="select_rev_no" value="<%=sSelect_rev_no%>">
<input type="hidden" name="workUser" value="<%=sWorkUser%>">
<input type="hidden" name="userName" value="<%=sUserName%>">
<input type="hidden" name="teamName" value="<%=sTeamName%>">


<table width="100%" cellspacing="0" cellpadding="0">
<tr>
    <td>
		<table width="100%">
		   <tr height="30">
			   <td width="60%" style="font-size: 15pt; font-weight: bold; text-align: center; color=blue;">&nbsp;&nbsp;담당자 변경 </td>
			   <td width="40%" style="font-size: 15pt; font-weight: bold; text-align: center;">
				<input type="button" value='변 경' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="designReceiveAction();">&nbsp;&nbsp;
				<input type="button" value="닫 기" style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="javascript:window.close();">
			   </td>
		   </tr>
		</table>
		<br>

		<table width="100%" height="60" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="50%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">접수부서</td>
							<td class="td_timeselect" width="100" bgcolor="#cccccc">접수자</td>
						</tr>
						<tr height="25">
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=sTeamName%></td>
							<td class="td_standard" width="100" bgcolor="#f5f5f5"><%=sUserName%></td>
						</tr>
					</table>

				</td>

				<td width="50%" align="center">
					<table border="1" bordercolor="black"  style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="200" bgcolor="#cccccc">접수NO.</td>	
						</tr>
						<tr height="25">
							<td class="td_standard" width="200" bgcolor="#f5f5f5"> <%=sSelect_rev_no%></td>
						</tr>
					</table>
				</td>
			</tr>

		</table>
		<br><br>

		<table width="100%" height="80" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="70%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;" width="310">
						<tr height="25">
							<td class="td_timeselect" bgcolor="#cccccc">처리 담당자</td>
						</tr>
						<tr>
							<td class="td_standard" bgcolor="#f5f5f5">
								<input type="text" name="processPersonInfo" style="width:100%;" readonly value="<%=processUserName%>(<%=deptName%>)" />
								<input type="hidden" name="processPerson" value="<%=processUser %>">
							</td>
						</tr>
					</table>

				</td>

				<td width="30%" align="left"><input type="button" value='담당자지정' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="searchProcessPerson();">
				</td>
			</tr>
		</table>
</td>
</tr>
</table>

</form>
</body>


<%--========================== SCRIPT ======================================--%>
<script language="JavaScript">

	function searchProcessPerson()
	{
		var workUser = document.designReceiveForm.workUser.value; 
		var processUser = document.designReceiveForm.processPerson.value; 		

		var url = "stxPECBuyerClassCommentResultManagementDesignReceiveSearchProcessPerson.jsp?workUser="+workUser+"&selectType=Single&processUser="+processUser;

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


			var url = "stxPECBuyerClassCommentResultManagementDesignChangeProcesserAction.jsp?select_seq_no=" + select_seq_no;
				url += "&select_rev_no="+select_rev_no;
				url += "&workUser="+workUser;
				url += "&userName="+escape(encodeURIComponent(userName));
				url += "&teamName="+escape(encodeURIComponent(teamName));
				url += "&processPerson="+processPerson;

			xmlHttp.open("GET", url, false);
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
			}

			
		// 접수 처리 후 Page Reload
		var parentHeadForm = parent.window.opener.document.commentHeadForm;

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


        var urlStr = "stxPECBuyerClassCommentResultManagementBody.jsp"
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
        
        opener.parent.COMMENT_RESULT_MANAGEMENT_BODY.location = urlStr;

		}

	}
</script>