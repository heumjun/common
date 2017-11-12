<%--  
��DESCRIPTION: ����ü��Է� - Ajax ���� ������ 
��AUTHOR (MODIFIER): Hyesoo Kim
��FILENAME: stxPECDP_GeneralAjaxProcess.jsp 
��CHANGING HISTORY: 
��    2009-04-23: Initiative
--%>

<%--========================== PAGE DIRECTIVES =============================--%>

<%@ include file = "stxPECDP_Include_SP.jspf" %>

<%@ page contentType="text/html; charset=euc-kr" %>

<%--========================== JSP =========================================--%>
<%
	String requestProc = request.getParameter("requestProc");

    String resultMsg = "";

    // �ش� ���ڰ� �������� �������� ����
    if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayYN")) {
        String dateStr = request.getParameter("dateStr");
        
        try {resultMsg = getDateHolidayInfo(dateStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �ش� ��¥�� ����/���� ���� �� �ü����� �Ϸ� ���θ� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayInfoAndConfirmYN")) {
        String employeeID = request.getParameter("dpDesignerID");
        String dateStr = request.getParameter("dateStr");
        
        try {
            resultMsg = getDateHolidayInfo(dateStr); 
            resultMsg += "|" + getDPInputLockDate(employeeID); //resultMsg += "|" + getWorkDaysGap(dateStr);
            resultMsg += "|" + getMHInputConfirmYN(employeeID, dateStr);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ������(�μ�)�� �ü��Է� LOCK ���ڸ� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDPInputLockDate")) {
        try { resultMsg += getDPInputLockDate(request.getParameter("empNo")); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    //// �ش� ��¥�� ���ó��� ���̿� Work Day�� ���� �����ϴ��� ����
    //else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkDaysGap")) {
    //    try { resultMsg += getWorkDaysGap(request.getParameter("dateStr")); }
    //    catch (Exception e) { resultMsg = "ERROR"; }
    //}
    // �ش� ��¥�� �ü����� �Ϸ� ���θ� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetConfirmYN")) {
        String employeeID = request.getParameter("dpDesignerID");
        String dateStr = request.getParameter("dateStr");
        
        try {
            resultMsg = getMHInputConfirmYN(employeeID, dateStr);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ��� + �Ⱓ�� ����Ϸ�� �Է½ü��� �����ϴ��� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDesignMHConfirmExist")) {
        String employeeID = request.getParameter("dpDesignerID");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        
        try {
            resultMsg = getDesignMHConfirmExist(employeeID, fromDate, toDate);
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ����� ���� ������Ʈ ����� ������Ʈ
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateSelectedProjects")) {
        String employeeID = request.getParameter("dpDesignerID");
        String projectList = request.getParameter("projectList");
        
        try {
            updateSelectedProjectList(employeeID, FrameworkUtil.split(projectList, "|")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �μ� + ȣ���� ���� �۾� ��� ������� ���(���� �� - ���� ù ���� ONLY) ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingTypesForWork")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        
        try { resultMsg = getDrawingTypesForWork(departCode, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �μ� + ȣ�� + ����Ÿ�Կ� ���� �۾� ��� ������� ��� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        String drawingType = request.getParameter("drawingType");
        
        try { resultMsg = getDrawingListForWork(departCode, projectNo, drawingType); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �μ� + ȣ���� ���� �۾� ��� ������� ��� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork2")) {
        String departCode = request.getParameter("departCode");
        String projectNo = request.getParameter("projectNo");
        
        try { resultMsg = getDrawingListForWork2(departCode, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ȣ�� + �����ڵ忡 ���� ���������� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingListForWork3")) {
        String projectNo = request.getParameter("projectNo");
        String departCode = request.getParameter("departCode");
        String dwgNo = request.getParameter("dwgNo");
        
        try { resultMsg = getDrawingListForWork3(projectNo, departCode, dwgNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �Է½ü��� ��� ����
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
            map.put("basis", replaceAmpAll(replaceAmpAll(request.getParameter("basis" + timeKey), "��", "&"), "��", "%"));
            map.put("workContent", replaceAmpAll(replaceAmpAll(request.getParameter("workContent" + timeKey), "��", "&"), "��", "%"));
            map.put("event1", request.getParameter("event1" + timeKey));
            map.put("event2", request.getParameter("event2" + timeKey));
            map.put("event3", request.getParameter("event3" + timeKey));
            map.put("normalTime", request.getParameter("normalTime" + timeKey));
            map.put("overtime", request.getParameter("overtime" + timeKey));
            map.put("specialTime", request.getParameter("specialTime" + timeKey));

            paramList.add(map);
        }

        try { saveDPInputs(designerID, dateStr, loginID, paramList, inputDoneYN); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �Է½ü��� ��� ����(1 �� �̻�(ȣ������ ����) - �����Ʒ�, ����, Ư���ް�, ���ȸ�� �� ����, �Ϲ����� ��)
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
    // �Է½ü��� ��� ����(1 �� �̻�(ȣ������ ����) - ��� ���� ����)
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
    // �Է½ü��� ��� ����(�ÿ��� Only ���̽�)
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveSeaTrialDPInputs")) {
        String designerID = request.getParameter("designerID");
        String dateStr = request.getParameter("dateStr");
        String loginID = request.getParameter("loginID");
        String projectNo = request.getParameter("projectNo");

        try { saveSeaTrialDPInputs(designerID, dateStr, loginID, projectNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �μ�(��Ʈ)�� ������(��Ʈ��) ����� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetPartPersons")) {
        String departCode = request.getParameter("departCode");
        
        try { 
            ArrayList resultArrayList = null;

            // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
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
    // �μ�(��Ʈ)�� ������(��Ʈ��) ����� ���� - �ټ� �� �μ��� ���� ��ȸ ����
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
    // �μ�(��Ʈ)�� ������� ������(��Ʈ��) ����� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("getPartPersonsForDPProgress")) {
        String departCode = request.getParameter("departCode");
        
        try { 
            ArrayList resultArrayList = null;

            // (FOR DALIAN) ����߰� �����ο��� ������ȸ ��� �ο� (* �ӽñ��)
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
    // �ش� ��¥�� ���� ���ο�, ��� + ��¥�� �ü��Է� ������ ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetWorkingDayDesignMHInputs")) {
        String designerID = request.getParameter("designerID");
        String dateSelected = request.getParameter("dateSelected");
        
        try {
            resultMsg = getDateHolidayInfo(dateSelected); 
            if (resultMsg != null && resultMsg.equals("Y")) // ������ ��쿡�� COPY ����̵�
            {
                resultMsg = "";

                ArrayList resultArrayList = getDesignMHInputs(designerID, dateSelected); 
                for (int i = 0; i < resultArrayList.size(); i++) {
                    Map map = (Map)resultArrayList.get(i);
                    /* UTF-8 �������� Ư������ �ν� ������ �߻��ϳ�, �� ����� ������ �����Ƿ� �׳� �� */
                    if (!resultMsg.equals("")) resultMsg += "��"; 
                    resultMsg += (String)map.get("START_TIME") + "��";
                    resultMsg += (String)map.get("PROJECT_NO") + "��";
                    resultMsg += (String)map.get("DWG_TYPE") + "��";
                    resultMsg += (String)map.get("DWG_CODE") + "��";
                    resultMsg += (String)map.get("OP_CODE") + "��";
                    resultMsg += (String)map.get("CAUSE_DEPART") + "��";
                    resultMsg += (String)map.get("BASIS") + "��";
                    resultMsg += (String)map.get("WORK_DESC") + "��";
                    resultMsg += (String)map.get("EVENT1") + "��";
                    resultMsg += (String)map.get("EVENT2") + "��";
                    resultMsg += (String)map.get("EVENT3") + "��";
                }
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �ü����� ������ ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveApprovals")) {
        String applyStrs = request.getParameter("applyStrs");
        String dateStr = request.getParameter("dateStr");
        String loginID = request.getParameter("loginID");
        String deptCode = request.getParameter("deptCode");
        String allChecked = request.getParameter("allChecked");

        try { 
            resultMsg = saveApprovals(applyStrs, dateStr, loginID, deptCode, allChecked); 
            if (!resultMsg.equals("")) {
                resultMsg = "���� �ο��� '��ȹ�ü� ��� �ʰ� ����'�� �����Ͽ� ��ü���� ��󿡼� ���ܵǾ����ϴ�!\n" + 
                            "'��ȹ�ü� ��� �ʰ� ����' Ȯ�� �� �� �� �ü����縦 �����Ͻñ� �ٶ��ϴ�!\n\n" + resultMsg;
            }
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ���õ� ��¥�� �Է½ü��� �ϰ� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("DeleteDPInputs")) {
        String designerID = request.getParameter("designerID");
        String dateStr = request.getParameter("dateStr");

        try { deleteDPInputs(designerID, dateStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ���õ� ���鿡 ���� �������� ��ȸ
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDesignProgressInfo")) {
        String projectNo = request.getParameter("projectNo");
        String drawingNo = request.getParameter("drawingNo");

        try { resultMsg = getDesignProgressInfo(projectNo, drawingNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ���õ� ������ �⵵���� ��ȸ
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetDrawingWorkStartDate")) {
        String projectNo = request.getParameter("projectNo");
        String drawingNo = request.getParameter("drawingNo");

        try { resultMsg =  getDrawingWorkStartDate(projectNo, drawingNo); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ���� �����ü� �Է»��� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDPProgress")) {
        String projectNo = request.getParameter("projectNo");
        String inputDates = request.getParameter("inputDates");
        String inputPersons = request.getParameter("inputPersons");
        String loginID = request.getParameter("loginID");

        try { saveDPProgress(projectNo, inputDates, inputPersons, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �������� ���� �� �Է»��� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDPProgressDev")) {
        String inputDataList = request.getParameter("inputDataList");
        String descChangedValues = request.getParameter("descChangedValues");
        String inputDates = request.getParameter("inputDates");
        String loginID = request.getParameter("loginID");

        try { saveDPProgressDev(inputDataList, descChangedValues, inputDates, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �����κ� ��ȸ���� ������Ʈ ��� ������Ʈ
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
    // �ü��Է� LOCK ���� ������Ʈ
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateDPInputLockList")) {
        String params = request.getParameter("params");

        try {
            updateDPInputLockList(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ����(����) �Է� LOCK ���� ������Ʈ
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateDPProgressLockList")) {
        String params = request.getParameter("params");

        try {
            updateDPProgressLockList(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �ü� ������ Default(Active) Case�� ������Ʈ
    else if (requestProc != null && requestProc.equalsIgnoreCase("UpdateActiveMHFactorCase")) {
        String params = request.getParameter("params");

        try {
            ArrayList paramsList = FrameworkUtil.split(params, ",");
            updateActiveMHFactorCase((String)paramsList.get(0), (String)paramsList.get(1)); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // �ü� ������ Case�� �߰�
    else if (requestProc != null && requestProc.equalsIgnoreCase("AddActiveMHFactorCase")) {
        String params = request.getParameter("params");

        try {
            addActiveMHFactorCase(FrameworkUtil.split(params, ",")); 
            resultMsg = "OK";
        }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ����ü� DATA �������� �μ� ���� �� �������� ����
    else if (requestProc != null && requestProc.equalsIgnoreCase("SaveDepartmentChange")) {
        String deptChanged = request.getParameter("deptChanged");
        String loginID = request.getParameter("loginID");

        try { saveDepartmentChange(deptChanged, loginID); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ȣ�� �� ����ü��� ERP�� I/F
    else if (requestProc != null && requestProc.equalsIgnoreCase("ProjectDataERPIF")) {
        String dataList = request.getParameter("dataList");
        String createDate = request.getParameter("createDate");
        String targetStr = request.getParameter("targetStr");
        
        try { executeProjectDataERPIF(dataList, createDate, targetStr); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    // ���� �⵵����(Hard Copy) �Է��� ��� ����
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
            map.put("dwgDesc", replaceAmpAll(replaceAmpAll(request.getParameter("dwgDesc" + i), "��", "&"), "��", "%"));
            map.put("ecoNo", request.getParameter("ecoNo" + i));
            map.put("reasonCode", request.getParameter("reasonCode" + i));
            map.put("causeDept", request.getParameter("causeDept" + i));
            map.put("revTiming", request.getParameter("revTiming" + i));
            map.put("deployDesc", replaceAmpAll(replaceAmpAll(request.getParameter("deployDesc" + i), "��", "&"), "��", "%"));
            paramList.add(map);
        }

        try { resultMsg = saveHardCopyInputs(loginID, deployNoPrefix, deptCode, requestDate, deployDate, gubun, paramList); }
        catch (Exception e) { resultMsg = "ERROR"; }
    }
    /****  DIS-ERROR : ECO ���� �������� �κ� �����ʿ�
    // PLM���� ECO ������ GET
    else if (requestProc != null && requestProc.equalsIgnoreCase("GetECOInfo")) {
        String ecoNo = request.getParameter("ecoNo");

        try { 
            String whereExp = "name == '" + ecoNo + "' && revision == '-'";
            ArrayList selects = new ArrayList();
            selects.addElement(DomainObject.SELECT_DESCRIPTION);
            selects.addElement("attribute[Category of Change]");
            ArrayList mapList = DomainObject.findObjects(context, "ECO", "eService Production", whereExp, selects);
            if (mapList.size() > 0) {
                Map map = (Map)mapList.get(0);
                resultMsg = (String)map.get("attribute[Category of Change]") + "|" + (String)map.get(DomainObject.SELECT_DESCRIPTION);
            }
            else resultMsg = "";
        }
        catch (Exception e) { 
            resultMsg = "ERROR"; 
        }
    }
    *****/

%>
<%=resultMsg%>