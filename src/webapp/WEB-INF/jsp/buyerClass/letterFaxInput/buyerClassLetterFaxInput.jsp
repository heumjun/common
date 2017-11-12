<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%
    Map loginUser	=	(Map)request.getSession().getAttribute("loginUser");
	String userCode = (String)loginUser.get("user_id");	
	String userName = "";
	String teamCode = "";
	String deptName = "";
	String silName = "";
	String silCode = "";
	String docCode = "";
	String teamJang = "";
	String silJang = "";
	String docView = "";
	
	String user_s = request.getAttribute("user_s") == null ? "" : (String)request.getAttribute("user_s");
	if(!"".equals(user_s)){
		userCode = user_s;
	}
	
	java.sql.Connection dpsConn = null;
	try{
		dpsConn = DBConnect.getDBConnection("SDPS");
		
		StringBuffer queryStr = new StringBuffer();
		queryStr.append(" SELECT  A.NAME                                                        ");
		queryStr.append("  		, A.DEPT_CODE                                                   ");
		queryStr.append("  		, (SELECT C.DWGDEPTNM                                           ");
		queryStr.append("       	 FROM DCC_DEPTCODE B                                        ");
		queryStr.append("          		, DCC_DWGDEPTCODE C                                     ");
		queryStr.append("      		WHERE A.DEPT_CODE = B.DEPTCODE                              ");
		queryStr.append("        	  AND B.DWGDEPTCODE = C.DWGDEPTCODE) as TEAMNAME            ");
		// 실코드가 없으면 상위 본부 코드를 가져옴.
		queryStr.append("  		, NVL( (SELECT D.DWGDEPTNM                                      ");
		queryStr.append("       	      FROM DCC_DEPTCODE B                                   ");
		queryStr.append("          	         , DCC_DWGDEPTCODE C                                ");
		queryStr.append("          			 , DCC_DWGDEPTCODE D                                ");
		queryStr.append("      			 WHERE A.DEPT_CODE = B.DEPTCODE                         ");
		queryStr.append("        		   AND B.DWGDEPTCODE = C.DWGDEPTCODE                    ");
		queryStr.append("        		   AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE2)             ");
		queryStr.append("             , (SELECT D.DWGDEPTNM                                     ");
		queryStr.append("       		  FROM DCC_DEPTCODE B                                   ");
		queryStr.append("          			 , DCC_DWGDEPTCODE C                                ");
		queryStr.append("          			 , DCC_DWGDEPTCODE D                                ");
		queryStr.append("      			 WHERE A.DEPT_CODE = B.DEPTCODE                         ");
		queryStr.append("        		   AND B.DWGDEPTCODE = C.DWGDEPTCODE                    ");
		queryStr.append("        		   AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE3) )as SILNAME ");
		queryStr.append("  		, NVL( (SELECT D.DWGDEPTCODE                                    ");
		queryStr.append("       	      FROM DCC_DEPTCODE B                                   ");
		queryStr.append("          	         , DCC_DWGDEPTCODE C                                ");
		queryStr.append("          			 , DCC_DWGDEPTCODE D                                ");
		queryStr.append("      			 WHERE A.DEPT_CODE = B.DEPTCODE                         ");
		queryStr.append("        		   AND B.DWGDEPTCODE = C.DWGDEPTCODE                    ");
		queryStr.append("        		   AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE2)             ");
		queryStr.append("             , (SELECT D.DWGDEPTCODE                                   ");
		queryStr.append("       		  FROM DCC_DEPTCODE B                                   ");
		queryStr.append("          			 , DCC_DWGDEPTCODE C                                ");
		queryStr.append("          			 , DCC_DWGDEPTCODE D                                ");
		queryStr.append("      			 WHERE A.DEPT_CODE = B.DEPTCODE                         ");
		queryStr.append("        		   AND B.DWGDEPTCODE = C.DWGDEPTCODE                    ");
		queryStr.append("        		   AND D.DWGDEPTCODE = C.UPPERDWGDEPTCODE3) )as SILCODE ");
		queryStr.append("  		, (SELECT C.DWGABBR_ENG                                         ");
		queryStr.append("       	 FROM DCC_DEPTCODE B                                        ");
		queryStr.append("          		, DCC_DWGDEPTCODE C                                     ");
		queryStr.append("      		WHERE A.DEPT_CODE = B.DEPTCODE                              ");
		queryStr.append("        	  AND B.DWGDEPTCODE = C.DWGDEPTCODE) as DOCCODE             ");
		queryStr.append("  		, (SELECT C.DOCUMENTSECURITYYN                                  ");
		queryStr.append("       	 FROM DCC_DEPTCODE B                                        ");
		queryStr.append("          		, DCC_DWGDEPTCODE C                                     ");
		queryStr.append("      		WHERE A.DEPT_CODE = B.DEPTCODE                              ");
		queryStr.append("        	  AND B.DWGDEPTCODE = C.DWGDEPTCODE) as DOCVIEW             ");
		queryStr.append("  FROM CCC_SAWON A                                                     ");
		queryStr.append(" WHERE A.EMPLOYEE_NUM = '"+userCode+"'                                 ");
		
		java.sql.Statement stmt = dpsConn.createStatement();
	    java.sql.ResultSet rset = stmt.executeQuery(queryStr.toString());
	
		while (rset.next()) {
			 userName = rset.getString(1) == null ? "" : rset.getString(1);
			 teamCode = rset.getString(2) == null ? "" : rset.getString(2);
			 deptName = rset.getString(3) == null ? "" : rset.getString(3);
			 silName = rset.getString(4) == null ? "" : rset.getString(4);
			 silCode = rset.getString(5) == null ? "" : rset.getString(5);
			 docCode = rset.getString(6) == null ? "" : rset.getString(6);
			 docView = rset.getString(7) == null ? "" : rset.getString(7);
		}
	}catch(Exception e){
		
	}finally{
		if(dpsConn!=null)
			dpsConn.close();
	}

	ArrayList projectArrayList = new ArrayList();
	try{
		dpsConn = DBConnect.getDBConnection("SDPS");
		
		StringBuffer queryStr = new StringBuffer();
		queryStr.append(" select projectno  ");
		queryStr.append("   from lpm_newproject lnp ");
		queryStr.append("       ,stx_oc_project_send_number opsn ");
		queryStr.append("  where 1=1  ");
		queryStr.append("    and lnp.caseno = '1' ");
		queryStr.append("    and lnp.projectno = opsn.project ");
		queryStr.append("    and opsn.send_flag = 'Y' ");
		queryStr.append("  order by projectno asc ");
		
		java.sql.Statement stmt = dpsConn.createStatement();
	          java.sql.ResultSet rset = stmt.executeQuery(queryStr.toString());
	
		while (rset.next()) {
			Map tempMap = new HashMap();
			tempMap.put("PROJECTNO", rset.getString(1) == null ? "" : rset.getString(1));
			
			projectArrayList.add(tempMap);
		}
	}catch(Exception e){
		
	}finally{
		if(dpsConn!=null)
			dpsConn.close();
	}
	
	%>
<%!
private static synchronized ArrayList getProjectList() throws Exception
{
	java.sql.Connection conn = null;
	java.sql.Statement stmt = null;
	java.sql.ResultSet rset = null;

	ArrayList resultArrayList = new ArrayList();

	try {
		conn = DBConnect.getDBConnection("SDPS");

		StringBuffer queryStr = new StringBuffer();

		queryStr.append("SELECT PROJECTNO, DL, DL_EFFECTIVE                                                                                ");
		queryStr.append("  FROM (                                                                                                          ");
		queryStr.append("        SELECT PROJECTNO, NVL(DL, SYSDATE + 1) AS DL,                                                             ");
		queryStr.append("               DECODE(SIGN(TRUNC(SYSDATE) - ADD_MONTHS(NVL(DL, SYSDATE + 1), 1)), 1, 'N', 0, 'N', -1, 'Y')        ");
		queryStr.append("               AS DL_EFFECTIVE	                                                                                   ");
		queryStr.append("          FROM (SELECT LNP.PROJECTNO,LNP.DL																	   ");
		queryStr.append("	   			   FROM LPM_NEWPROJECT LNP 																		   ");
		queryStr.append("	       			   ,STX_OC_PROJECT_SEND_NUMBER OPSN 														   ");
		queryStr.append("	  			  WHERE 1=1																						   ");
		queryStr.append("	    			AND LNP.CASENO = '1' 																		   ");
		queryStr.append("	    			AND LNP.PROJECTNO = OPSN.PROJECT															   ");
		queryStr.append("	    			AND OPSN.SEND_FLAG = 'Y')																	   ");
		queryStr.append("         ORDER BY PROJECTNO		                                                                               ");
		queryStr.append("       )                                                                                                          ");
		queryStr.append("UNION                                                                                                             ");
		queryStr.append("SELECT PROJECTNO, SYSDATE + 1, 'Y'                                                                               ");
		queryStr.append("  FROM (SELECT LNP.PROJECTNO,LNP.DL																	   ");
		queryStr.append("	   	   FROM LPM_NEWPROJECT LNP 																		   ");
		queryStr.append("	       	   ,STX_OC_PROJECT_SEND_NUMBER OPSN 														   ");
		queryStr.append("	      WHERE 1=1																						   ");
		queryStr.append("	    	AND LNP.CASENO = '1' 																		   ");
		queryStr.append("	    	AND LNP.PROJECTNO = OPSN.PROJECT															   ");
		queryStr.append("	    	AND OPSN.SEND_FLAG = 'Y')																	   ");
		queryStr.append(" WHERE  1=1  																								");
		queryStr.append("   AND SUBSTR(PROJECTNO, 1, 1) >= '1'                                                                            ");
		queryStr.append("   AND SUBSTR(PROJECTNO, 1, 1) <= '9'                                                                            ");

        stmt = conn.createStatement();
        rset = stmt.executeQuery(queryStr.toString());

		while (rset.next()) {
			HashMap resultMap = new HashMap();
			resultMap.put("PROJECTNO", rset.getString(1));
			resultMap.put("DL_EFFECTIVE", rset.getString(3));
			resultArrayList.add(resultMap);
		}
	}
	finally {
		if (rset != null) rset.close();
		if (stmt != null) stmt.close();
		DBConnect.closeConnection(conn);
	}

	return resultArrayList;
}

