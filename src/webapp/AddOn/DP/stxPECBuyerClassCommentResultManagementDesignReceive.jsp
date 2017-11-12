<%--  
��DESCRIPTION: ���Ź��� ���� �� ���� ���� - ��������
��AUTHOR (MODIFIER): Kang seonjung
��FILENAME: stxPECBuyerClassCommentResultManagementDesignReceive.jsp
��CHANGING HISTORY: 
��    2012-08-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import = "java.util.*" %>
<%@ page import="java.sql.CallableStatement"%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ page import = "com.stx.common.util.StringUtil" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file = "stxPECGetParameter_Include.inc" %>


<%@ page contentType="text/html; charset=euc-kr" %>

<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>

<%--========================== JSP =========================================--%>

<%!
	// �ϳ��� ���Ź����� ���� Ÿ�μ� ������ ����.
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
			   <td width="60%" style="font-size: 15pt; font-weight: bold; text-align: center; color=blue;">&nbsp;&nbsp;���Ź��� ���� </td>
			   <td width="40%" style="font-size: 15pt; font-weight: bold; text-align: center;">
				<input type="button" value='�� ��' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="designReceiveAction();">&nbsp;&nbsp;
				<input type="button" value="�� ��" style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="javascript:window.close();">
			   </td>
		   </tr>
		</table>
		<br>

		<table width="100%" height="60" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="50%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="100" bgcolor="#cccccc">�����μ�</td>
							<td class="td_timeselect" width="100" bgcolor="#cccccc">������</td>
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
							<td class="td_timeselect" width="200" bgcolor="#cccccc">����NO.</td>	
						</tr>
						<tr height="25">
							<td class="td_standard" width="200" bgcolor="#f5f5f5"> <%=sSelect_rev_no%></td>
						</tr>
					</table>
				</td>
			</tr>

		</table>
		<br><br>

		<table width="100%" height="130" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="50%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="200" bgcolor="#cccccc">��ġ����</td>
						</tr>
						<tr>
							<td class="td_standard" width="200" bgcolor="#f5f5f5">
								<table width="100%">
									<tr height="20">
										<td align="left">
											 <input type="radio" name="processFlag" value="1">&nbsp; ��������
									    </td>
									</tr>
									<tr height="20">
										<td align="left">
											 <input type="radio" name="processFlag" value="2">&nbsp; ó��/ȸ�� ���ʿ�
									    </td>
									</tr>
									<tr height="20">
										<td align="left">
											 <input type="radio" name="processFlag" value="3">&nbsp; �ݼ�
									    </td>
									</tr>
									<tr height="20">
										<td align="left">
											 <input type="radio" name="processFlag" value="4">&nbsp; Ÿ�μ� �߰� ����
									    </td>
									</tr>										
								</table>
							</td>
						</tr>
					</table>

				</td>

				<td width="50%" align="center">
					<table border="1" bordercolor="black"  style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" width="200" bgcolor="#cccccc">Ÿ�μ� ��������</td>	
						</tr>
						<tr height="105">
							<td class="td_standard" width="200" bgcolor="#f5f5f5">
							<div STYLE="width:200; height:105; overflow-y:auto; position:relative; background-color:#ffffff">
								<table width="100%">
							<%
								for(int i=0; i<getRevNoDeptList.size(); i++)
								{
									Map tempResultMap = (Map)getRevNoDeptList.get(i);
									String tempRevNoDept = (String)tempResultMap.get("SEND_RECEIVE_DEPT");
									if("".equals(revNoDeptList))
									{
										revNoDeptList += tempRevNoDept;
									}else {
										revNoDeptList += ", "+tempRevNoDept;
									}
							%>
									<tr height="20">
										<td align="center"><%=tempRevNoDept%>
										</td>
									</tr>
							<%	}  %>
								</table>
								<input type="hidden" name="revNoDeptList" value="<%=revNoDeptList%>">
							</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>

		</table>

		<br><br>

		<table width="100%" height="80" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="70%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" bgcolor="#cccccc">ó�� �����</td>
						</tr>
						<tr>
							<td class="td_standard" bgcolor="#f5f5f5"><textarea name="processPersonInfo" rows=3 cols=40 readonly></textarea>
							<input type="hidden" name="processPerson" value="">
							</td>
						</tr>
					</table>

				</td>

				<td width="30%" align="left"><input type="button" value='���������' style="cursor:hand; border: #000000 1px solid; font-size: 9pt; font-weight: bold; height: 30px; width: 70px;" onclick="searchProcessPerson();">
				</td>
			</tr>
		</table>

		<br><br>

		<table width="100%" height="80" cellSpacing="0" cellpadding="0" border="0" align="center">
			<tr>
				<td width="100%" align="center">	
					<table border="1" bordercolor="black" style="border-collapse: collapse;">
						<tr height="25">
							<td class="td_timeselect" bgcolor="#cccccc">Comment ����</td>
						</tr>
						<tr>
							<td class="td_standard" bgcolor="#f5f5f5"><textarea name="commentMsg" rows=3 cols=50></textarea>
							</td>
						</tr>
					</table>

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

		var url = "stxPECBuyerClassCommentResultManagementDesignReceiveSearchProcessPerson.jsp?workUser="+workUser;

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


		var processFlag="";
		var confirmMsg;
		var processPersonCheck = true;
		var commentsCheck = true;

		for(i=0 ; i < mainForm.processFlag.length ; i++){
			if(mainForm.processFlag[i].checked){
				processFlag = mainForm.processFlag[i].value;
			}
		}

		if(processFlag=="")
		{
			alert("��ġ������ �����Ͻʽÿ�.");
			return;
		}

		if(processFlag=="1")
		{
			commentsCheck = false;
			confirmMsg = "���� ������ �����Ͻðڽ��ϱ�?";
		} else 	if(processFlag=="2")
		{			
			processPersonCheck = false;
			commentsCheck = false;
			confirmMsg = "ó��/ȸ�� ���ʿ�� �����Ͻðڽ��ϱ�?";
		} else 	if(processFlag=="3")
		{
			processPersonCheck = false;
			confirmMsg = "�ݼ� (�����ȹ ��������ڿ��� �ݼ��뺸) ���·� �����Ͻðڽ��ϱ�?";
		} else if(processFlag=="4")
		{
			confirmMsg = "Ÿ�μ� �߰����� (���� ���� �� �����ȹ ���� ����ڿ��� Comment �뺸) ���·� �����Ͻðڽ��ϱ�?";
		}

        if (processPersonCheck && mainForm.processPerson.value == "") {
            alert("ó�� ����ڸ� �����Ͻʽÿ�.");
            return;
        }

        if (commentsCheck && mainForm.commentMsg.value == "") {
            alert("�����ȹ ���Ź��� ���������(���̼�)���� ������ Comments ������ �Է��Ͻʽÿ�. ");
            return;
        }

		var restrictedChars = "\"&\'";
		
		var commentMsg = mainForm.commentMsg.value;

		for(var index=0; index < commentMsg.length; index++)
		{
			if(restrictedChars.indexOf(commentMsg.charAt(index)) != -1)
			{
				alert("Comments ���뿡 &(Shift+7) �� \" �� \' �� ����� �� �����ϴ�.");
				return;
			}
		}


		if(confirm(confirmMsg))
		{
			var xmlHttp;
			if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

			// GET ��� ����
			var select_seq_no = mainForm.select_seq_no.value;
			var select_rev_no = mainForm.select_rev_no.value;
			var workUser = mainForm.workUser.value;
			var userName = mainForm.userName.value;
			var teamName = mainForm.teamName.value;
			var processPerson = mainForm.processPerson.value;
			var revNoDeptList = mainForm.revNoDeptList.value;
			var commentMsg = mainForm.commentMsg.value;


			var url = "stxPECBuyerClassCommentResultManagementDesignReceiveAction.jsp?select_seq_no=" + select_seq_no;
				url += "&select_rev_no="+select_rev_no;
				url += "&workUser="+workUser;
				url += "&userName="+escape(encodeURIComponent(userName));
				url += "&teamName="+escape(encodeURIComponent(teamName));
				url += "&processFlag="+processFlag;
				url += "&processPerson="+processPerson;
				url += "&revNoDeptList="+escape(encodeURIComponent(revNoDeptList));
				url += "&commentMsg="+escape(encodeURIComponent(commentMsg));

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

			
		// ���� ó�� �� Page Reload
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