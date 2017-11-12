<%--  
§DESCRIPTION: 설계시수입력 - Ajax 서비스 로직들
§AUTHOR (MODIFIER): Hyesoo Kim
§FILENAME: stxPECDP_GeneralAjaxProcess.jsp
§CHANGING HISTORY: 
§    2009-04-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<%@ include file="/WEB-INF/jsp/dps/common/stxPECDP_Include.jsp"%>
<%--========================== JSP =========================================--%>
<%
	String requestProc = request.getParameter("requestProc");

    String resultMsg = "";
    //===================================================================
    // 해당 날자가 평일인지 휴일인지 쿼리
    if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayYN")) {
        String dateStr = request.getParameter("dateStr");
        
        try {resultMsg = getDateHolidayInfo(dateStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
  	//===================================================================
    // 해당 날짜의 평일/휴일 여부 및 시수결재 완료 여부를 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayInfoAndConfirmYN")) {
        String employeeID = request.getParameter("dpDesignerID");
        String dateStr = request.getParameter("dateStr");
        
        try {
            resultMsg = getDateHolidayInfo(dateStr); 
            resultMsg += "|" + getDPInputLockDate(employeeID); //resultMsg += "|" + getWorkDaysGap(dateStr);
            resultMsg += "|" + getMHInputConfirmYN(employeeID, dateStr);
            System.out.println(resultMsg);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 설계자(부서)의 시수입력 LOCK 일자를 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDPInputLockDate")) {
        try { resultMsg += getDPInputLockDate(request.getParameter("empNo")); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    //// 해당 날짜와 오늘날자 사이에 Work Day가 몇일 존재하는지 쿼리
    //else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkDaysGap")) {
    //    try { resultMsg += getWorkDaysGap(request.getParameter("dateStr")); }
    //    catch (Exception e) { resultMsg = "ERROR"; }
    //}
	//===================================================================
    // 해당 날짜의 시수결재 완료 여부를 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetConfirmYN")) {
        String employeeID = request.getParameter("dpDesignerID");
        String dateStr = request.getParameter("dateStr");
        
        try {
            resultMsg = getMHInputConfirmYN(employeeID, dateStr);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 사번 + 기간에 결재완료된 입력시수가 존재하는지 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDesignMHConfirmExist")) {
        String employeeID = request.getParameter("dpDesignerID");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        try {
            resultMsg = getDesignMHConfirmExist(employeeID, fromDate, toDate);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 사용자 선택 프로젝트 목록을 업데이트
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateSelectedProjects")) {
        String employeeID = request.getParameter("dpDesignerID");
        String projectList = request.getParameter("projectList");
        
        try {
            updateSelectedProjectList(employeeID, FrameworkUtil.split(projectList, "|")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서 + 호선에 대한 작업 대상 도면들의 목록(구분 값 - 도면 첫 글자 ONLY) 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingTypesForWork")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        
        try { resultMsg = getDrawingTypesForWork(departCode, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서 + 호선 + 도면타입에 대한 작업 대상 도면들의 목록 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        String drawingType = request.getParameter("drawingType");
        
        try { resultMsg = getDrawingListForWork(departCode, projectNo, drawingType); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서 + 호선에 대한 작업 대상 도면들의 목록 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork2")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        
        try { resultMsg = getDrawingListForWork2(departCode, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 호선 + 도면코드에 대한 도면정보를 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork3")) {
        String projectNo = request.getParameter("projectNo");
        String departCode = request.getParameter("departCode");
        String dwgNo = request.getParameter("dwgNo");
        
        try { resultMsg = getDrawingListForWork3(projectNo, departCode, dwgNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 입력시수를 디비에 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDPInputs")) {
        String designerID = request.getParameter("designerID");
        String dateStr = request.getParameter("dateStr");
        String loginID = request.getParameter("loginID");
        String inputDoneYN = request.getParameter("inputDoneYN");

        ArrayList paramList = new ArrayList();

        for (int i = 0; i < timeKeys.length; i++) {
            String timeKey = request.getParameter("timeKey" + timeKeys[i]);
            if (StringUtil.isNullString(timeKey)) continue;

            String timeStr = timeKey.substring(0, 2) + ":" + timeKey.substring(2);

            HashMap map = new HashMap();
            map.put("timeStr", timeStr);
            map.put("pjt", request.getParameter("pjt" + timeKey));
            map.put("drwType", request.getParameter("drwType" + timeKey));
            map.put("drwNo", request.getParameter("drwNo" + timeKey));
            map.put("op", request.getParameter("op" + timeKey));
            map.put("depart", request.getParameter("depart" + timeKey));
            map.put("basis", replaceAmpAll(replaceAmpAll(request.getParameter("basis" + timeKey), "‥", "&"), "¨", "%"));
            map.put("workContent", replaceAmpAll(replaceAmpAll(request.getParameter("workContent" + timeKey), "‥", "&"), "¨", "%"));
            map.put("event1", request.getParameter("event1" + timeKey));
            map.put("event2", request.getParameter("event2" + timeKey));
            map.put("event3", request.getParameter("event3" + timeKey));
            map.put("normalTime", request.getParameter("normalTime" + timeKey));
            map.put("overtime", request.getParameter("overtime" + timeKey));
            map.put("specialTime", request.getParameter("specialTime" + timeKey));
            map.put("shipType", request.getParameter("shipType" + timeKey));

            paramList.add(map);
        }

        try { saveDPInputs(designerID, dateStr, loginID, paramList, inputDoneYN); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 입력시수를 디비에 저장(1 일 이상(호선선택 없음) - 예비군훈련, 년차, 특별휴가, 기술회의 및 교육, 일반출장 등)
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveAsOneDayOverJobDPInputs")) {
        String designerID = request.getParameter("designerID");
        String fromDateStr = request.getParameter("fromDateStr");
        String toDateStr = request.getParameter("toDateStr");
        String workContentStr = request.getParameter("workContentStr");
        String opCode = request.getParameter("opCode");
        String loginID = request.getParameter("loginID");

        try { resultMsg = saveAsOneDayOverJobDPInputs(designerID, fromDateStr, toDateStr, workContentStr, opCode, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 입력시수를 디비에 저장(1 일 이상(호선선택 포함) - 사외 협의 검토)
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveAsOneDayOverJobWithProjectDPInputs")) {
        String designerID = request.getParameter("designerID");
        String projectNo = request.getParameter("projectNo");
        String fromDateStr = request.getParameter("fromDateStr");
        String toDateStr = request.getParameter("toDateStr");
        String workContentStr = request.getParameter("workContentStr");
        String opCode = request.getParameter("opCode");
        String loginID = request.getParameter("loginID");

        try { resultMsg = saveAsOneDayOverJobWithProjectDPInputs(designerID, projectNo, fromDateStr, toDateStr, workContentStr, opCode, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 입력시수를 디비에 저장(시운전 Only 케이스)
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveSeaTrialDPInputs")) {
        String designerID = request.getParameter("designerID");
        String dateStr = request.getParameter("dateStr");
        String loginID = request.getParameter("loginID");
        String projectNo = request.getParameter("projectNo");

        try { saveSeaTrialDPInputs(designerID, dateStr, loginID, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서(파트)의 구성원(파트원) 목록을 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetPartPersons")) {
        String departCode = request.getParameter("departCode");
        
        try { 
            ArrayList resultArrayList = null;

            // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
            if (departCode.startsWith("Z")) resultArrayList = getPartPersons_Dalian(departCode); 
            else resultArrayList = getPartPersons(departCode); 

            for (int i = 0; i < resultArrayList.size(); i++) {
                Map map = (Map)resultArrayList.get(i);
            	if (!resultMsg.equals("")) resultMsg += "+";
				resultMsg += (String)map.get("EMPLOYEE_NO") + "|" + (String)map.get("EMPLOYEE_NAME");
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서(파트)의 구성원(파트원) 목록을 쿼리 - 다수 개 부서에 대한 조회 가능
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetPartPersons2")) {
        String departCodes = request.getParameter("departCodes");

        String departCodesStr = "";
        ArrayList departCodeList = FrameworkUtil.split(departCodes, ",");
        for (int i = 0; i < departCodeList.size(); i++) {
            if (i > 0) departCodesStr += ",";
            departCodesStr += "'" + (String)departCodeList.get(i) + "'";
        }
        
        try { 
            ArrayList resultArrayList = getPartPersons2(departCodesStr); 
            for (int i = 0; i < resultArrayList.size(); i++) {
                Map map = (Map)resultArrayList.get(i);
            	if (!resultMsg.equals("")) resultMsg += "+";
				resultMsg += (String)map.get("EMPLOYEE_NO") + "|" + (String)map.get("EMPLOYEE_NAME");
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 부서(파트)의 공정담당 구성원(파트원) 목록을 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("getPartPersonsForDPProgress")) {
        String departCode = request.getParameter("departCode");
        
        try { 
            ArrayList resultArrayList = null;

            // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
            if (departCode.startsWith("Z")) resultArrayList = getPartPersons_Dalian(departCode); 
            else resultArrayList = getPartPersonsForDPProgress(departCode); 

            for (int i = 0; i < resultArrayList.size(); i++) {
                Map map = (Map)resultArrayList.get(i);
            	if (!resultMsg.equals("")) resultMsg += "+";
				resultMsg += (String)map.get("EMPLOYEE_NO") + "|" + (String)map.get("EMPLOYEE_NAME");
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 해당 날짜의 휴일 여부와, 사번 + 날짜의 시수입력 사항을 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayDesignMHInputs")) {
        String designerID = request.getParameter("designerID");
        String dateSelected = request.getParameter("dateSelected");
        
        try {
            resultMsg = getDateHolidayInfo(dateSelected); 
            if (resultMsg != null && resultMsg.equals("Y")) // 평일인 경우에만 COPY 대상이됨
            {
                resultMsg = "";

                ArrayList resultArrayList = getDesignMHInputs(designerID, dateSelected); 
                for (int i = 0; i < resultArrayList.size(); i++) {
                    Map map = (Map)resultArrayList.get(i);
                    /* UTF-8 적용으로 특수문자 인식 오류가 발생하나, 본 기능은 사용되지 않으므로 그냥 둠 */
                    if (!resultMsg.equals("")) resultMsg += "∥"; 
                    resultMsg += (String)map.get("START_TIME") + "‥";
                    resultMsg += (String)map.get("PROJECT_NO") + "‥";
                    resultMsg += (String)map.get("DWG_TYPE") + "‥";
                    resultMsg += (String)map.get("DWG_CODE") + "‥";
                    resultMsg += (String)map.get("OP_CODE") + "‥";
                    resultMsg += (String)map.get("CAUSE_DEPART") + "‥";
                    resultMsg += (String)map.get("BASIS") + "‥";
                    resultMsg += (String)map.get("WORK_DESC") + "‥";
                    resultMsg += (String)map.get("EVENT1") + "‥";
                    resultMsg += (String)map.get("EVENT2") + "‥";
                    resultMsg += (String)map.get("EVENT3") + "‥";
                }
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 시수결재 사항을 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveApprovals")) {
        String applyStrs = request.getParameter("applyStrs");
        String dateStr = request.getParameter("dateStr");
        String loginID = request.getParameter("loginID");
        String deptCode = request.getParameter("deptCode");
        String allChecked = request.getParameter("allChecked");

        try { 
            resultMsg = saveApprovals(applyStrs, dateStr, loginID, deptCode, allChecked); 
            if (!resultMsg.equals("")) {
                resultMsg = "다음 인원은 '계획시수 대비 초과 내역'이 존재하여 전체결재 대상에서 제외되었습니다!\n" + 
                            "'계획시수 대비 초과 내역' 확인 후 한 명씩 시수결재를 진행하시기 바랍니다!\n\n" + resultMsg;
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 선택된 날짜의 입력시수를 일괄 삭제
    else if (requestProc != null && requestProc.equalsIgnoreCase("DeleteDPInputs")) {
        String designerID = request.getParameter("designerID");
        String dateStr = request.getParameter("dateStr");

        try { deleteDPInputs(designerID, dateStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 선택된 도면에 대한 공정정보 조회
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDesignProgressInfo")) {
        String projectNo = request.getParameter("projectNo");
        String drawingNo = request.getParameter("drawingNo");

        try { resultMsg = getDesignProgressInfo(projectNo, drawingNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 선택된 도면의 출도일자 조회
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingWorkStartDate")) {
        String projectNo = request.getParameter("projectNo");
        String drawingNo = request.getParameter("drawingNo");

        try { resultMsg =  getDrawingWorkStartDate(projectNo, drawingNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 공정 실제시수 입력사항 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDPProgress")) {
        String projectNo = request.getParameter("projectNo");
        String inputDates = request.getParameter("inputDates");
        String inputPersons = request.getParameter("inputPersons");
        String inputOutsidePersons = request.getParameter("inputOutsidePersons");
        String loginID = request.getParameter("loginID");
       
        try { saveDPProgress(projectNo, inputDates, inputPersons, inputOutsidePersons, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 공정지연 사유 등 입력사항 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDPProgressDev")) {
        String inputDataList = request.getParameter("inputDataList");
        String descChangedValues = request.getParameter("descChangedValues");
        String inputDates = request.getParameter("inputDates");
        String loginID = request.getParameter("loginID");

        try { saveDPProgressDev(inputDataList, descChangedValues, inputDates, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 공정부분 조회가능 프로젝트 목록 업데이트
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateSearchableProjectList")) {
        String params = request.getParameter("params");
        String loginID = request.getParameter("loginID");
        String category = request.getParameter("category");

        try {
            updateSearchableProjectList(FrameworkUtil.split(params, ","), loginID, category); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 시수입력 LOCK 정보 업데이트
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateDPInputLockList")) {
        String params = request.getParameter("params");

        try {
            updateDPInputLockList(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 공정(실적) 입력 LOCK 정보 업데이트
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateDPProgressLockList")) {
        String params = request.getParameter("params");

        try {
            updateDPProgressLockList(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 시수 적용율 Default(Active) Case를 업데이트
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateActiveMHFactorCase")) {
        String params = request.getParameter("params");

        try {
            ArrayList paramsList = FrameworkUtil.split(params, ",");
            updateActiveMHFactorCase((String)paramsList.get(0), (String)paramsList.get(1)); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 시수 적용율 Case를 추가
    else if (requestProc != null && requestProc.equalsIgnoreCase("AddActiveMHFactorCase")) {
        String params = request.getParameter("params");

        try {
            addActiveMHFactorCase(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 설계시수 DATA 관리에서 부서 수정 시 수정사항 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDepartmentChange")) {
        String deptChanged = request.getParameter("deptChanged");
        String loginID = request.getParameter("loginID");

        try { saveDepartmentChange(deptChanged, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 호선 별 설계시수를 ERP로 I/F
    else if (requestProc != null && requestProc.equalsIgnoreCase("ProjectDataERPIF")) {
        String dataList = request.getParameter("dataList");
        String createDate = request.getParameter("createDate");
        String targetStr = request.getParameter("targetStr");
        
        try { executeProjectDataERPIF(dataList, createDate, targetStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    // 도면 출도대장(Hard Copy) 입력을 디비에 저장
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveHardCopyInputs")) {
        String loginID = request.getParameter("loginID");
        String deployNoPrefix = request.getParameter("deployNoPrefix");
        String deptCode = request.getParameter("deptCode");
        String requestDate = request.getParameter("requestDate");
        String deployDate = request.getParameter("deployDate");
        String gubun = request.getParameter("gubun");

        ArrayList paramList = new ArrayList();
        int maxCnt = Integer.parseInt(request.getParameter("maxCnt"));

        for (int i = 0; i < maxCnt; i++) {
            String project = request.getParameter("project" + i);
            if (StringUtil.isNullString(project)) continue;

            HashMap map = new HashMap();
            map.put("project", project);
            map.put("rev", request.getParameter("rev" + i));
            map.put("dwg", request.getParameter("dwg" + i));
            map.put("dwgDesc", replaceAmpAll(replaceAmpAll(request.getParameter("dwgDesc" + i), "‥", "&"), "¨", "%"));
            map.put("ecoNo", request.getParameter("ecoNo" + i));
            map.put("reasonCode", request.getParameter("reasonCode" + i));
            map.put("causeDept", request.getParameter("causeDept" + i));
            map.put("revTiming", request.getParameter("revTiming" + i));
            map.put("deployDesc", replaceAmpAll(replaceAmpAll(request.getParameter("deployDesc" + i), "‥", "&"), "¨", "%"));
            paramList.add(map);
        }

        try { resultMsg = saveHardCopyInputs(loginID, deployNoPrefix, deptCode, requestDate, deployDate, gubun, paramList); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
	//===================================================================
    /****  DIS-ERROR : ECO 정보 가져오는 부분 수정필요
    // PLM에서 ECO 정보를 GET 
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetECOInfo")) {
        String ecoNo = request.getParameter("ecoNo");

        try { 
            String whereExp = "name == '" + ecoNo + "' && revision == '-'";
            ArrayList selects = new ArrayList();
            selects.addElement(DomainObject.SELECT_DESCRIPTION);
            selects.addElement("attribute[Category of Change]");
            ArrayList ArrayList = DomainObject.findObjects(context, "ECO", "eService Production", whereExp, selects);
            if (ArrayList.size() > 0) {
                Map map = (Map)ArrayList.get(0);
                resultMsg = (String)map.get("attribute[Category of Change]") + "|" + (String)map.get(DomainObject.SELECT_DESCRIPTION);
            }
            else resultMsg = "";
        }
        catch (Exception e) { 
            resultMsg = "ERROR"; 
        }
    }
    *****/
	//===================================================================
    else if (requestProc != null && requestProc.equalsIgnoreCase("saveSelectedProjects")) {
        String loginID = request.getParameter("loginID");
        String projects = request.getParameter("projects");
        System.out.println(projects);
        ArrayList slPrj = FrameworkUtil.split(projects,",");
        try { 
        	resultMsg = saveSelectedProjects(loginID,slPrj);
        }
        catch (Exception e) { 
            resultMsg = "ERROR"; 
        }
        System.out.println(resultMsg);
    }
	//===================================================================
    else if (requestProc != null && requestProc.equalsIgnoreCase("saveDELAYREASON_DESC")) {
        String projectNo 		= request.getParameter("projectNo");
        String dwgCode 			= request.getParameter("dwgCode");
        String DELAYREASON_DESC = request.getParameter("DELAYREASON_DESC");
        String designerId 		= request.getParameter("designerId");
        try { 
        	resultMsg = saveDELAYREASON_DESC(projectNo,dwgCode,DELAYREASON_DESC,designerId);
        }
        catch (Exception e) { 
        	e.printStackTrace();
            resultMsg = "ERROR"; 
        }
    }
	//===================================================================
    else if (requestProc != null && requestProc.equalsIgnoreCase("setChangableDPDate")) {
    	System.out.println("1111");
    	String[] arrBASIC 		= request.getParameterValues("BASIC");
    	String[] arrMAKER 		= request.getParameterValues("MAKER");
    	String[] arrPRODUCT 	= request.getParameterValues("PRODUCT");
    	
    	ArrayList slBASIC = getArrayToList(arrBASIC);
    	ArrayList slMaker = getArrayToList(arrMAKER);
    	ArrayList slPRODUCT = getArrayToList(arrPRODUCT);
    	
    	ArrayList mlDeleteList = new ArrayList();
    	
    	ArrayList mlDWGTYPEnKIND = getPLM_DATE_CHANGE_ABLE_DWG_TYPE();
    	Iterator itrDWGTypeKind = mlDWGTYPEnKIND.iterator();
    	
    	while(itrDWGTypeKind.hasNext())
    	{
    		Map mapDWGTypeKind = (Map)itrDWGTypeKind.next();
    		String DWG_KIND = (String)mapDWGTypeKind.get("DWG_KIND");
    		String DWG_TYPE = (String)mapDWGTypeKind.get("DWG_TYPE");
    		if(DWG_KIND.equals("기본도"))
    		{
    			if(slBASIC.contains(DWG_TYPE))
   				{
    				slBASIC.remove(DWG_TYPE);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
    		if(DWG_KIND.equals("MAKER"))
    		{
    			if(slMaker.contains(DWG_TYPE))
   				{
    				slMaker.remove(DWG_TYPE);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
    		if(DWG_KIND.equals("생설도"))
    		{
    			if(slPRODUCT.contains(DWG_TYPE))
   				{
    				slPRODUCT.remove(DWG_TYPE);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
    	}
    	
    	for(int index = 0;index<slBASIC.size();index++)
    	{
    		String DWG_TYPE = (String)slBASIC.get(index);
    		addPLM_DATE_CHANGE_ABLE_DWG_TYPE("기본도",DWG_TYPE);
    	}
    	for(int index = 0;index<slMaker.size();index++)
    	{
    		String DWG_TYPE = (String)slMaker.get(index);
    		addPLM_DATE_CHANGE_ABLE_DWG_TYPE("MAKER",DWG_TYPE);
    	}
    	for(int index = 0;index<slPRODUCT.size();index++)
    	{
    		String DWG_TYPE = (String)slPRODUCT.get(index);
    		addPLM_DATE_CHANGE_ABLE_DWG_TYPE("생설도",DWG_TYPE);
    	}
    	
    	Iterator itrDelete = mlDeleteList.iterator();
    	
    	while(itrDelete.hasNext())
    	{
    		Map mapDWGTypeKind = (Map)itrDelete.next();
    		String DWG_KIND = (String)mapDWGTypeKind.get("DWG_KIND");
    		String DWG_TYPE = (String)mapDWGTypeKind.get("DWG_TYPE");
    		delPLM_DATE_CHANGE_ABLE_DWG_TYPE(DWG_KIND,DWG_TYPE);
    	}
    	
        String params 			= request.getParameter("params");
        ArrayList slParam = FrameworkUtil.split(params,",");
        Iterator itrParam = slParam.iterator();
        while(itrParam.hasNext())
        {
        	String param = (String)itrParam.next();
        	ArrayList slInfo = FrameworkUtil.split(param,"|");
        	
        	if(slInfo.size() > 2)
        	{
        		String PROJECTNO 	= (String)slInfo.get(0);
        		String DWG_KIND 	= (String)slInfo.get(1);
        		String MODE 		= (String)slInfo.get(2);
        		System.out.println(slInfo);
        		try { 
        			if(MODE == null)
        			{
        				break;
        			} else if(MODE.equals("CLOSED"))
        			{
        				resultMsg = setAbleChangeDPDateProject(PROJECTNO,DWG_KIND);
        				if(!resultMsg.equals(""))break;
        			} else if(MODE.equals("OPENED"))
        			{
        				resultMsg = setDisableChangeDPDateProject(PROJECTNO,DWG_KIND);
        				if(!resultMsg.equals(""))break;
        			}
                }
                catch (Exception e) { 
                	e.printStackTrace();
                    resultMsg = "ERROR"; 
                }
        	}
        }
        //if(resultMsg.equals(""))resultMsg = "저장완료되었습니다.";
    }
	//===================================================================
    else if (requestProc != null && requestProc.equalsIgnoreCase("getAbleChangeDPDate")) {
        String PROJECTNO 		= request.getParameter("PROJECTNO");
        String ACTIVITYCODE 	= request.getParameter("ACTIVITYCODE");
        String startFinishCode 	= request.getParameter("startFinishCode");
        try { 
        	ArrayList mlList = getChangableDateDPList(PROJECTNO,ACTIVITYCODE,startFinishCode);
        	System.out.println(mlList);
        	if(mlList.size() == 0 )
        	{
        		resultMsg = "OK";
        	}  else {
        		// 매뉴얼 입력 제외 대상 중에 일부 생설도는 예외로 매뉴얼 입력 가능
                for (int i = 0; mlList != null && i < mlList.size(); i++)
                {
                    Map mlListMap = (Map)mlList.get(i);
                    String checkFlag = (String)mlListMap.get("CHECKFLAG");
                    if("Y".equals(checkFlag))
                    {
                    	resultMsg = "OK";
                    } else {
                    	resultMsg = "";
                    }
                }
        	}
        }
        catch (Exception e) { 
        	e.printStackTrace();
            resultMsg = "ERROR"; 
        }
    }
	//===================================================================
    // 선종 리스트 쿼리
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetShipType")) {
        
        try { resultMsg = getShipType(); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }    
%>
<%=resultMsg%>