%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<jsp:include page="../../common/commonStyle.jsp" flush="false"></jsp:include>
		<title>buyerClassLetterFaxInput</title>
		
	</head>
	<body>
	<div id="mainDiv" class="mainDiv" style="max-width: 1015px; max-height: 910px;">
		<form name=sendInputForm method="post" action="stxPECBuyerClassLetterFaxInputHead.jsp">
		<div class="subtitle">
			발신 문서등록
			<jsp:include page="/WEB-INF/jsp/common/commonManualFileDownload.jsp" flush="false"></jsp:include>
			<span class="guide"><img src="./images/content/yellow.gif" />&nbsp;필수입력사항</span>
		</div>
		<table class="searchArea conSearch">
			<tr>
				<td>
					<div  id="buttonTable" class="button endbox">
						<input  id="docSaveTD" type="button" class="btn_blue2" value="저장" onclick="docSave()"/>
						<input id="createDocTD" type="button" class="btn_blue2" value="문서작성" onclick="createDoc()"/>
						<input id="closeTD" type="button" class="btn_blue2" value="CLOSE" onclick="closeDialog()"/>
					</div>
				</td>
			</tr>
		</table>
		<table style="max-width: 1015px;">
			<tr>
				<td width="69.5%" style="vertical-align: top;padding:5px;border: #00bb00 1px solid;"> 
					<table class="insertArea conSearch">
						<tr>
							<th>발송부서</th>
							<th>발송자</th>
							<th>Owner/Class</th>
						</tr>
						<tr>
							<td>
								<%
									Map dpsUserInfo = (Map)request.getAttribute("dpsUserInfo");
									if(dpsUserInfo != null && "Y".equals(dpsUserInfo.get("adminyn"))){
								%>
									<select name="sendDepartment" onchange="department_change(this)">
										<%
											List<Map<String,Object>> departmentList = (List<Map<String,Object>>)request.getAttribute("departmentList");
											
											
											for(int i = 0; i < departmentList.size(); i++){
												String checked = "";
												if(teamCode.equals(departmentList.get(i).get("teamcode")))checked = "selected='selected'";
										%>
											<option value="<%=departmentList.get(i).get("teamcode")%>" <%=checked %>><%=departmentList.get(i).get("teamname")%></option>
										<%
											}
										%>
									</select>
								<%
									} else {
								%>
									<input type="text" name="sendDepartment" size=10 value="<%=deptName%>" readonly="readonly" style="background-color: rgb(216, 216, 216); text-align: center;">
								<%
									}
								%>
								<input type="hidden" name="silCode" value="<%=silCode%>">
								<input type="hidden" name="teamCode" value="<%=teamCode%>">
							</td>
							<td>
								<select name="userList" onchange="userChange(this)">
									<!-- 사번 목록 리스트 추가 -->
									<c:forEach var="item" items="${personsList }">
										<option value="${item.EMPLOYEE_NUM }"
												<c:choose>
													<c:when test="${user_s ne null and user_s eq item.EMPLOYEE_NUM}">
														selected="selected"
													</c:when>
													<c:when test="${loginUser.user_id eq item.EMPLOYEE_NUM }">
														selected="selected"
													</c:when>
												</c:choose> >${item.NAME }</option>
									</c:forEach>
								</select>
								<input type="hidden" name="sendUser" size=6 value="<%=userName%>">
								<input type="hidden" name="userCode" value="<%=userCode%>">
							</td>
							<td>
								<input type="radio" name="ownerClass" value="owner" checked="checked" onclick="selProject()">Owner
								<input type="radio" name="ownerClass" value="class" onclick="selProject()">Class
							</td>
							
						</tr>
						<tr>
							<th colspan="3">Ref. No.</th>
						</tr>
						<tr style="background-color:#FAE0D4;">
							<td colspan="3">
								STX/<input type="text" name="ownerCode" value="" style="width:40px; text-align:center;" onkeyup="this.value=this.value.toUpperCase()">-
								<select name="project" onchange="selProject()" style="background-color:#FFFF99;width:80px;">
									<option value="">
										Select
									</option>
									<%
									for(int i=0 ;i<projectArrayList.size();i++){ 
										Map tempMap = (Map)projectArrayList.get(i);
										String tempProject = (String)tempMap.get("PROJECTNO");
										%>
										<option value="<%=tempProject%>">
											<%=tempProject%>
										</option>
										<%
									}
									%>
								</select>
								<input type="text" name="deptCode" value="<%=docCode%>" style="width:30px; text-align:center;" readonly="readonly">
								-
								<input type="text" name="serialCode" value="" style="width:60px; text-align:center;" readonly="readonly">
							</td>
						</tr>
						<tr>
							<th colspan="3">Subject</th>
						</tr>
						<tr>
							<td colspan="3">
								<input style="ime-mode:disabled;width:95%; height:20px; background-color:#FFFF99;" name="docSubject" />
							</td>
						</tr>
						<tr>
							<th colspan="2">문서업무</th>
							<th>문서 View 권한</th>
						</tr>
						<tr>
							<td colspan="2">
								<input type="radio" name="drawingFlag" value="noDrawing" onclick="selProject()">비도면 승인업무
								<input type="radio" name="drawingFlag" value="drawing" checked="checked" onclick="selProject()">도  면 승인업무
							</td>
							<td>
								<%if("Y".equals(docView)){ %>
								<input type="radio" name="docViewAccess" value="all" checked="checked">설계 부서
								<input type="radio" name="docViewAccess" value="team">소속팀
								<%}else{ %>
								<input type="radio" name="docViewAccess" value="all" checked="checked" >설계 부서
								<!-- <input type="radio" name="docViewAccess" value="team">소속팀 -->
								<%} %>
							</td>
						</tr>
						<tr>
							<th colspan="3">Key Word 등록</th>
							
						</tr>
						<tr>
							<td  colspan="3">
								<input style="width:95%; height:20px; background-color:#FFFF99;" name="docKeyWord" onkeyup="this.value=this.value.toUpperCase()"/>
							</td>
							
						</tr>
						<tr>
							<th colspan="3">관련공문서 등록</th>
						</tr>
						<tr>
							<td colspan="3">
								<input style="width:96px; height:20px; background-color:#FFFF99;" value="PROJECT" name="refDocProject" onfocus="this.value=''"/>
								<input style="width:128px; height:20px; background-color:#FFFF99;" value="DOC NO" name="refDocNo" onfocus="this.value=''"/>
								<input style="width:192px; height:20px; background-color:#FFFF99;" value="COMMENT" name="refDocComment" onfocus="this.value=''"/>
								<input type="button" class="btn_gray2" value="SAVE" onclick="refDocSave()"/>
								<input type="button" class="btn_gray2" value="DELETE" onclick="refDocDelete()"/>
							</td>
						</tr>
						<tr>
							<th colspan="3">관련도면 등록 
								<div style="float: right">
									<input type="button" name="ProjectsButton" value="호선추가" class="btn_gray2" onclick="showProjectSelectWin();"/>
						            <input type="checkBox" name="refDwgAppSubmit" checked onclick="dwgAppSubmit(this)">App./Ref Submit
						        </div>
						    </th>
						</tr>
						<tr>
							<td colspan="3">
								<!-- 공사번호(호선) -->
								<%
								ArrayList selectedProjectList = getProjectList();
								%>
								<input name="pjt" value="공사번호" style="width:64px; height:20px; text-align:center;background-color:#FFFF99" readonly onClick="showElementSel('pjt');" />
	                            <select name="pjtSel" class="input_small" style="width:64px;display:none;background-color:#FFFF99;" onChange="projectSelChanged('pjt');projectSelChangedAfter();">
	                                <option value="">&nbsp;</option>
	                                <option value="S000">S000</option>
	                                <%
	                                for (int j = 0; selectedProjectList != null && j < selectedProjectList.size(); j++) {
	                                    Map map = (Map)selectedProjectList.get(j);
	                                    String projectNo = (String)map.get("PROJECTNO");
	                                    String dlEffective = (String)map.get("DL_EFFECTIVE");
	                                    
	                                    if (StringUtil.isNullString(dlEffective) || dlEffective.equalsIgnoreCase("N")) projectNo = "Z" + projectNo;
	                                %>
	                                    <option value="<%=projectNo%>"><%=projectNo%></option>
	                                <%
	                                }
	                                %>
	                            </select>
	                            <input name="drwType" value="구분" style="width:24px; height:20px; text-align:center;background-color:#FFFF99" readonly onClick="showDrwTypeSel('drwType');" />
	                            <select name="drwTypeSel" class="input_small" style="width:24px;display:none;background-color:#FFFF99;" onChange="drwTypeSelChanged('drwType');">
	                                <option value="">&nbsp;</option>
	                            </select>
	                            <input name="drwNo" value="도면번호" style="width:328px; height:20px; text-align:center;background-color:#FFFF99" readonly onClick="showDrwNoSel('drwNo');" />
	                            <select name="drwNoSel" class="input_small" style="width:328px;display:none;background-color:#FFFF99;" onChange="drwNoSelChanged('drwNo');">
	                                <option value="" text="">&nbsp;</option>
	                            </select>
	                            
	                            <input type="hidden" value="PROJECT" name="refDwgProject" onfocus="this.value=''"/>
								<input type="hidden" value="DWG NO" name="refDwgNo" onfocus="this.value=''"/>
								<input type="button" class="btn_gray2" value="SAVE" onclick="refDwgSave()"/>
								<input type="button" class="btn_gray2" value="DELETE" onclick="refDwgDelete()"/>
							</td>
						</tr>
					</table>
				</td>
				<td>
					&nbsp;
				</td>
				<td width="29.5%" style="vertical-align: top; padding:5px;border: #00bb00 1px solid;">
					<table class="insertArea conSearch">
						<tr>
							<th>대표호선</th>
							<th>Type </th>
						</tr>
						<tr>
							<td>
								<input class="input_noBorder" style="width:100px; text-align:center;" name="selectProject" readonly="readonly"/>
							</td>
							<td>
								<input class="input_noBorder" style="width:70px; text-align:center;" name="projectType" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<th>Owner</th>
							<th>Class</th>
						</tr>
						<tr>
							<td>
								<input class="input_noBorder" style="width:120px; text-align:center;" name="projectOwner" readonly="readonly" />
							</td>
							<td>
								<input class="input_noBorder" style="width:70px;text-align:center;" name="projectClass" readonly="readonly"/>
							</td>
						</tr>
					</table>
					<table style="width:370px" cellspacing="0" cellpadding="0" border="0" align="left">
                        <tr height="15">
                            <td class="td_keyEvent" rowspan="2" width="74" style="color:#0000ff">
                                <input class="input_noBorder" style="width:70px;" name="keyeventCT" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" rowspan="2" colspan="3" width="74" style="color:#0000ff">
                                <input class="input_noBorder" style="width:70px;" name="keyeventSC" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" colspan="2" width="74" style="color:#0000ff">
                                <input class="input_noBorder" style="width:70px;" name="keyeventKL" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" colspan="2" width="74" style="color:#0000ff">
                                <input class="input_noBorder" style="width:70px;" name="keyeventLC" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" rowspan="2" width="74" style="color:#0000ff">
                                <input class="input_noBorder" style="width:70px;" name="keyeventDL" readonly="readonly"/>
                            </td>
                        </tr>
                        <tr height="6">
                            <td>
                            </td>
                            <td class="td_keyEvent" rowspan="2" colspan="2" bgcolor="#00008b">
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr height="3">
                            <td colspan="2">
                            </td>
                            <td rowspan="3" width="2px" bgcolor="#00008b">
                            </td>
                            <td class="td_keyEvent" colspan="2">
                            </td>
                            <td class="td_keyEvent" colspan="2">
                            </td>
                        </tr>
                        <tr style="height:3px;" bgColor="#00008b">
                            <td class="td_keyEvent" colspan="2">
                            </td>
                            <td class="td_keyEvent" colspan="6">
                            </td>
                        </tr>
                        <tr height="3">
                            <td class="td_keyEvent" colspan="2">
                            </td>
                            <td class="td_keyEvent" colspan="6">
                            </td>
                        </tr>
                    </table>
                    <table style="width:370px" cellspacing="0" cellpadding="0" border="0">
                        <tr height="15">
                            <td class="td_keyEvent" width="90" style="color:#0000ff" align="left">
                                <input class="input_noBorder" style="width:86px;height:15px;" value="CT" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" width="86" style="color:#0000ff" align="left">
                                <input class="input_noBorder" style="width:82px;height:15px;" value="SC" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" width="74" style="color:#0000ff" align="left">
                                <input class="input_noBorder" style="width:70px;height:15px;" value="KL" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" width="96" style="color:#0000ff" align="left">
                                <input class="input_noBorder" style="width:92px;height:15px;" value="LC" readonly="readonly"/>
                            </td>
                            <td class="td_keyEvent" width="22" style="color:#0000ff" align="right">
                                <input class="input_noBorder" style="width:18px;height:15px;" value="DL" readonly="readonly"/>
                            </td>
                        </tr>
                    </table>
					<table  class="insertArea">
						<tr>
							<th colspan="2">Series 정보</th>
						</tr>
						<tr>
							<td colspan="2">
								<textarea name="seriesProject" style="width:100%"></textarea>
							</td>
						</tr>
						<tr>
							<th colspan="2">선주수신처</th>
						</tr>
						<tr>
							<td colspan="2">
								<div style="height:135px;overflow:scroll; ">
									<table>
										<tr>
											<td width="60" class="baseTD">
				                                   <input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="drawingTypeColumn" value="" />
				                               </td>
											<td width="20" class="baseTD">
												No.
											</td>
											<td width="125" class="baseTD">
												수신자
											</td>
											<td width="125" class="baseTD">
												fax
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue0" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue0" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="receiverValue0" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="faxValue0" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue1" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue1" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="receiverValue1" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="faxValue1" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue2" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue2" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="receiverValue2" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="faxValue2" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue3" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue3" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="receiverValue3" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="faxValue3" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue4" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue4" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="receiverValue4" />
											</td>
											<td width="125" class="baseTD">
												<input class="input_noBorder" style="width:125px;background-color:#FFFFFF;" name="faxValue4" />
											</td>
										</tr>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<div style="max-width: 1015px;" id="dataListDiv">
			<div style="margin-top:5px;"><table id="fromRefTable2"></table></div>
			<div style="margin-top:5px;"><table id="refDwgTable2"></table></div>
		</div>
		</form>
	</div>
