package stxship.dis.dps.dpInput.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.dpInput.service.DpInputService;

/**
 * @파일명 : DpInputController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpInputController의 컨트롤러
 *     </pre>
 */
@Controller
public class DpInputController extends CommonController {
	@Resource(name = "dpInputService")
	private DpInputService dpInputService;

	/**
	 * 
	 * @메소드명	: stxPECDPInputAction
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 (DIS)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stxPECDPInput.do")
	public ModelAndView stxPECDPInputAction(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpInputService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> personList = null;
		List<Map<String,Object>> selectedProjectList = null;
		List<Map<String,Object>> causeDepartmentList = null;
		List<Map<String,Object>> invalidSelectedProjectList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			isManager = dpInputService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			loginUserInfo.put("is_manager", isManager);
			
			if(loginUserInfo.containsKey("is_admin") && "Y".equals(String.valueOf(loginUserInfo.get("is_admin")))){
				departmentList = dpInputService.getDepartmentList();
				personList = dpInputService.getPartPersons(loginUserInfo);
			}
			
			commandMap.put("employee_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			selectedProjectList = dpInputService.getSelectedProjectList(commandMap);
			causeDepartmentList = dpInputService.getAllDepartmentOfSTXShipList();
			invalidSelectedProjectList = dpInputService.getInvalidSelectedProjectList(commandMap);
		} else {
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
		if(loginUserInfo.get("designerid") == null || "".equals(loginUserInfo.get("designerid"))){
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		// 시수입력 가능한 사용자가 아닌 경우 Exit
		if( !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("mh_yn"))) || loginUserInfo.get("termination_date") != null){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		param.clear();
		param.put("selectedProjectList", selectedProjectList);
		param.put("causeDepartmentList", causeDepartmentList);
		param.put("invalidSelectedProjectList", invalidSelectedProjectList);
		param.put("personList", personList);
		param.put("departmentList", departmentList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	/**
	 * 
	 * @메소드명	: popUpDesignHoursViewWin
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 - 시수 체크
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="popUpDesignHoursViewWin.do")
	public ModelAndView popUpDesignHoursViewWin(HttpServletRequest request,CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		mav.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpInputService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> partPersonList = null;
		List<Map<String,Object>> selectedProjectList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			
			isManager = dpInputService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));

			loginUserInfo.put("is_manager", isManager);
			if (dpInputService.isTeamManager(String.valueOf(loginUserInfo.get("title")))){
				isManager = "Y";
				loginUserInfo.put("is_manager", isManager);
			}
			departmentList = dpInputService.getDepartmentList();
			if ("Y".equals(String.valueOf(loginUserInfo.get("is_admin"))) || "Y".equals(isManager)) 
				partPersonList = dpInputService.getPartPersons(loginUserInfo);
			commandMap.put("employee_id", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			selectedProjectList = dpInputService.getSelectedProjectList(commandMap);
			
		} else {
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		
		param.clear();
		param.put("loginUserInfo", loginUserInfo);
		param.put("departmentList", departmentList);
		param.put("partPersonList", partPersonList);
		param.put("selectedProjectList", selectedProjectList);
		mav.addAllObjects(param);
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpDesignApprovalViewWin
	 * @날짜		: 2016. 8. 24.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력(DIS) 결재 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="popUpDesignApprovalViewWin.do")
	public ModelAndView popUpDesignApprovalViewWin(HttpServletRequest request,CommandMap commandMap) throws UnsupportedEncodingException{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpDesignApprovalViewMainGridAction
	 * @날짜		: 2016. 8. 24.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력(DIS) 결재 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "popUpDesignApprovalViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpDesignApprovalViewMainGridAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpInputService.getGridListNoPagingDps(commandMap);
		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		ArrayList<CaseInsensitiveMap> newRows = new ArrayList<CaseInsensitiveMap>();
		int count = 0;
		for(CaseInsensitiveMap temp : rows){
			if (!"Y".equals(String.valueOf(temp.get("isworkday"))) && !temp.containsKey("employee_no")) {count++; continue; }
			newRows.add(temp);
		}
		returnData.put("records", Integer.parseInt(String.valueOf(returnData.get("records"))) - count);
		returnData.put("rows", newRows);
		
		return returnData;
	}
	/**
	 * 
	 * @메소드명	: popUpInputProjectNModelSelectWin
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선+모델+저장했던 호선 목록 선택 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpInputProjectNModelSelectWin.do")
	public ModelAndView popUpProjectNModelSelectWin(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: projectModelSearchItemAction
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선+모델(제외) 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputProjectSearchItem.do")
	public @ResponseBody Map<String, Object> projectModelSearchItemAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: popUpInputProjectSelectedNInvaildItem
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 저장 호선 + invalid호선 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputProjectSelectedNInvaildItem.do")
	public @ResponseBody Map<String, Object> popUpInputProjectSelectedNInvaildItem(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: popUpInputProjectSelectedNInvaildItemSaveAction
	 * @날짜		: 2016. 8. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선추가 팝업 처리내용 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputProjectSelectedNInvaildItemSave.do")
	public @ResponseBody Map<String, String> popUpInputProjectSelectedNInvaildItemSaveAction(CommandMap commandMap) throws Exception {
		return dpInputService.saveInputProjectSelect(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: getInvalidSelectedProjectListAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * invalid 호선 목록 리턴 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getInvalidSelectedProjectList.do")
	public @ResponseBody String getInvalidSelectedProjectListAction(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(dpInputService.getInvalidSelectedProjectList(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: popUpDesignHoursViewMainGridAction
	 * @날짜		: 2016. 8. 26.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수체크 팝업 메인그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDesignHoursViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpDesignHoursViewMainGridAction(CommandMap commandMap) throws Exception {
		String drawingNo = "";
		boolean drawingNoCheck = false;
		for (int i = 1; i < 9; i++) {
			if (commandMap.get("drawingNo"+i+"") != null && !"".equals(String.valueOf(commandMap.get("drawingNo"+i+"")))) {
				drawingNo +=  String.valueOf(commandMap.get("drawingNo"+i+""));
				drawingNoCheck = true;
			}
			else drawingNo +=  "_";
		}
		if(drawingNoCheck)commandMap.put("drawingNo",drawingNo);
		else commandMap.put("drawingNo","");
		
		Map<String,Object> returnData = dpInputService.getGridListNoPagingDps(commandMap);
		
		float normalTimeSum = 0;
	    float overtimeSum = 0;
	    float specialTimeSum = 0;

		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		for(CaseInsensitiveMap map : rows){
			if (map.containsKey("normal_time")) normalTimeSum += Float.parseFloat(String.valueOf(map.get("normal_time")));
            if (map.containsKey("overtime")) overtimeSum += Float.parseFloat(String.valueOf(map.get("overtime")));
            if (map.containsKey("special_time")) specialTimeSum += Float.parseFloat(String.valueOf(map.get("special_time")));
		}
		
		returnData.put("normal_time_total", normalTimeSum);
		returnData.put("overtime_total", overtimeSum);
		returnData.put("special_time_total", specialTimeSum);
		
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: dpInputMainGridAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * dpinput maingrid
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpInputMainGrid.do")
	public @ResponseBody Map<String, Object> dpInputMainGridAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: popUpInputVacationPeriodSelect
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 년차 특별휴가 예비군
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpInputVacationPeriodSelect.do")
	public ModelAndView popUpInputVacationPeriodSelect(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));

	    
	    String jobDescStr = "";
	    
	    String opCode = String.valueOf(commandMap.get("opCode"));
	    if(opCode.equals("D13"))jobDescStr = "예비군훈련";
	    else if(opCode.equals("D14")) jobDescStr = "특별휴가";
	    else if(opCode.equals("D17")) jobDescStr = "년차";
	    else if(opCode.equals("D1A")) jobDescStr = "유급휴가";
	    
	    commandMap.put("jobDescStr", jobDescStr);
	    
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpInputOneDayOverJobPeriodSelect
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *기술회의 및 교육, 일반출장 
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpInputOneDayOverJobPeriodSelect.do")
	public ModelAndView popUpInputOneDayOverJobPeriodSelect(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));

	    
	    String jobDescStr = "";
	    
	    String opCode = String.valueOf(commandMap.get("opCode"));
	    if (opCode.equals("B46")) jobDescStr = "사외 협의 검토(공사관련 출장)";
	    else if (opCode.equals("C22")) jobDescStr = "기술회의 및 교육(사내외)";
	    else if (opCode.equals("C31")) jobDescStr = "일반출장(기술소위원회, 세미나)";
	    
	    commandMap.put("jobDescStr", jobDescStr);
	    
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpInputOneDayOverJobPeriodSelectPjt
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *사외 협의 검토 기간 선택 창
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="popUpInputOneDayOverJobPeriodSelectPjt.do")
	public ModelAndView popUpInputOneDayOverJobPeriodSelectPjt(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));

	    
	    String jobDescStr = "";
	    
	    String opCode = String.valueOf(commandMap.get("opCode"));
	    if (opCode.equals("B46")) jobDescStr = "사외 협의 검토(공사관련 출장)";
	    
	    commandMap.put("selectedProjectList", dpInputService.getSelectedProjectList(commandMap));
	    commandMap.put("jobDescStr", jobDescStr);
	    
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	
	/**
	 * 
	 * @메소드명	: saveAsOneDayOverJobDPInputsAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수입력 사항을 DB에 저장(1 일 이상 - 기술회의 및 교육, 일반출장)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveAsOneDayOverJobDPInputs.do")
	public @ResponseBody String saveAsOneDayOverJobDPInputsAction(CommandMap commandMap) throws Exception {
		int count = dpInputService.saveAsOneDayOverJobDPInputsAction(commandMap);
		return String.valueOf(count);
	}
	/**
	 * 
	 * @메소드명	: saveAsOneDayOverJobWithProjectDPInputsAction
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수입력 사항을 DB에 저장(1 일 이상(호선선택 포함) - 사외 협의 검토)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveAsOneDayOverJobWithProjectDPInputs.do")
	public @ResponseBody String saveAsOneDayOverJobWithProjectDPInputsAction(CommandMap commandMap) throws Exception {
		int count = dpInputService.saveAsOneDayOverJobWithProjectDPInputsAction(commandMap);
		return String.valueOf(count);
	}
	
	/**
	 * 
	 * @메소드명	: popUpInputSeaTrialPeriodSelectAction
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시운전 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="popUpInputSeaTrialPeriodSelect.do")
	public ModelAndView popUpInputSeaTrialPeriodSelectAction(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		
		commandMap.put("selectedProjectList", dpInputService.getSelectedProjectList(commandMap));
	    commandMap.put("timeKeys", dpInputService.getTimeKeys());
	    
		mav.addAllObjects(commandMap.getMap());
		
		return mav;
	}
	
	/*SaveSeaTrialDPInputs*/
	/**
	 * 
	 * @메소드명	: SaveSeaTrialDPInputsAction
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수입력 사항을 DB에 저장(시운전 Only 케이스)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSeaTrialDPInputs.do")
	public @ResponseBody String saveSeaTrialDPInputsAction(CommandMap commandMap) throws Exception {
		int count = dpInputService.saveSeaTrialDPInputsAction(commandMap);
		return String.valueOf(count);
	}
	
	/**
	 * 
	 * @메소드명	: saveDPInputsAction
	 * @날짜		: 2016. 8. 31.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *시수입력 사항을 DB에 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveDPInputs.do")
	public @ResponseBody String saveDPInputsAction(CommandMap commandMap) throws Exception {
		int count = dpInputService.saveDPInputsAction(commandMap);
		return String.valueOf(count);
	}
	
	/**
	 * 
	 * @메소드명	: popUpInputProjectMultiSelectAction
	 * @날짜		: 2016. 9. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 그리드 다중호선 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="popUpInputProjectMultiSelect.do")
	public ModelAndView popUpInputProjectMultiSelectAction(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpInputProjectMultiSelectMainGrid
	 * @날짜		: 2016. 9. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 그리드 다중호선 팝업 그리드 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputProjectMultiSelectMainGrid.do")
	public @ResponseBody Map<String, Object> popUpInputProjectMultiSelectMainGrid(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	
	
	/**
	 * 
	 * @메소드명	: popUpInputOpSelectAction
	 * @날짜		: 2016. 9. 1.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * OP 코드 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="popUpInputOpSelect.do")
	public ModelAndView popUpInputOpSelectAction(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/dpInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		
		boolean isNonProject = false;
	    boolean isMultiProject = false;
	    boolean isRealProject = false;
	    	    
	    String projectNo = String.valueOf(commandMap.get("projectNo"));
	    
	    String defaultGRT = "";
	    String defaultMID = "";
	    // 호선이 S000은 비공사호선, 호선이 하나인 경우, 다수 호선이 선택된 경우(,로 호선구분됨)
	    if (projectNo.equals("S000")) 
	    {
	    	isNonProject = true;
	    	defaultGRT = "C";
	    	defaultMID = "1";
	    } else if (projectNo.indexOf(",") > -1) {
	    	isMultiProject = true;
	    	defaultGRT = "B";
	    	defaultMID = "1";
	    } else {
	    	isRealProject = true;
	    	defaultGRT = "A";
	    	defaultMID = "1";
	    }
	    commandMap.put("isNonProject", isNonProject);
	    commandMap.put("isMultiProject", isMultiProject);
	    commandMap.put("isRealProject", isRealProject);
	    commandMap.put("defaultGRT", defaultGRT);
	    commandMap.put("defaultMID", defaultMID);

	   // commandMap.put("opCodeListGRT", dpInputService.getOpCodeListGRT(commandMap.getMap()));// OP CODE 대분류
	    commandMap.put("opCodeListMID", dpInputService.getOpCodeListMID(commandMap.getMap()));// OP CODE 중분류
	    commandMap.put("opCodeListSUB", dpInputService.getOpCodeListSUB(commandMap.getMap()));// OP CODE 소분류
		
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: getDrawingListForWork
	 * @날짜		: 2016. 9. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *부서 + 호선 + 타입에 해당하는 도면들 목록을 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDrawingListForWork.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDrawingListForWork(CommandMap commandMap) throws Exception {
		List<Map<String,Object>> returnList = dpInputService.getDrawingListForWork(commandMap);
		return DisJsonUtil.listToJsonstring(returnList);
	}
	
	/**
	 * 
	 * @메소드명	: dpInputMainGridSaveAction
	 * @날짜		: 2016. 9. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpInputMainGridSave.do")
	public @ResponseBody Map<String, String> dpInputMainGridSaveAction(CommandMap commandMap) throws Exception {
		return dpInputService.dpInputMainGridSave(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: deleteDPInputs
	 * @날짜		: 2016. 9. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 항목 전체 삭제
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deleteDPInputs.do")
	public @ResponseBody Map<String, String> deleteDPInputs(CommandMap commandMap) throws Exception {
		return dpInputService.deleteDPInputs(commandMap);
	}
}
