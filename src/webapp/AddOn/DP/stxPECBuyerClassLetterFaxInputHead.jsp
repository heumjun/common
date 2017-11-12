<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page import="com.stx.common.interfaces.DBConnect"%>
<%@ include file = "stxPECDP_Include.inc" %>

<%@ page contentType="text/html; charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>
<% response.setContentType("text/html; charset=euc-kr"); %>
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
<style type="text/css">
	.baseTD {
        border: #000000 1px solid;
        color:#0000ff;
        font-size: 8pt;
        font-weight: bold;
	} 
	.baseTDYellow {
		border: #000000 1px solid; color:#FFFF99
	} 
	.baseTDTrans {
		border: #000000 1px solid; color:#000000
	}
</style>
<script type="text/javascript" src="scripts/stxDynamicTable.js"></script>
<html>
<link rel=StyleSheet HREF="stxPECDP.css" type=text/css title=stxPECDP_css>
<body>
<form name=sendInputForm method="post" action="stxPECBuyerClassLetterFaxInputHead.jsp">
	<table>
		<tr>
			<td>
				�߽� ���� ���
			</td>
		</tr>
	</table>
	
	<table>
		<tr>
			<td>
				<table>
					<tr>
					<!-- ������� (�Է�����) ���� -->
					<td style="border: #00bb00 1px solid;">
						<table>
							<tr>
								<td>
									<table>
										<tr>
											<td>
												�߼ۺμ�
											</td>
											<td>
												�߼���
											</td>
											<!-- 
											<td>
												����
											</td>
											<td>
												����
											</td> -->
										</tr>
										<tr>
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
												// ���ڵ尡 ������ ���� ���� �ڵ带 ������.
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
											
											%>
										
											<td>
												<input type="text" name="sendDepartment" size=10 value="<%=deptName%>">
												<input type="hidden" name="silCode" value="<%=silCode%>">
												<input type="hidden" name="teamCode" value="<%=teamCode%>">
											</td>
											<td>
												<input type="text" name="sendUser" size=6 value="<%=userName%>" onclick="selectUser('<%=userCode%>' , '<%=teamCode%>')">
												<input type="hidden" name="userCode" value="<%=userCode%>">
											</td>
											<!-- 
											<td>
												<input type="text" name="teamJang" size=6 value="<%//=teamJang%>">
											</td>
											<td>
												<input type="text" name="silJang" size=6 value="<%//=silJang%>">
											</td> -->
											<td>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
											<td>
												&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											</td>
											<td>
												
											</td>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												<table>
													<tr>
														<td>
															<input type="radio" name="ownerClass" value="owner" checked="checked" onclick="selProject()">Owner
														</td>
													</tr>
													<tr>
														<td>
															<input type="radio" name="ownerClass" value="class" onclick="selProject()">Class
														</td>
													</tr>
												</table>
											</td>
											<td>
												Ref. No. : STX/<input type="text" name="ownerCode" value="" size=3 onkeyup="this.value=this.value.toUpperCase()">-
												<%
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
												<select name="project" onchange="selProject()" style="background-color:#FFFF99">
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
												<input type="text" name="deptCode" value="<%=docCode%>" size=1 readonly="readonly">
												-
												<input type="text" name="serialCode" value="" size=4 readonly="readonly">
											</td>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												Subject
											</td>
											<td width="498" class="baseTDYellow">
												<input class="input_noBorder" style="ime-mode:disabled;width:498px;background-color:#FFFF99;" name="docSubject" />
											</td>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												�������� : 
											</td>
											<td>
												<table>
													<tr>
														<td>
															<input type="radio" name="drawingFlag" value="noDrawing" onclick="selProject()">�񵵸� ���ξ���
														</td>
													</tr>
													<tr>
														<td>
															<input type="radio" name="drawingFlag" value="drawing" checked="checked" onclick="selProject()">��  �� ���ξ���
															<!-- (<input type="checkbox" name="link">�ּ�ǥ��) -->
														</td>
													</tr>
												</table>
											</td>
											<%if("Y".equals(docView)){ %>
												<td>
													���� View ���� :
												</td>
												<td>
													<table>
														<tr>
															<td>
																<input type="radio" name="docViewAccess" value="all" checked="checked">���� �μ�
															</td>
														</tr>
														<tr>
															<td>
																<input type="radio" name="docViewAccess" value="team">�Ҽ���
															</td>
														</tr>
													</table>
												</td>
											<%}else{ %>
												<td>
													<input type="radio" name="docViewAccess" value="all" checked="checked" >
													<input type="radio" name="docViewAccess" value="team">
												</td>
											<%} %>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												Key Word ���
											</td>
											<td width="456" class="baseTDYellow">
												<input class="input_noBorder" style="width:456px;background-color:#FFFF99;" name="docKeyWord" onkeyup="this.value=this.value.toUpperCase()"/>
											</td>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												<table>
													<tr>
														<td>
															���ð����� ���
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td width="96" class="baseTDYellow">
												<input class="input_noBorder" style="width:96px;background-color:#FFFF99;" value="PROJECT" name="refDocProject" onfocus="this.value=''"/>
											</td>
											<td width="128" class="baseTDYellow">
												<input class="input_noBorder" style="width:128px;background-color:#FFFF99;" value="DOC NO" name="refDocNo" onfocus="this.value=''"/>
											</td>
											<td width="192" class="baseTDYellow">
												<input class="input_noBorder" style="width:192px;background-color:#FFFF99;" value="COMMENT" name="refDocComment" onfocus="this.value=''"/>
											</td>
											<td width="50" class="baseTD">
												<input type="button" style="width:50px;background-color:#D8D8D8;" value="SAVE" onclick="refDocSave()"/>
											</td>
											<td width="60" class="baseTD">
												<input type="button" style="width:60px;background-color:#D8D8D8;" value="DELETE" onclick="refDocDelete()"/>
											</td>
										</tr>
									</table>
									<table>
										<tr>
											<td>
												<table>
													<tr>
														<td>
															���õ��� ���
														</td>
													</tr>
												</table>
											</td>
											<td>
												&nbsp;
											</td>
											<td>
								            	ȣ���߰�
								            	&nbsp;
								            	<input type="button" name="ProjectsButton" value="��" style="height:22px;width=22px;" onclick="showProjectSelectWin();"/>
								            	&nbsp;
								            	&nbsp;
								            	<input type="checkbox" name="refDwgAppSubmit" checked onclick="dwgAppSubmit(this)">App./Ref Submit
								            </td>
								            <td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<!-- �����ȣ(ȣ��) -->
											<%
											ArrayList selectedProjectList = getProjectList();
											%>
					                        <td width="64" class="baseTDYellow">
					                        	<input name="pjt" value="�����ȣ" class="input_noBorder" style="width:64px;text-align:center;background-color:#FFFF99" readonly onClick="showElementSel('pjt');" />
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
					                        </td>
					                        <!-- ���� ���� -->
					                        <td width="24" class="baseTDTrans">
					                        	<input name="drwType" value="����" class="input_noBorder" style="width:24px;text-align:center;background-color:#FFFF99" readonly onClick="showDrwTypeSel('drwType');" />
					                            <select name="drwTypeSel" class="input_small" style="width:24px;display:none;background-color:#FFFF99;" onChange="drwTypeSelChanged('drwType');">
					                                <option value="">&nbsp;</option>
					                            </select>
					                        </td>
					                        <!-- �����ȣ -->
					                        <td width="328" class="baseTDTrans">
					                        	<input name="drwNo" value="�����ȣ" class="input_noBorder" style="width:328px;text-align:center;background-color:#FFFF99" readonly onClick="showDrwNoSel('drwNo');" />
					                            <select name="drwNoSel" class="input_small" style="width:328px;display:none;background-color:#FFFF99;" onChange="drwNoSelChanged('drwNo');">
					                                <option value="" text="">&nbsp;</option>
					                            </select>
					                            
					                            <input type="hidden" value="PROJECT" name="refDwgProject" onfocus="this.value=''"/>
												<input type="hidden" value="DWG NO" name="refDwgNo" onfocus="this.value=''"/>
					                        </td>
											<td width="50" class="baseTD">
												<input type="button" style="width:50px;background-color:#D8D8D8;" value="SAVE" onclick="refDwgSave()"/>
											</td>
											<td width="60" class="baseTD">
												<input type="button" style="width:60px;background-color:#D8D8D8;" value="DELETE" onclick="refDwgDelete()"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr align="right">
								<td align="right">
									<table id="buttonTable">
										<tr align="right">
											<td id="docSaveTD" width="75" class="baseTD">
												<input type="button" style="width:75px;background-color:#D8D8D8;" value="����" onclick="docSave()"/>
											</td>
											<td id="createDocTD" width="75" class="baseTD">
												<input type="button" style="width:75px;background-color:#D8D8D8;" value="�����ۼ�" onclick="createDoc()"/>
											</td>
											<td id="closeTD" width="75" class="baseTD">
												<input type="button" style="width:75px;background-color:#D8D8D8;" value="CLOSE" onclick="closeDialog()"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<!-- ������� (�Է�����) �� -->
					
					<!-- ���� ��� (ȣ������) ���� -->
					<td style="border: #00bb00 1px solid;">
						<table cellspacing="1" cellpadding="0" border="0" >
							<tr>
								<td>
									<table>
										<tr>
											<td>
												ȣ������
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
											<td>
												&nbsp;
											</td>
										</tr>
										<tr>
											<td>
												��ǥȣ�� : 
											</td>
											<td class="td_keyEvent" width="172" style="color:#0000ff">
												<input class="input_noBorder" style="width:128px;background-color:#D8D8D8;" name="selectProject" />
			                                </td>
			                                <td>
			                                	Type : 
			                                </td>
			                                <td class="td_keyEvent" width="50" style="color:#0000ff">
												<input class="input_noBorder" style="width:50px;background-color:#D8D8D8;" name="projectType" />
			                                </td>
										</tr>
										<tr>
											<td>
												Owner : 
											</td>
											<td class="td_keyEvent" width="172" style="color:#0000ff">
												<input class="input_noBorder" style="width:172px;background-color:#D8D8D8;" name="projectOwner" />
								            </td>
								            <td>
												Class : 
											</td>
											<td class="td_keyEvent" width="50" style="color:#0000ff">
												<input class="input_noBorder" style="width:50px;background-color:#D8D8D8;" name="projectClass" />
								            </td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td style="background-color:#D8D8D8;">
									<table width="370" cellspacing="0" cellpadding="0" border="0" align="left">
			                            <tr height="15">
			                                <td class="td_keyEvent" rowspan="2" width="74" style="color:#0000ff">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" name="keyeventCT" />
			                                </td>
			                                <td class="td_keyEvent" rowspan="2" colspan="3" width="74" style="color:#0000ff">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" name="keyeventSC" />
			                                </td>
			                                <td class="td_keyEvent" colspan="2" width="74" style="color:#0000ff">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" name="keyeventKL" />
			                                </td>
			                                <td class="td_keyEvent" colspan="2" width="74" style="color:#0000ff">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" name="keyeventLC" />
			                                </td>
			                                <td class="td_keyEvent" rowspan="2" width="74" style="color:#0000ff">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" name="keyeventDL" />
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
			                                <td rowspan="3" width="1%" bgcolor="#00008b">
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
								</td>
							</tr>
							<tr>
								<td>
									<table width="370" cellspacing="0" cellpadding="0" border="0">
			                            <tr height="15">
			                                <td class="td_keyEvent" width="90" style="color:#0000ff" align="left">
			                                    <input class="input_noBorder" style="width:90px;background-color:#D8D8D8;" value="CT" />
			                                </td>
			                                <td class="td_keyEvent" width="86" style="color:#0000ff" align="left">
			                                    <input class="input_noBorder" style="width:86px;background-color:#D8D8D8;" value="SC" />
			                                </td>
			                                <td class="td_keyEvent" width="74" style="color:#0000ff" align="left">
			                                    <input class="input_noBorder" style="width:74px;background-color:#D8D8D8;" value="KL" />
			                                </td>
			                                <td class="td_keyEvent" width="96" style="color:#0000ff" align="left">
			                                    <input class="input_noBorder" style="width:96px;background-color:#D8D8D8;" value="LC" />
			                                </td>
			                                <td class="td_keyEvent" width="22" style="color:#0000ff" align="right">
			                                    <input class="input_noBorder" style="width:22px;background-color:#D8D8D8;" value="DL" />
			                                </td>
			                            </tr>
			                        </table>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
							</tr>
							<tr>
								<td style="background-color:#FFFFFF ;border: #FFFFFF 1px solid;">
									<table>
										<tr>
											<td>
												Series ����
											</td>
										</tr>
										<tr>
											<td>
												<textarea name="seriesProject" cols="49" rows="2"></textarea>
					                        </td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									&nbsp;
								</td>
							</tr>
							<tr>
								<td>
									���ּ���ó
								</td>
							</tr>
							<tr>
								<td style="background-color:#FFFFFF ;border: #FFFFFF 1px solid;">
									<table width="370" cellspacing="0" cellpadding="0" border="0" align="left">
										<tr>
											<td width="60" class="baseTD">
			                                    <input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="drawingTypeColumn" value="" />
			                                </td>
											<td width="20" class="baseTD">
												No.
											</td>
											<td width="145" class="baseTD">
												������
											</td>
											<td width="145" class="baseTD">
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
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="receiverValue0" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="faxValue0" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue1" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue1" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="receiverValue1" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="faxValue1" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue2" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue2" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="receiverValue2" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="faxValue2" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue3" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue3" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="receiverValue3" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="faxValue3" />
											</td>
										</tr>
										<tr>
											<td width="60" class="baseTD">
												<input class="input_noBorder" style="width:60px;background-color:#FFFFFF;" name="sendReceiveTypeValue4" />
											</td>
											<td width="20" class="baseTD">
												<input class="input_noBorder" style="width:20px;background-color:#FFFFFF;" name="noValue4" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="receiverValue4" />
											</td>
											<td width="145" class="baseTD">
												<input class="input_noBorder" style="width:145px;background-color:#FFFFFF;" name="faxValue4" />
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
					<!-- ���� ��� (ȣ������) �� -->
				</tr>
			</table>
			</td>
		</tr>
		
		<tr>
			<!-- �ϴ� (�߰����� �Է�) ���� -->
			<td style="border: #00bb00 1px solid;">
				<table>
					<tr>
						<td>
						<div id="listDivUp" STYLE="width:100%; height:200; overflow-x:scroll;overflow-y:scroll;  left:0; top:20;"> 
	         				<table id="dataTableUp" width="980" cellSpacing="1" cellpadding="0" border="0" align="left" style="table-layout:fiexed;">
							<table>
								<tr>
									<td>
										<table id="fromRefTable" width="970" cellspacing="0" cellpadding="0" border="0" align="center">
											<tr>
												<td class="baseTD" width="3%" align="center">
													<input type="checkbox" onclick="fnCheckAll(this,'chkData')">
				                                </td>
												<td class="baseTD" width="18%" align="center">
													�����Ǵ� ������ȣ
				                                </td>
												<td class="baseTD" width="14%" align="center">
													���
												</td>
												<td class="baseTD" width="17%" align="center">
													����
												</td>
												<td class="baseTD" width="8%" align="center">
													����
												</td>
												<td class="baseTD" width="15%" align="center">
													�߼�(����)�μ�
												</td>
												<td class="baseTD" width="15%" align="center">
													�����μ�
												</td>
												<td class="baseTD" width="5%" align="center">
													�߽���
												</td>
												<td class="baseTD" width="5%" align="center">
													View
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<div id="listDiv" STYLE="width:100%; height:200; overflow-x:scroll;overflow-y:scroll;  left:0; top:20;"> 
	         				<table id="dataTable" width="980" cellSpacing="1" cellpadding="0" border="0" align="left" style="table-layout:fiexed;">
								<tr>
									<td>
										<table id="refDwgTable" width="970" cellspacing="0" cellpadding="0" border="0" align="left">
											<tr>
												<td class="baseTD" width="3%" align="center">
													<input type="checkbox" onclick="fnCheckAll(this,'chkDwg')">
				                                </td>
												<td class="baseTD" width="10%" align="center">
													Project
				                                </td>
												<td class="baseTD" width="10%" align="center">
													Dwg. No
												</td>
												<td class="baseTD" width="30%" align="center">
													Title
												</td>
												<td class="baseTD" width="4%" align="center">
													Rev
												</td>
												<td class="baseTD" width="3%" align="center">
													-
												</td>
												<td class="baseTD" width="10%" align="center">
													Dwg. Start<br>
													PR
												</td>
												<td class="baseTD" width="10%" align="center">
													Dwg. Finish<br>
													PO
												</td>
												<td class="baseTD" width="10%" align="center">
													Owner/Class<br>
													App.Submit
												</td>
												<td class="baseTD" width="10%" align="center">
													Owner/Class<br>
													App.Receive
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
							</div>
						</td>
					</tr>
				</table>
			</td>
			<!-- �ϴ� (�߰����� �Է�) �� -->
		</tr>
	</table>