<script type="text/javascript">
	$(document).ready( function() {
		
		$( "#fromRefTable2" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : '',
			colNames : [ '참조되는 공문번호', '제목', 'Title', '일자', '발송(수신)부서 ', '참조부서','발신자','View'],
			colModel : [ { name : 'refNo', index : 'refNo', width : 85, editable : false },
			             { name : 'refComment', index : 'refComment', width : 85, editable : false },
			             { name : 'title', index : 'title', width : 55, editable : false },
			             { name : 'refDate', index : 'refDate', width : 85, editable : false },
			             { name : 'refSendDept', index : 'refSendDept', width : 85, editable : false },
			             { name : 'refCCDept', index : 'refCCDept', width : 85, editable : false },
			             { name : 'refSender', index : 'refSender', width : 85, editable : false },
			             { name : 'refView', index : 'refView', width : 85, editable : false }, ],
            gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			viewrecords : true,
			autowidth : true,
			height : 120,
			rownumbers:true,
			cellEdit : true, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			rowList : [ 100, 500, 1000 ],
			rowNum : 100,
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			
			loadComplete : function( data ) {
				
			},
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
				idRow = rowid;
				idCol = iCol;
				kRow = iRow;
				kCol = iCol;
			},
			
			imgpath : 'themes/basic/images',
			onCellSelect : function( row_id, colId ) {
				
			},
			gridComplete : function() {
				
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				
	        }
		} );
		$( "#refDwgTable2" ).jqGrid( {
			datatype : 'json',
			mtype : '',
			url : '',
			postData : '',
			colNames : [ 'Project', 'Dwg. No', 'Title', 'Rev', 'Dwg. Start PR','Dwg. Finish PO','O/C App.Submit','O/C App.Receive' ],
			colModel : [ { name : 'project', index : 'project', width : 85, editable : false },
			             { name : 'dwg_no', index : 'dwg_no', width : 85, editable : false },
			             { name : 'title', index : 'title', width : 55, editable : false },
			             { name : 'rev', index : 'rev', width : 85, editable : false },
			             { name : 'dwg_start', index : 'dwg_start', width : 85, editable : false },
			             { name : 'dwg_finish', index : 'dwg_finish', width : 85, editable : false },
			             { name : 'oc_app_submit', index : 'oc_app_submit', width : 85, editable : false },
			             { name : 'oc_app_receive', index : 'oc_app_receive', width : 85, editable : false }, ],
            gridview : true,
			cmTemplate: { title: false },
			toolbar : [ false, "bottom" ],
			viewrecords : true,
			autowidth : true,
			height : 120,
			rownumbers:true,
			cellEdit : true, // grid edit mode 1
			cellsubmit : 'clientArray', // grid edit mode 2
			rowList : [ 100, 500, 1000 ],
			rowNum : 100,
			jsonReader : {
				root : "rows",
				page : "page",
				total : "total",
				records : "records",
				repeatitems : false,
			},
			
			loadComplete : function( data ) {
				
			},
			beforeEditCell : function( rowid, cellname, value, iRow, iCol ) {
				idRow = rowid;
				idCol = iCol;
				kRow = iRow;
				kCol = iCol;
			},
			
			imgpath : 'themes/basic/images',
			onCellSelect : function( row_id, colId ) {
				
			},
			gridComplete : function() {
				
			},
			afterInsertRow : function(rowid, rowdata, rowelem){
				
	        }
		} );
		resizeJqGridWidth($(window),$("#fromRefTable2"), $("#dataListDiv"),0.129);
		resizeJqGridWidth($(window),$("#refDwgTable2"), $("#dataListDiv"),0.129);
		
		<%
			String msg = (String)request.getAttribute("msg");
			if(msg != null && msg.length() > 0){
		%>
			alert('<%=msg%>');
		<%
			}
		%>
	});
	
	function userChange(obj){
		var sendUser = $.trim($(obj).find("option:selected").text());
		var userCode = $.trim($(obj).val());
		
		document.sendInputForm.sendUser.value = sendUser;
		document.sendInputForm.userCode.value = userCode;
	}
	
	var xmlHttp;
	var xmlHttp2;
	var xmlHttp3;
	var xmlHttp4;
	var xmlHttp5;
	
	function department_change(obj){
		var department_s = $(obj).val();
		location.replace('buyerClassLetterFaxInput.do?department_s='+department_s);
	}
	
	function selProject() {
		
		var selProject = document.sendInputForm.project.value;
		
		if(selProject == ""){
			return;
		}
		
		var ownerClass;
		for(i=0 ; i<document.sendInputForm.ownerClass.length ; i++){
			if(document.sendInputForm.ownerClass[i].checked){
				ownerClass = document.sendInputForm.ownerClass[i].value;
			}
		}
		
		if(ownerClass == "owner"){
			if(selProject == "PS0000")
				document.sendInputForm.ownerCode.readOnly = false;
			else
				document.sendInputForm.ownerCode.readOnly = true;
		}else if(ownerClass == "class")
			document.sendInputForm.ownerCode.readOnly = false;
		
		
		var drawingFlag;
		for(i=0 ; i<document.sendInputForm.drawingFlag.length ; i++){
			if(document.sendInputForm.drawingFlag[i].checked){
				drawingFlag = document.sendInputForm.drawingFlag[i].value;
			}
		}
		
		/* if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxProjectInfo.do?project="+selProject+"&ownerClass="+ownerClass+"&drawingFlag="+drawingFlag;
        $.post( url, "", function( data ) {
        	setProjectData(data.result);
        	document.sendInputForm.refDocProject.value = selProject;
            document.sendInputForm.refDwgProject.value = selProject;

    		// 2012-02-13 Kang seonjung
    		if(selProject != "" && drawingFlag == "drawing")
    		{
    			document.sendInputForm.refDwgAppSubmit.checked = true;
    			var pjtSelcheck = false;
    			for(i=0; i < document.sendInputForm.pjtSel.options.length; i++)
    			{
    				var pjtSelval = document.sendInputForm.pjtSel.options[i].value;
    				
    				if(pjtSelval == selProject || (pjtSelval) == ('Z' + selProject))
    				{
    					pjtSelcheck = true;					
    					document.sendInputForm.pjt.value = pjtSelval;
    					document.sendInputForm.pjtSel.options[i].selected = true;
    					break;
    				}
    			} 
    			if(!pjtSelcheck)
    			{
    				document.sendInputForm.pjt.value = "";
    				document.sendInputForm.pjtSel.value = "";
    			}
    		} else {
    			document.sendInputForm.refDwgAppSubmit.checked = false;
    		}
    		// END : 2012-02-13 Kang seonjung
            
            if(selProject == ""){
    			menu = eval("document.all.buttonTable.style"); 
    	        menu.display="none";
    	        
    	        menu = eval("document.all.docSaveTD.style"); 
    	        menu.display="none";
    	        
    	        menu = eval("document.all.createDocTD.style"); 
    	        menu.display="none";
    		}else{
    	        menu = eval("document.all.buttonTable.style"); 
    	        menu.display="";
    	        
    	        menu = eval("document.all.docSaveTD.style"); 
    	        menu.display="";
    	        
    	        menu = eval("document.all.createDocTD.style"); 
    	        menu.display="";
            }
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        /* xmlHttp.open("GET", url, false);
        xmlHttp.onreadystatechange = callbackProjectInfo;
        xmlHttp.send(null); */
        
        
    }
    
    function callbackProjectInfo() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		var result = xmlHttp.responseText;
	            setProjectData(result);
            } else{// if (xmlHttp.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
    
    function setProjectData(result)
    {
    	var splitResult = result.split("|");
    	
    	document.sendInputForm.keyeventCT.value 	= splitResult[0].replace(/\s/g, "");
    	document.sendInputForm.keyeventSC.value 	= splitResult[1];
	    document.sendInputForm.keyeventKL.value 	= splitResult[2];
    	document.sendInputForm.keyeventLC.value 	= splitResult[3];
    	document.sendInputForm.keyeventDL.value 	= splitResult[4];
    	document.sendInputForm.selectProject.value 	= splitResult[5];
    	document.sendInputForm.seriesProject.value 	= splitResult[6];
    	document.sendInputForm.ownerCode.value 		= splitResult[7];
    	document.sendInputForm.projectType.value 	= splitResult[8];
    	document.sendInputForm.projectOwner.value 	= splitResult[9];
    	document.sendInputForm.projectClass.value 	= splitResult[10];
    	
    	document.sendInputForm.serialCode.value		= splitResult[11];
    	
    	document.sendInputForm.elements["sendReceiveTypeValue0"].value	= "";
    	document.sendInputForm.elements["sendReceiveTypeValue1"].value	= "";
    	document.sendInputForm.elements["sendReceiveTypeValue2"].value	= "";
    	document.sendInputForm.elements["sendReceiveTypeValue3"].value	= "";
    	document.sendInputForm.elements["sendReceiveTypeValue4"].value	= "";
    	document.sendInputForm.elements["noValue0"].value 				= "";
    	document.sendInputForm.elements["noValue1"].value 				= "";
    	document.sendInputForm.elements["noValue2"].value 				= "";
    	document.sendInputForm.elements["noValue3"].value 				= "";
    	document.sendInputForm.elements["noValue4"].value 				= "";
    	document.sendInputForm.elements["receiverValue0"].value 		= "";
    	document.sendInputForm.elements["receiverValue1"].value 		= "";
    	document.sendInputForm.elements["receiverValue2"].value 		= "";
    	document.sendInputForm.elements["receiverValue3"].value 		= "";
    	document.sendInputForm.elements["receiverValue4"].value 		= "";
    	document.sendInputForm.elements["faxValue0"].value 				= "";
    	document.sendInputForm.elements["faxValue1"].value 				= "";
    	document.sendInputForm.elements["faxValue2"].value 				= "";
    	document.sendInputForm.elements["faxValue3"].value 				= "";
    	document.sendInputForm.elements["faxValue4"].value 				= "";
    	
    	var drawingFlag  = null;
		for(i=0 ; i<document.sendInputForm.drawingFlag.length ; i++){
			if(document.sendInputForm.drawingFlag[i].checked){
				drawingFlag = document.sendInputForm.drawingFlag[i].value;
			}
		}
		
		if(drawingFlag == "drawing"){
			document.sendInputForm.drawingTypeColumn.value = "도면";
		}else{
			document.sendInputForm.drawingTypeColumn.value = "비도면";
		}
    	
    	var receiveResult = splitResult[12].split("^");
    	for (var i = 0; i < receiveResult.length; i++) {
        	var receiveSplit = receiveResult[i].split(",");
        	
        	document.sendInputForm.elements["sendReceiveTypeValue"+i].value	= receiveSplit[0];
        	document.sendInputForm.elements["noValue"+i].value 				= receiveSplit[1];
	    	document.sendInputForm.elements["receiverValue"+i].value 		= receiveSplit[2];
	    	document.sendInputForm.elements["faxValue"+i].value 			= receiveSplit[3];
		}
    }
    
    function strCharByte(chStr) {
		if (chStr.substring(0, 2) == '%u') {
			if (chStr.substring(2,4) == '00')
				return 1;
			else
				return 2;        
		} else if (chStr.substring(0,1) == '%') {
			if (parseInt(chStr.substring(1,3), 16) > 127)
				return 2;        
			else
				return 1;
		} else {
				return 1;
		}
	}
	
	function callbackSerialCodeCheck() {
    	if (xmlHttp5.readyState == 4) {
        	if (xmlHttp5.status == 200) {
        		var result = xmlHttp5.responseText;
	            result = result.replace(/\s/g, ""); // 공백제거
	            
	            var serialCode = document.sendInputForm.serialCode.value;
	            
	            if(result != serialCode){
	            	alert("현재 지정된 발신문서 번호가 다른 사용자에 의하여 사용되어 시리얼 넘버를 ("+result+") 로 변경합니다.");
	            	document.sendInputForm.serialCode.value = result;
	            }
	            
            } else{// if (xmlHttp5.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    }
	// 저장  step1      
    function docSave()
    {
    	//문서 등록
    	var project = document.sendInputForm.project.value;
    	
    	if(project == ""){
    		alert("Please select Project.");
    		document.sendInputForm.project.focus();
    		return;
    	}
    	
    	var ownerClass;
		for(i=0 ; i<document.sendInputForm.ownerClass.length ; i++){
			if(document.sendInputForm.ownerClass[i].checked){
				ownerClass = document.sendInputForm.ownerClass[i].value;
			}
		}
		//send
		//D
		var ownerCode = document.sendInputForm.ownerCode.value;
		
		if(ownerCode == ""){
    		alert("Please input Owner/Class Code.");
    		document.sendInputForm.ownerCode.focus();
    		return;
    	}
		
		// owner code에 '-' 사용불가.
		for (var index = 0; index < ownerCode.length; index++) {
		   if ("-".indexOf(ownerCode.charAt(index)) > -1) {
			   alert(" '-' 문자는 사용할 수 없습니다.");
			   document.sendInputForm.ownerCode.focus();
			   return;
		   }
		}
		
    	var deptCode = document.sendInputForm.deptCode.value;
    	
    	//serialCode Check
    	/* if (window.ActiveXObject) {
        	xmlHttp5 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp5 = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxSerialCodeCheck.do?project="+project+"&ownerClass="+ownerClass;
        $.post( url, "", function( data ) {
        	var serialCode = document.sendInputForm.serialCode.value;
            if(data.result != serialCode){
            	alert("현재 지정된 발신문서 번호가 다른 사용자에 의하여 사용되어 시리얼 넘버를 ("+data.result+") 로 변경합니다.");
            	document.sendInputForm.serialCode.value = data.result;
            	serialCode = data.result;
            }
            docSaveStep2(project,ownerClass,ownerCode,deptCode,serialCode);
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step1)" );
		} ).always( function() {
		} );
    }
 	// 저장  step2      
    function docSaveStep2(project,ownerClass,ownerCode,deptCode,serialCode)
    {
       /*  xmlHttp5.open("GET", url, false);
        xmlHttp5.onreadystatechange = callbackSerialCodeCheck;
        xmlHttp5.send(null); */
    	
    	
		var docSubject = document.sendInputForm.docSubject.value.toUpperCase();
		
		if(docSubject == ""){
    		alert("Please input the Subject.");
    		document.sendInputForm.docSubject.focus();
    		return;
    	}
    	
    	for (i=0; i<docSubject.length; i++) {
			valueCh = escape(docSubject.charAt(i));        
			if (strCharByte(valueCh) == 2) { 
				alert("Subject는 한글을 입력할 수 없습니다.");
				return;
			}
		}
    	
		var sendUser = document.sendInputForm.sendUser.value;
		var userCode = document.sendInputForm.userCode.value;
		
		var sendDepartment = document.sendInputForm.sendDepartment.value;
		var docKeyWord = document.sendInputForm.docKeyWord.value;
		var docViewAccess;
		for(i=0 ; i<document.sendInputForm.docViewAccess.length ; i++){
			if(document.sendInputForm.docViewAccess[i].checked){
				docViewAccess = document.sendInputForm.docViewAccess[i].value;
			}
		}
		var drawingFlag;
		for(i=0 ; i<document.sendInputForm.drawingFlag.length ; i++){
			if(document.sendInputForm.drawingFlag[i].checked){
				drawingFlag = document.sendInputForm.drawingFlag[i].value;
			}
		}		
		
		// 2012-02-13 Kang seonjung : 도면 승인 업무시 반드시 관련 도면 1개이상 등록
		
		if(drawingFlag == "drawing")
		{
			/* var oTbl = document.getElementById('refDwgTable');
	    	var rownum = oTbl.rows.length; */
	    	var ids = $( "#refDwgTable2" ).jqGrid( 'getDataIDs' );
			if(ids.length < 1)
			{
				alert("관련도면을 등록하세요.");
				return;
			}
		}
		
		var drawingMsg;
		if(drawingFlag == "drawing"){
			drawingMsg = "도면";
		}else{
			drawingMsg = "비도면";
		}
		
		if(confirm("Subject : "+docSubject+"\n\n"+drawingMsg+" 승인 업무로 확정 하시겠습니까?")){
			
		}else{
			return;
		}
		
		/* if (window.ActiveXObject) {
        	xmlHttp4 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp4 = new XMLHttpRequest();     
        } */
        
        var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?project=" + project
				+ "&ownerClassType=" + ownerClass
				+ "&sendReceiveType=send"
				+ "&docType=D"
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&revNo=" 
				+ "&subject=" + docSubject
				+ "&senderNo=" + userCode
				+ "&sendReceiveDate="
				+ "&refDept=" 
				+ "&keyword=" + docKeyWord
				+ "&viewAccess=" + docViewAccess
				+ "&mode=doc"
				;

        var parameters = {
        		sender : sendUser,
        		sendReceiveDept : sendDepartment
    		};
        
        $.post( url, parameters, function( data ) {
        	
        	if(data.result == "success") {
        		alert("승인 업무 확정");
        		docSaveStep3(project,ownerClass,ownerCode,deptCode,serialCode);	
        	} else {
        		alert(data.resultMsg+":승인 업무 확정");
        	}
        	
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step2)" );
		} ).always( function() {
		} );
        /* xmlHttp4.open("GET", url, false);
        xmlHttp4.onreadystatechange = callbackDocSave;
        xmlHttp4.send(null); */
    }
 	// 저장  step3      
    function docSaveStep3(project,ownerClass,ownerCode,deptCode,serialCode)
    {
    	//관련문서 등록
    	var ids = $( "#fromRefTable2" ).jqGrid( 'getDataIDs' );
		for ( var i = 0; i < ids.length; i++) {
			var tempRefNo = $( "#fromRefTable2" ).jqGrid( 'getCell', ids[i], 'refNo' );
			var tempRefComment = $( "#fromRefTable2" ).jqGrid( 'getCell', ids[i], 'refComment' );
			var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?project=" + project
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=document"
				+ "&objectNo=" + tempRefNo
				+ "&objectComment=" + tempRefComment
				+ "&mode=refdoc"
				;
        
			$.post( url, "", function( data ) {
				if(data.result == "success") {
					alert("관련문서등록");
				} else {
					alert(data.resultMsg+":관련문서등록")
				}
				
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step3)" );
			} ).always( function() {
			} );
		}
		/* for(i=1 ; i<document.getElementById('fromRefTable').rows.length ; i++){
			
			var oRow = document.getElementById('fromRefTable').rows[i];
			var tempRefNo = document.getElementById("fromRefNo" + oRow.uniqueNumber).value;
			var tempRefComment = document.getElementById("fromRefComment" + oRow.uniqueNumber).value;
			
			if(tempRefNo=="")
				continue;
			var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?project=" + project
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=document"
				+ "&objectNo=" + tempRefNo
				+ "&objectComment=" + tempRefComment
				+ "&mode=refdoc"
				;
        
			$.post( url, "", function( data ) {
				if(data.result == "success") {
					alert("관련문서등록");
				} else {
					alert(data.resultMsg+":관련문서등록")
				}
				
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step3)" );
			} ).always( function() {
			} );
			
	        xmlHttp4.open("GET", url, false);
	        xmlHttp4.onreadystatechange = callbackDocSave;
	        xmlHttp4.send(null);
		} */
		docSaveStep4(project,ownerClass,ownerCode,deptCode,serialCode);
    }
 	// 저장  step4      
    function docSaveStep4(project,ownerClass,ownerCode,deptCode,serialCode)
    {
		
    	var ids = $( "#refDwgTable2" ).jqGrid( 'getDataIDs' );
		for ( var i = 0; i < ids.length; i++) {
			var tempProject = $( "#refDwgTable2" ).jqGrid( 'getCell', ids[i], 'project' );
			var tempDwgNo = $( "#refDwgTable2" ).jqGrid( 'getCell', ids[i], 'dwg_no' );
			
			var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?project=" + tempProject
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=drawing"
				+ "&objectNo=" + tempDwgNo
				+ "&objectComment="
				+ "&mode=refdoc"
				+ "&dwgAppSubmit=" + document.sendInputForm.refDwgAppSubmit.checked
				+ "&ownerClassType=" + ownerClass
				;
        
			$.post( url, "", function( data ) {
				alert("사용하실 문서번호는 "+"STX/"+ownerCode+"-"+project+deptCode+"-"+serialCode+" 입니다.\n\n해당 Letter를 'Letter/Fax Document Attach.'에서 등록 하세요.");
		    	
		        menu = eval("document.all.docSaveTD.style"); 
		        menu.display="none";
		        
		        menu = eval("document.all.createDocTD.style"); 
		        menu.display="";
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step4)" );
			} ).always( function() {
			} );
		}
 		//관련도면 등록
		/* for(i=1 ; i<document.getElementById('refDwgTable').rows.length ; i++){
			var oRow = document.getElementById('refDwgTable').rows[i];
			var tempProject = document.getElementById("refProject" + oRow.uniqueNumber).value;
			var tempDwgNo = document.getElementById("refDwgNo" + oRow.uniqueNumber).value;
			var tempDwgAppSubmit = document.getElementById("refDwgAppSubmit" + oRow.uniqueNumber).value;
			
			if(tempDwgNo=="")
				continue;
			var url = "buyerClassLetterFaxDocumentSaveProcess.do"
        		+ "?project=" + tempProject
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=drawing"
				+ "&objectNo=" + tempDwgNo
				+ "&objectComment="
				+ "&mode=refdoc"
				+ "&dwgAppSubmit=" + document.sendInputForm.refDwgAppSubmit.checked
				+ "&ownerClassType=" + ownerClass
				;
        
			$.post( url, "", function( data ) {
				alert("사용하실 문서번호는 "+"STX/"+ownerCode+"-"+project+deptCode+"-"+serialCode+" 입니다.\n\n해당 Letter를 'Letter/Fax Document Attach.'에서 등록 하세요.");
		    	
		        menu = eval("document.all.docSaveTD.style"); 
		        menu.display="none";
		        
		        menu = eval("document.all.createDocTD.style"); 
		        menu.display="";
	        }, "json").error( function () {
				alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요.(step4)" );
			} ).always( function() {
			} );
	        xmlHttp4.open("GET", url, false);
	        xmlHttp4.onreadystatechange = callbackDocSave;
	        xmlHttp4.send(null);
		} */
    	return;
    }
    
    /* function callbackDocSave() {
    	if (xmlHttp4.readyState == 4) {
        	if (xmlHttp4.status == 200) {
        		var result = xmlHttp4.responseText;
            } else{// if (xmlHttp4.status == 204){//데이터가 존재하지 않을 경우
            	//clearNames();
            }
        }
    } */
    
    function createDoc()
    {
    	var project = document.sendInputForm.project.value;
    	var ownerCode = document.sendInputForm.ownerCode.value;
    	var deptCode = document.sendInputForm.deptCode.value;
    	var serialCode = document.sendInputForm.serialCode.value;
    	var silCode = document.sendInputForm.silCode.value;
    	var drawingFlag;
		for(i=0 ; i<document.sendInputForm.drawingFlag.length ; i++){
			if(document.sendInputForm.drawingFlag[i].checked){
				drawingFlag = document.sendInputForm.drawingFlag[i].value;
			}
		}
    	
    	var attURL = "buyerClassLetterFaxOpenFile.do";
	    //attURL += "?fileName=" + "STX-"+ownerCode+"-"+project+"Z.DOC";
	    attURL += "?fileName=" + "STX-"+ownerCode.replace("&","%26")+"-"+project+"-"+serialCode+".doc";
	    attURL += "&project=" + project;
	    attURL += "&drawingFlag=" + drawingFlag;
	    attURL += "&silCode=" + silCode;
	
	    var sProperties = 'dialogHeight:340px;dialogWidth:680px;scroll=no;center:yes;resizable=no;status=no;';
	
	    window.open(attURL,"",sProperties);
    	
    	return;
    }
    
    function refDocSave()
    {
    	//alert("ref doc save process...");
    	
    	var refDocProject 	= document.sendInputForm.refDocProject.value;
    	var refDocNo 		= document.sendInputForm.refDocNo.value;
    	var refDocComment 	= document.sendInputForm.refDocComment.value;
    	
    	if(refDocProject == "" || refDocProject == "PROJECT"){
    		alert("관련공문서 등록 - 호선을 입력하세요.");
    		document.sendInputForm.refDocProject.focus();
    		return;
    	}
    	if(refDocNo == "" || refDocNo == "DOC NO"){
    		alert("관련공문서 등록 - 문서 번호를 입력하세요.");
    		document.sendInputForm.refDocNo.focus();
    		return;
    	}
    	if(refDocComment == "" || refDocComment == "COMMENT"){
    		alert("관련공문서 등록 - 비고를 입력하세요.");
    		document.sendInputForm.refDocComment.focus();
    		return;
    	}
    	
    	/* if (window.ActiveXObject) {
        	xmlHttp3 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp3 = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxDocumentInfo.do?project="+refDocProject+"&document="+refDocNo;
        $.post( url, "", function( data ) {
        	setDocumentData(data.result,refDocComment);
            document.sendInputForm.refDocProject.value = refDocProject;
        	document.sendInputForm.refDocNo.value = "DOC NO";
        	document.sendInputForm.refDocComment.value = "COMMENT";
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        /* xmlHttp3.open("GET", url, false);
        xmlHttp3.send(null);
        
        if(xmlHttp3.status != 200)
        {
        	alert("Error! Status");
        	return;
        } */
    	return;
    }
    
    var tagsToReplace = {
    	    '"': '&quot;',
    	    '&': '&amp;',
    	    '<': '&lt;',
    	    '>': '&gt;',
    	    "'": '&#039;'
    	};

    		  
	function replaceTag(tag) {
		var s = tagsToReplace[tag] || tag;
		return s;
	}
		  
	function safe_tags_replace(str) {
		return str.replace(/[&<>\"\'\{\}]/g, replaceTag);
	}

		
    function setDocumentData(result,refDocComment)
    {
    	var splitResult = result.split("|");
    	if(splitResult[0].replace(/\s/g, "") == ""){
    		alert("Not exist document data");
    		return;
    	}
    	var item = {};
    	var colModel = $( '#fromRefTable2' ).jqGrid( 'getGridParam', 'colModel' );
		for ( var i in colModel)
			item[colModel[i].name] = '';
		
		item.refNo = splitResult[1];
    	item.refComment = refDocComment;
    	item.title = splitResult[2];
    	item.refDate = splitResult[3];
    	item.refSendDept = splitResult[4];
    	item.refCCDept = splitResult[5];
    	item.refSender = splitResult[6];
    	item.refView = "<img src='AddOn/common/images/iconAttachment.gif' onclick=viewRefFile('"+splitResult[1]+"')>";
    	
    	$( '#fromRefTable2' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
    	
    	
    	/* var oTbl = document.getElementById('fromRefTable');
    	var rownum = oTbl.rows.length;
    	var oRow = oTbl.insertRow(rownum);
    	oRow.className = 'baseTD';
    	var oCell1 = addNewCellwithChild(oRow.insertCell(),fnCheckBoxHtml("chkData","chkData"+oRow.uniqueNumber,""),null,"3%");
    	var oCell2 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefNo","fromRefNo"+oRow.uniqueNumber,splitResult[1],22));
    	var oCell3 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefComment","fromRefComment"+oRow.uniqueNumber,refDocComment,15));
    	var oCell4 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefTitle","fromRefTitle"+oRow.uniqueNumber,splitResult[2],20));
    	var oCell5 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefDate","fromRefDate"+oRow.uniqueNumber,splitResult[3],9));
    	var oCell6 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefSendDept","fromRefSendDept"+oRow.uniqueNumber,splitResult[4],18));
    	var oCell7 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefCCDept","fromRefCCDept"+oRow.uniqueNumber,splitResult[5],18));
    	var oCell8 = addNewCellwithChild(oRow.insertCell(),fnInputText("fromRefSender","fromRefSender"+oRow.uniqueNumber,splitResult[6],5));
    	addNewCellSimple(oRow.insertCell(),"<img src=\"../common/images/iconAttachment.gif\" onclick=\"viewRefFile(this)\" border=\"0\" alt=\"\" vspace=\"0\">","baseTD");
    	
    	oCell1.className = 'baseTD';
    	oCell2.className = 'baseTD';
    	oCell3.className = 'baseTD';
    	oCell4.className = 'baseTD';
    	oCell5.className = 'baseTD';
    	oCell6.className = 'baseTD';
    	oCell7.className = 'baseTD';
    	oCell8.className = 'baseTD'; */
    }
    
    function fnCheckAll(obj,target)
    {
    	var allChecked = document.getElementsByTagName("input");
    	for(var i= 0 ;i<allChecked.length ;i++)
    	{
    		if(allChecked[i].name == target)allChecked[i].checked = obj.checked;
    	}
    }
    
    function refDocDelete()
    {
    	var rows = $( "#fromRefTable2" ).getDataIDs();

		for ( var i = 0; i < rows.length; i++ ) {
			$( '#fromRefTable2' ).jqGrid( 'delRowData', rows[i] );
		}
		
    	/* var oTbl = document.getElementById('fromRefTable');
    	var rownum = oTbl.rows.length;
    	for(var i=rownum - 1;i>0;i--)
    	{
    		if(oTbl.rows[i].firstChild.firstChild.checked)
    		{
    			oTbl.deleteRow(i);
    		}
    	} */
    }
    
    function refDwgSave()
    {
    	var refDwgProject 	= document.sendInputForm.refDwgProject.value;
    	var refDwgNo 		= document.sendInputForm.refDwgNo.value;
    	var refDwgAppSubmit	= document.sendInputForm.refDwgAppSubmit.checked;
    	
    	if(refDwgProject == "" || refDwgProject == "PROJECT"){
    		alert("관련도면 등록 - 호선을 입력하세요.");
    		document.sendInputForm.refDwgProject.focus();
    		return;
    	}
    	if(refDwgNo == "" || refDwgNo == "DWG NO"){
    		alert("관련도면 등록 - 도면 번호를 입력하세요.");
    		document.sendInputForm.refDwgNo.focus();
    		return;
    	}
    	
    	/* if (window.ActiveXObject) {
        	xmlHttp2 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp2 = new XMLHttpRequest();     
        } */
        var url = "buyerClassLetterFaxDrawingInfo.do?project="+refDwgProject+"&drawing="+refDwgNo;
        
        $.post( url, "", function( data ) {
        	setDrawingData(data.result);
        	document.sendInputForm.refDwgProject.value = refDwgProject;
        	document.sendInputForm.refDwgNo.value = "DWG NO";
        }, "json").error( function () {
			alert( "시스템 오류입니다.\n전산담당자에게 문의해주세요." );
		} ).always( function() {
		} );
        
        
        
       /*  xmlHttp2.open("GET", url, false);
        xmlHttp2.send(null);
        
        if(xmlHttp2.status != 200)
        {
        	alert("Error! Status");
        	return;
        } */
        
    	
    	return;
    }
    
    function setDrawingData(result)
    {
    	var ownerClass;
		for(i=0 ; i<document.sendInputForm.ownerClass.length ; i++){
			if(document.sendInputForm.ownerClass[i].checked){
				ownerClass = document.sendInputForm.ownerClass[i].value;
			}
		}
    		
    	var splitResult = result.split("|");
    	
    	/* var oTbl = document.getElementById('refDwgTable');
    	var rownum = oTbl.rows.length;
    	var oRow = oTbl.insertRow(rownum);
    	oRow.className = 'baseTD';
    	$( "#refDwgTable" ).append( "<tr>td><input type='checkbox' name='chkDwg' ><td><tr>" ); */
    	
    	var item = {};
    	var colModel = $( '#refDwgTable2' ).jqGrid( 'getGridParam', 'colModel' );
		for ( var i in colModel)
			item[colModel[i].name] = '';
		
    	item.project = splitResult[0].replace(/\s/g, "");
    	item.dwg_no = splitResult[1];
    	item.title = splitResult[2];
    	item.rev = splitResult[3];
    	item.dwg_start = 'P: ' + splitResult[4] +' A:'+ splitResult[6];
    	item.dwg_finish = 'P: ' + splitResult[5] +' A:'+ splitResult[7];
    	if(ownerClass == "owner"){
    		item.oc_app_submit = 'P: ' + splitResult[8] +' A:'+ splitResult[10];
    		item.oc_app_receive = 'P: ' + splitResult[9] +' A:'+ splitResult[11];
    	} else if(ownerClass == "class"){
    		item.oc_app_submit = 'P: ' + splitResult[12] +' A:'+ splitResult[14];
    		item.oc_app_receive = 'P: ' + splitResult[13] +' A:'+ splitResult[15];
    	}
    	$( '#refDwgTable2' ).jqGrid( 'addRowData', $.jgrid.randId(), item, 'first' );
    	var checkValue = splitResult[0].replace(/\s/g, "");
    	if(checkValue == ""){
    		alert("Not exist drawing data");
    		return;
    	}
    	/* item.8 = splitResult[6];
    	item.2 = splitResult[7]; */
    	 /* if(ownerClass == "owner"){
    		 oc_app_submit = splitResult[8];
    		 oc_app_receive = splitResult[9];
    		 = splitResult[10];
    		 = splitResult[11];
    	 } */
    	/* addNewCellwithChild(oRow.insertCell(),fnCheckBoxHtml("chkDwg","chkDwg"+oRow.uniqueNumber,""),"baseTD");
    	addNewCellwithChild(oRow.insertCell(),fnInputText("refProject","refProject"+oRow.uniqueNumber,splitResult[0].replace(/\s/g, ""),11),"baseTD");
    	addNewCellwithChild(oRow.insertCell(),fnInputText("refDwgNo","refDwgNo"+oRow.uniqueNumber,splitResult[1],11),"baseTD");
    	addNewCellwithChild(oRow.insertCell(),fnInputText("refDwgTitle","refDwgTitle"+oRow.uniqueNumber,splitResult[2],38),"baseTD");
    	addNewCellwithChild(oRow.insertCell(),fnInputText("refDwgRev","refDwgRev"+oRow.uniqueNumber,splitResult[3],2),"baseTD");
		    	
    	addNewCellSimple(oRow.insertCell(),"&nbsp;&nbsp;P&nbsp;&nbsp;<br><br>&nbsp;&nbsp;A&nbsp;&nbsp;","baseTD");
    	addNewCellSimple(oRow.insertCell(),"<input type='text' id='refDwgStartP"+oRow.uniqueNumber+"' size=11><br><input type='text' id='refDwgStartA"+oRow.uniqueNumber+"' size=11>","baseTD");
    	addNewCellSimple(oRow.insertCell(),"<input type='text' id='refDwgFinishP"+oRow.uniqueNumber+"' size=11><br><input type='text' id='refDwgFinishA"+oRow.uniqueNumber+"' size=11>","baseTD");
    	addNewCellSimple(oRow.insertCell(),"<input type='text' id='refDwgSubmitP"+oRow.uniqueNumber+"' size=11><br><input type='text' id='refDwgSubmitA"+oRow.uniqueNumber+"' size=11><input type='hidden' id='refDwgAppSubmit"+oRow.uniqueNumber+"' value=''>","baseTD");
    	addNewCellSimple(oRow.insertCell(),"<input type='text' id='refDwgReceiveP"+oRow.uniqueNumber+"' size=11><br><input type='text' id='refDwgReceiveA"+oRow.uniqueNumber+"' size=11>","baseTD");
    	
    	
    	document.getElementById('refProject'+oRow.uniqueNumber).value = splitResult[0].replace(/\s/g, "");
    	document.getElementById('refDwgNo'+oRow.uniqueNumber).value = splitResult[1];
    	document.getElementById('refDwgTitle'+oRow.uniqueNumber).value = splitResult[2];
    	document.getElementById('refDwgRev'+oRow.uniqueNumber).value = splitResult[3];
    	document.getElementById('refDwgStartP'+oRow.uniqueNumber).value = splitResult[4];
    	document.getElementById('refDwgFinishP'+oRow.uniqueNumber).value = splitResult[5];
    	document.getElementById('refDwgStartA'+oRow.uniqueNumber).value = splitResult[6];
    	document.getElementById('refDwgFinishA'+oRow.uniqueNumber).value = splitResult[7];
    	
    	if(ownerClass == "owner"){
   			document.getElementById('refDwgSubmitP'+oRow.uniqueNumber).value = splitResult[8];
   			document.getElementById('refDwgReceiveP'+oRow.uniqueNumber).value = splitResult[9];
   			document.getElementById('refDwgSubmitA'+oRow.uniqueNumber).value = splitResult[10];
   			document.getElementById('refDwgReceiveA'+oRow.uniqueNumber).value = splitResult[11];
    	}
    	//class
    	else if(ownerClass == "class"){
    		document.getElementById('refDwgSubmitP'+oRow.uniqueNumber).value = splitResult[12];
    		document.getElementById('refDwgReceiveP'+oRow.uniqueNumber).value = splitResult[13];
    		document.getElementById('refDwgSubmitA'+oRow.uniqueNumber).value = splitResult[14];
    		document.getElementById('refDwgReceiveA'+oRow.uniqueNumber).value = splitResult[15];
    	} */
    	
    }
    
    function refDwgDelete()
    {
    	var rows = $( "#refDwgTable2" ).getDataIDs();

		for ( var i = 0; i < rows.length; i++ ) {
			$( '#refDwgTable2' ).jqGrid( 'delRowData', rows[i] );
		}
		
    	/* var oTbl = document.getElementById('refDwgTable');
    	var rownum = oTbl.rows.length;
    	for(var i=rownum - 1;i>0;i--)
    	{
    		if(oTbl.rows[i].firstChild.firstChild.checked)
    		{
    			oTbl.deleteRow(i);
    		}
    	}
		return; */
    }
    
    function viewRefFile(refNo){
    	//var refNo = document.getElementById("fromRefNo"+obj.parentNode.parentNode.uniqueNumber).value;
    	var attURL = "buyerClassLetterFaxViewFileDialog.do";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    //var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
	    var nwidth = 400;
		var nheight = 340;
		var LeftPosition = (screen.availWidth-nwidth)/2;
		var TopPosition = (screen.availHeight-nheight)/2;

		var sProperties = "left="+LeftPosition+",top="+TopPosition+",width="+nwidth+",height="+nheight;
	    window.open(attURL, '', sProperties);
		
    }
    
    function closeDialog(){
    	top.parent.window.close();
    }
    
    function dwgAppSubmit(obj){
    	if(obj.checked){
    		var project = document.sendInputForm.project.value;
    		var refDwgProject = document.sendInputForm.refDwgProject.value;
    		if(project!=refDwgProject){
    			alert("선택된 호선과 등록 호선이 다르면 해당 기능을 사용할 수 없습니다.");
    			obj.checked = false;
    		}
    	}
    	
    	if(obj.checked){
    		if(document.sendInputForm.drawingFlag[0].checked)obj.checked = false;
    	}
    }
    
    //공사구분 , 구분 , 도면 선택 Script
    function showProjectSelectWin()
    {
    	var userCode = document.sendInputForm.userCode.value;
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var selectedProjects = parent.window.showModalDialog("buyerClassLetterFaxProjectSelect.do?designerID="+userCode , '' , sProperties);
        if (selectedProjects != null && selectedProjects != 'undefined') changedSelectedProject(selectedProjects);
    }
    
    function changedSelectedProject(selectedProjects)
    {
        toggleActiveElementDisplay();

        var selectedProjectsList = selectedProjects.split("|");

        //for (var i = 0; i < timeKeys.length; i++) {
            var ctrlId = "pjtSel";
            var pjtSelObj = document.all(ctrlId);
            var currentSelectedValue = document.all("pjt").value;
            
            // 먼저 현재의 호선목록을 모두 삭제
            for (var j = pjtSelObj.options.length - 1; j >= 2; j--)  pjtSelObj.options[j] = null; // 0 번째는 '', 1 번째는 'S000' 이므로 2 번째 부터 처리

            var isExist = false;

            // 변경된 호선목록으로 다시 채운다
            for (var j = 0; j < selectedProjectsList.length; j++) {
                var projectNoStr = selectedProjectsList[j];
                pjtSelObj.options[j + 2] = new Option(projectNoStr, projectNoStr);
                
                // selected 설정
                if (currentSelectedValue == projectNoStr) {
                    pjtSelObj.selectedIndex = j + 2;
                    isExist = true;
                }
            }

            // 선택된 호선이 삭제된 호선이면 이 항목에 대해서만 해당 호선을 추가
            if (!isExist && currentSelectedValue != "" && currentSelectedValue != "S000") {
                pjtSelObj.options[pjtSelObj.options.length] = new Option(currentSelectedValue, currentSelectedValue);
                pjtSelObj.selectedIndex = pjtSelObj.options.length - 1;
            }
        //}
    }
    
    function projectSelChanged(elemPrefix)
    {
        elementSelChanged(elemPrefix);

		var elemInput = document.all(elemPrefix);
		document.sendInputForm.refDwgProject.value = elemInput.value;

        var pjtSelObj = document.all('pjtSel');
        var drwTypeObj = document.all('drwType');
        var drwTypeSelObj = document.all('drwTypeSel');
        var drwNoObj = document.all('drwNo');        
        var drwNoSelObj = document.all('drwNoSel');
        
        // 도면구분 값 초기화
        drwTypeObj.value = ''; 
        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
        // 도면번호 값 초기화
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;

        // 공사번호(호선)가 'S000'이면 도면번호를 '*****'로 설정하고, 그 외의 경우에는 해당 호선에 대한 도면구분 목록을 DB에서 쿼리...
        if (pjtSelObj.value == "") {
            return;
        }
        else if (pjtSelObj.value == 'S000') {
            drwNoObj.value = '*****';
        }
        else {
            drawingTypesForWorkQueryProc(pjtSelObj, drwTypeSelObj, "");
        }
    }
    function projectSelChangedAfter()
    {
        toggleActiveElementDisplay();

        var pjtValue = document.sendInputForm.userCode.value;
        if (pjtValue != "") {
            showElementSel("drwType");
        }
    }
    function showElementSel(elemPrefix)
    {
        var elemInput = document.all(elemPrefix);
        var elemSel = document.all(elemPrefix + 'Sel');

        toggleActiveElementDisplay();
        elemInput.style.display = 'none';
        elemSel.style.display = '';

        activeElement = elemSel;
        activeElementPair = elemInput;
    }
    var activeElement = null;
    var activeElementPair = null; 
    function toggleActiveElementDisplay()
    {
        if (activeElement != null) {
            activeElement.style.display = 'none';
            if (activeElementPair != null) activeElementPair.style.display = '';
            activeElement = null;
            activeElementPair = null;
        }
    }
    function showDrwTypeSel(elemPrefix)
    {
        var pjtObj = document.all('pjt');
        var drwTypeObj = document.all('drwType');
        var drwTypeSelObj = document.all('drwTypeSel');
        if (drwTypeObj.value != "" && drwTypeSelObj.options.length <= 1) {
            drawingTypesForWorkQueryProc(document.all('pjtSel'), drwTypeSelObj, drwTypeObj.value);
        }

        showElementSel(elemPrefix);
    }
    function drawingTypesForWorkQueryProc(pjtSelObj, drwTypeSelObj, selectedValue)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=GetDrawingTypesForWork&departCode=" + document.sendInputForm.teamCode.value + "&projectNo=" + pjtSelObj.value, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                if (resultMsg != null)
                {
                	resultMsg = resultMsg.replace(/\s/g, "");
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                    	var strs = resultMsg.split("|");
                        drwTypeSelObj.selectedIndex = 0;
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var newOption = new Option(strs[i], strs[i]);
                            drwTypeSelObj.options[i + 1] = newOption;
                            if (selectedValue != "" && selectedValue == strs[i]) drwTypeSelObj.selectedIndex = i + 1;  
                        }
                    }
                }
            }
            else {
                alert("ERROR");
            }
        }
        else {
            alert("ERROR");
        }
    }
    function drwTypeSelChanged(elemPrefix)
    {
        elementSelChanged(elemPrefix);

        var pjtSelObj = document.all('pjtSel');
        var drwTypeValue = document.all('drwTypeSel').value;
        var drwNoObj = document.all('drwNo');
        var drwNoSelObj = document.all('drwNoSel');
        
        // 도면번호 값 초기화
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;

        // 도면구분 선택 값에 따라 해당 호선 & 부서의 작업 대상 도면 목록을 디비에서 쿼리
        if (drwTypeValue == '') {
            drwNoObj.value = '';
        }
        else {
            drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, "");

            // 도면번호 선택 컨트롤을 Show
            showDrwNoSel('drwNo');
        }
    }
    function showDrwNoSel(elemPrefix)
    {
        var drwTypeObj = document.all('drwType');
        var drwNoObj = document.all('drwNo');
        var drwNoSelObj = document.all('drwNoSel');

        if (drwTypeObj.value == '') {
            var pjtObj = document.all('pjt');
            
            // 공사번호는 있는데 도면구분이 없는 경우에는 '*****' 를 표시한다
            for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;
            drwNoSelObj.options[1] = new Option("*****", "*****");       
            if (drwNoObj.value == "*****") drwNoSelObj.selectedIndex = 1;
        }
        else if (drwNoObj.value != "" && drwNoSelObj.options.length <= 1) {
            drawingListForWorkQueryProc(document.all('pjtSel'), drwTypeObj.value, drwNoSelObj, drwNoObj.value);
        }

        showElementSel(elemPrefix);
    }
    function drwNoSelChanged(elemPrefix)
    {
        elementSelChanged(elemPrefix);
    
        var drwNoSelObj = document.all('drwNoSel');

        var drwNoStr = drwNoSelObj.options[drwNoSelObj.selectedIndex].text;
        if (drwNoStr.indexOf(" : ") > 0) {
            var tempStrs = drwNoStr.split(" : ");
            document.sendInputForm.refDwgNo.value = tempStrs[0];
        }else{
        	document.sendInputForm.refDwgNo.value = drwNoStr;
        }
        
        var elemInput = document.all('drwNo');
        var elemSel = document.all('drwNoSel');

        toggleActiveElementDisplay();
        elemInput.style.display = '';
        elemSel.style.display = 'none';
	}
    function elementSelChanged(elemPrefix)
    {
        var elemInput = document.all(elemPrefix);
        var elemSel = document.all(elemPrefix + 'Sel');
        elemInput.value = elemSel.value;
    }
    function drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, selectedValue)
    {
        var xmlHttp;
        if (window.ActiveXObject) xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        else if (window.XMLHttpRequest) xmlHttp = new XMLHttpRequest();

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.do?requestProc=GetDrawingListForWork&departCode=" + document.sendInputForm.teamCode.value + "&projectNo=" + pjtSelObj.value + "&drawingType=" + drwTypeValue, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.replace(/\s/g, "");
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("|");
                        drwNoSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split(",");
                            var newOption = new Option(strs2[0] + " : " + strs2[1], strs2[0]);
                            //var newOption = new Option(strs2[0]);
                            drwNoSelObj.options[i + 1] = newOption;
                            if (selectedValue != "" && selectedValue == strs2[0]) drwNoSelObj.selectedIndex = i + 1; 
                        }
                    }
                }
            }
            else {
                alert("ERROR");
            }
        }
        else {
            alert("ERROR");
        }
    }
    //
    //////////////////////////////////////////////////////
    
    function selectUser(userCode , teamCode){
    	
    	if(true)
    		return;
    
    	//alert(userCode +"|"+ teamCode);
    	
    	//sendDepartment //deptName
		//silCode //silCode
		//teamCode //teamCode
		//sendUser //userName
		//userCode //userCode
    	
    	/* var url = "stxPECBuyerClassLetterFaxUserSelectFS.jsp"
    	        + "?formName=sendInputForm"
    	        +"&fieldName1=sendDepartment"
    	        +"&fieldName2=silCode"
    	        +"&fieldName3=teamCode"
    	        +"&fieldName4=sendUser"
    	        +"&fieldName5=userCode"
    	        +"&userCode=" + userCode
    	        +"&teamCode=" + teamCode
    	        
    	        ;
    	        
    	showModalDialog(url,600,575); */
    }
    
	menu = eval("document.all.buttonTable.style"); menu.display="none";
	
	menu = eval("document.all.docSaveTD.style"); menu.display="none";
	menu = eval("document.all.createDocTD.style"); menu.display="none";
	menu = eval("document.all.closeTD.style"); menu.display="none";
</script>
</body>
</html>