</form>
</body>
<%--========================== SCRIPT ======================================--%>
<%--========================== SCRIPT ======================================--%>
<script language="javascript" type="text/javascript" src="scripts/emxUIModal.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_CommonScript.js"></script>
<script language="javascript" type="text/javascript" src="./stxPECDP_GeneralAjaxScript.js"></script>


<script language="JavaScript">

	var xmlHttp;
	var xmlHttp2;
	var xmlHttp3;
	var xmlHttp4;
	var xmlHttp5;
	
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
		
		if (window.ActiveXObject) {
        	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassLetterFaxProjectInfo.jsp?project="+selProject+"&ownerClass="+ownerClass+"&drawingFlag="+drawingFlag;
        
        xmlHttp.open("GET", url, false);
        xmlHttp.onreadystatechange = callbackProjectInfo;
        xmlHttp.send(null);
        
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
    }
    
    function callbackProjectInfo() {
    	if (xmlHttp.readyState == 4) {
        	if (xmlHttp.status == 200) {
        		var result = xmlHttp.responseText;
	            setProjectData(result);
            } else{// if (xmlHttp.status == 204){//�����Ͱ� �������� ���� ���
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
			document.sendInputForm.drawingTypeColumn.value = "����";
		}else{
			document.sendInputForm.drawingTypeColumn.value = "�񵵸�";
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
	            result = result.replace(/\s/g, ""); // ��������
	            
	            var serialCode = document.sendInputForm.serialCode.value;
	            
	            if(result != serialCode){
	            	alert("���� ������ �߽Ź��� ��ȣ�� �ٸ� ����ڿ� ���Ͽ� ���Ǿ� �ø��� �ѹ��� ("+result+") �� �����մϴ�.");
	            	document.sendInputForm.serialCode.value = result;
	            }
	            
            } else{// if (xmlHttp5.status == 204){//�����Ͱ� �������� ���� ���
            	//clearNames();
            }
        }
    }
        
    function docSave()
    {
    	//���� ���
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
		
    	var deptCode = document.sendInputForm.deptCode.value;
    	
    	//serialCode Check
    	if (window.ActiveXObject) {
        	xmlHttp5 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp5 = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassLetterFaxSerialCodeCheck.jsp?project="+project+"&ownerClass="+ownerClass;
        
        xmlHttp5.open("GET", url, false);
        xmlHttp5.onreadystatechange = callbackSerialCodeCheck;
        xmlHttp5.send(null);
    	
    	var serialCode = document.sendInputForm.serialCode.value;
    	
		var docSubject = document.sendInputForm.docSubject.value.toUpperCase();
		
		if(docSubject == ""){
    		alert("Please input the Subject.");
    		document.sendInputForm.docSubject.focus();
    		return;
    	}
    	
    	for (i=0; i<docSubject.length; i++) {
			valueCh = escape(docSubject.charAt(i));        
			if (strCharByte(valueCh) == 2) { 
				alert("Subject�� �ѱ��� �Է��� �� �����ϴ�.");
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
		
		// 2012-02-13 Kang seonjung : ���� ���� ������ �ݵ�� ���� ���� 1���̻� ���
		
		if(drawingFlag == "drawing")
		{
			var oTbl = document.getElementById('refDwgTable');
	    	var rownum = oTbl.rows.length;
			if(rownum < 2)
			{
				alert("���õ����� ����ϼ���.");
				return;
			}
		}
		
		var drawingMsg;
		if(drawingFlag == "drawing"){
			drawingMsg = "����";
		}else{
			drawingMsg = "�񵵸�";
		}
		
		if(confirm("Subject : "+docSubject+"\n\n"+drawingMsg+" ���� ������ Ȯ�� �Ͻðڽ��ϱ�?")){
			
		}else{
			return;
		}
		
		if (window.ActiveXObject) {
        	xmlHttp4 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp4 = new XMLHttpRequest();     
        }

        var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?project=" + project
				+ "&ownerClassType=" + ownerClass
				+ "&sendReceiveType=send"
				+ "&docType=D"
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&revNo=" 
				+ "&subject=" + docSubject
				+ "&sender=" + sendUser
				+ "&senderNo=" + userCode
				+ "&sendReceiveDate="
				+ "&sendReceiveDept=" + sendDepartment
				+ "&refDept=" 
				+ "&keyword=" + docKeyWord
				+ "&viewAccess=" + docViewAccess
				+ "&mode=doc"
				;

        xmlHttp4.open("GET", url, false);
        xmlHttp4.onreadystatechange = callbackDocSave;
        xmlHttp4.send(null);
    	
    	//���ù��� ���
    	
		for(i=1 ; i<document.getElementById('fromRefTable').rows.length ; i++){
			
			var oRow = document.getElementById('fromRefTable').rows[i];
			var tempRefNo = document.getElementById("fromRefNo" + oRow.uniqueNumber).value;
			var tempRefComment = document.getElementById("fromRefComment" + oRow.uniqueNumber).value;
			
			if(tempRefNo=="")
				continue;
			
			var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?project=" + project
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=document"
				+ "&objectNo=" + tempRefNo
				+ "&objectComment=" + tempRefComment
				+ "&mode=refdoc"
				;
        
	        xmlHttp4.open("GET", url, false);
	        xmlHttp4.onreadystatechange = callbackDocSave;
	        xmlHttp4.send(null);
		}
		
		//���õ��� ���
		for(i=1 ; i<document.getElementById('refDwgTable').rows.length ; i++){
			var oRow = document.getElementById('refDwgTable').rows[i];
			var tempProject = document.getElementById("refProject" + oRow.uniqueNumber).value;
			var tempDwgNo = document.getElementById("refDwgNo" + oRow.uniqueNumber).value;
			var tempDwgAppSubmit = document.getElementById("refDwgAppSubmit" + oRow.uniqueNumber).value;
			
			if(tempDwgNo=="")
				continue;
			
			var url = "stxPECBuyerClassLetterFaxDocumentSaveProcess.jsp"
        		+ "?project=" + tempProject
				+ "&refNo=" + "STX/"+ownerCode.replace("&","%26")+"-"+project+deptCode+"-"+serialCode
				+ "&objectType=drawing"
				+ "&objectNo=" + tempDwgNo
				+ "&objectComment="
				+ "&mode=refdoc"
				+ "&dwgAppSubmit=" + document.sendInputForm.refDwgAppSubmit.checked
				+ "&ownerClassType=" + ownerClass
				;
        
	        xmlHttp4.open("GET", url, false);
	        xmlHttp4.onreadystatechange = callbackDocSave;
	        xmlHttp4.send(null);
		}
    	
    	alert("����Ͻ� ������ȣ�� "+"STX/"+ownerCode+"-"+project+deptCode+"-"+serialCode+" �Դϴ�.\n\n�ش� Letter�� 'Letter/Fax Document Attach.'���� ��� �ϼ���.");
    	
        menu = eval("document.all.docSaveTD.style"); 
        menu.display="none";
        
        menu = eval("document.all.createDocTD.style"); 
        menu.display="";
        
    	return;
    	
    }
    
    function callbackDocSave() {
    	if (xmlHttp4.readyState == 4) {
        	if (xmlHttp4.status == 200) {
        		var result = xmlHttp4.responseText;
            } else{// if (xmlHttp4.status == 204){//�����Ͱ� �������� ���� ���
            	//clearNames();
            }
        }
    }
    
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
    	
    	var attURL = "stxPECBuyerClassLetterFaxOpenFile.jsp";
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
    		alert("���ð����� ��� - ȣ���� �Է��ϼ���.");
    		document.sendInputForm.refDocProject.focus();
    		return;
    	}
    	if(refDocNo == "" || refDocNo == "DOC NO"){
    		alert("���ð����� ��� - ���� ��ȣ�� �Է��ϼ���.");
    		document.sendInputForm.refDocNo.focus();
    		return;
    	}
    	if(refDocComment == "" || refDocComment == "COMMENT"){
    		alert("���ð����� ��� - ��� �Է��ϼ���.");
    		document.sendInputForm.refDocComment.focus();
    		return;
    	}
    	
    	if (window.ActiveXObject) {
        	xmlHttp3 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp3 = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassLetterFaxDocumentInfo.jsp?project="+refDocProject+"&document="+refDocNo;
        
        xmlHttp3.open("GET", url, false);
        xmlHttp3.send(null);
        
        if(xmlHttp3.status != 200)
        {
        	alert("Error! Status");
        	return;
        }
        
        setDocumentData(xmlHttp3.responseText,refDocComment);
        
        document.sendInputForm.refDocProject.value = refDocProject;
    	document.sendInputForm.refDocNo.value = "DOC NO";
    	document.sendInputForm.refDocComment.value = "COMMENT";
    	
    	return;
    }
    
    function setDocumentData(result,refDocComment)
    {
    	var splitResult = result.split("|");
    	if(splitResult[0].replace(/\s/g, "") == ""){
    		alert("Not exist document data");
    		return;
    	}
    	
    	var oTbl = document.getElementById('fromRefTable');
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
    	oCell8.className = 'baseTD';
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
    	var oTbl = document.getElementById('fromRefTable');
    	var rownum = oTbl.rows.length;
    	for(var i=rownum - 1;i>0;i--)
    	{
    		if(oTbl.rows[i].firstChild.firstChild.checked)
    		{
    			oTbl.deleteRow(i);
    		}
    	}
    }
    
    function refDwgSave()
    {
    	var refDwgProject 	= document.sendInputForm.refDwgProject.value;
    	var refDwgNo 		= document.sendInputForm.refDwgNo.value;
    	var refDwgAppSubmit	= document.sendInputForm.refDwgAppSubmit.checked;
    	
    	if(refDwgProject == "" || refDwgProject == "PROJECT"){
    		alert("���õ��� ��� - ȣ���� �Է��ϼ���.");
    		document.sendInputForm.refDwgProject.focus();
    		return;
    	}
    	if(refDwgNo == "" || refDwgNo == "DWG NO"){
    		alert("���õ��� ��� - ���� ��ȣ�� �Է��ϼ���.");
    		document.sendInputForm.refDwgNo.focus();
    		return;
    	}
    	
    	if (window.ActiveXObject) {
        	xmlHttp2 = new ActiveXObject("Microsoft.XMLHTTP");
        }
        else if (window.XMLHttpRequest) {
        	xmlHttp2 = new XMLHttpRequest();     
        }
        var url = "stxPECBuyerClassLetterFaxDrawingInfo.jsp?project="+refDwgProject+"&drawing="+refDwgNo;
        
        xmlHttp2.open("GET", url, false);
        xmlHttp2.send(null);
        
        if(xmlHttp2.status != 200)
        {
        	alert("Error! Status");
        	return;
        }
        setDrawingData(xmlHttp2.responseText)
    	
    	document.sendInputForm.refDwgProject.value = refDwgProject;
    	document.sendInputForm.refDwgNo.value = "DWG NO";
    	
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
    	
    	var oTbl = document.getElementById('refDwgTable');
    	var rownum = oTbl.rows.length;
    	var oRow = oTbl.insertRow(rownum);
    	oRow.className = 'baseTD';
    	addNewCellwithChild(oRow.insertCell(),fnCheckBoxHtml("chkDwg","chkDwg"+oRow.uniqueNumber,""),"baseTD");
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
    	}
    	var checkValue = splitResult[0].replace(/\s/g, "");
    	if(checkValue == ""){
    		alert("Not exist drawing data");
    		return;
    	}
    }
    
    function refDwgDelete()
    {
    	var oTbl = document.getElementById('refDwgTable');
    	var rownum = oTbl.rows.length;
    	for(var i=rownum - 1;i>0;i--)
    	{
    		if(oTbl.rows[i].firstChild.firstChild.checked)
    		{
    			oTbl.deleteRow(i);
    		}
    	}
		return;
    }
    
    function viewRefFile(obj){
    	var refNo = document.getElementById("fromRefNo"+obj.parentNode.parentNode.uniqueNumber).value;
    	var attURL = "stxPECBuyerClassLetterFaxViewFileDialogFS.jsp";
	    attURL += "?refNo=" + refNo.replace("&","%26");
	    
		showModalDialog(attURL, 400, 400);
    }
    
    function closeDialog(){
    	top.parent.window.close();
    }
    
    function dwgAppSubmit(obj){
    	if(obj.checked){
    		var project = document.sendInputForm.project.value;
    		var refDwgProject = document.sendInputForm.refDwgProject.value;
    		if(project!=refDwgProject){
    			alert("���õ� ȣ���� ��� ȣ���� �ٸ��� �ش� ����� ����� �� �����ϴ�.");
    			obj.checked = false;
    		}
    	}
    	
    	if(obj.checked){
    		if(document.sendInputForm.drawingFlag[0].checked)obj.checked = false;
    	}
    }
    
    //���籸�� , ���� , ���� ���� Script
    function showProjectSelectWin()
    {
    	var userCode = document.sendInputForm.userCode.value;
        var sProperties = 'dialogHeight:340px;dialogWidth:400px;scroll=no;center:yes;resizable=no;status=no;';
        var selectedProjects = parent.window.showModalDialog("stxPECDPInput_ProjectSelect.jsp?designerID="+userCode , '' , sProperties);
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
            
            // ���� ������ ȣ������� ��� ����
            for (var j = pjtSelObj.options.length - 1; j >= 2; j--)  pjtSelObj.options[j] = null; // 0 ��°�� '', 1 ��°�� 'S000' �̹Ƿ� 2 ��° ���� ó��

            var isExist = false;

            // ����� ȣ��������� �ٽ� ä���
            for (var j = 0; j < selectedProjectsList.length; j++) {
                var projectNoStr = selectedProjectsList[j];
                pjtSelObj.options[j + 2] = new Option(projectNoStr, projectNoStr);
                
                // selected ����
                if (currentSelectedValue == projectNoStr) {
                    pjtSelObj.selectedIndex = j + 2;
                    isExist = true;
                }
            }

            // ���õ� ȣ���� ������ ȣ���̸� �� �׸� ���ؼ��� �ش� ȣ���� �߰�
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
        
        // ���鱸�� �� �ʱ�ȭ
        drwTypeObj.value = ''; 
        for (var i = drwTypeSelObj.options.length - 1 ; i > 0; i--) drwTypeSelObj.options[i] = null;
        // �����ȣ �� �ʱ�ȭ
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;

        // �����ȣ(ȣ��)�� 'S000'�̸� �����ȣ�� '*****'�� �����ϰ�, �� ���� ��쿡�� �ش� ȣ���� ���� ���鱸�� ����� DB���� ����...
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

		xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingTypesForWork&departCode=" + document.sendInputForm.teamCode.value + "&projectNo=" + pjtSelObj.value, false);
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
        
        // �����ȣ �� �ʱ�ȭ
        drwNoObj.value = ''; 
        for (var i = drwNoSelObj.options.length - 1 ; i > 0; i--) drwNoSelObj.options[i] = null;

        // ���鱸�� ���� ���� ���� �ش� ȣ�� & �μ��� �۾� ��� ���� ����� ��񿡼� ����
        if (drwTypeValue == '') {
            drwNoObj.value = '';
        }
        else {
            drawingListForWorkQueryProc(pjtSelObj, drwTypeValue, drwNoSelObj, "");

            // �����ȣ ���� ��Ʈ���� Show
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
            
            // �����ȣ�� �ִµ� ���鱸���� ���� ��쿡�� '*****' �� ǥ���Ѵ�
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

        xmlHttp.open("GET", "stxPECDP_GeneralAjaxProcess.jsp?requestProc=GetDrawingListForWork&departCode=" + document.sendInputForm.teamCode.value + "&projectNo=" + pjtSelObj.value + "&drawingType=" + drwTypeValue, false);
        xmlHttp.send(null);

        if (xmlHttp.status == 200) {
            if (xmlHttp.statusText == "OK") {
                var resultMsg = xmlHttp.responseText;
                
                if (resultMsg != null)
                {
                    resultMsg = resultMsg.replace(/\s/g, "");
                    if (resultMsg == 'ERROR') alert(resultMsg);
                    else {
                        var strs = resultMsg.split("��");
                        drwNoSelObj.selectedIndex = 0;                                
                        for (var i = 0; i < strs.length; i++) {
                            if (strs[i] == "") continue;
                            var strs2 = strs[i].split("��");
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
    	
    	var url = "stxPECBuyerClassLetterFaxUserSelectFS.jsp"
    	        + "?formName=sendInputForm"
    	        +"&fieldName1=sendDepartment"
    	        +"&fieldName2=silCode"
    	        +"&fieldName3=teamCode"
    	        +"&fieldName4=sendUser"
    	        +"&fieldName5=userCode"
    	        +"&userCode=" + userCode
    	        +"&teamCode=" + teamCode
    	        
    	        ;
    	        
    	showModalDialog(url,600,575);
    }
    
	menu = eval("document.all.buttonTable.style"); menu.display="none";
	
	menu = eval("document.all.docSaveTD.style"); menu.display="none";
	menu = eval("document.all.createDocTD.style"); menu.display="none";
	menu = eval("document.all.closeTD.style"); menu.display="none";
	
	<% if("N".equals(docView)){%>
		document.all.docViewAccess(0).disabled = true;
		document.all.docViewAccess(0).visibility = "hidden";
		document.all.docViewAccess(1).disabled = true;
		document.all.docViewAccess(1).visibility = "hidden";
	<%}%>
</script>

</html>

