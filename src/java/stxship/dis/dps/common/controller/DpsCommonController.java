package stxship.dis.dps.common.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.common.service.DpsCommonService;

/**
 * @파일명 : DpsCommonController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * Dps 공통  컨트롤러
 *     </pre>
 */
@Controller
public class DpsCommonController {
	@Resource(name = "dpsCommonService")
	public DpsCommonService dpsCommonService;

	@RequestMapping(value = "stxPECDP_GeneralAjaxProcess.do")
	public ModelAndView stxPECDP_GeneralAjaxProcessAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("/dps/common" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpProjectSelectWin
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 지정 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProjectSelectWin.do")
	public ModelAndView popUpProjectSelectWin(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/common"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpProjectNModelSelectWin
	 * @날짜		: 2016. 8. 10.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 + model 선택 팝업 저장 기능 없음
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProjectNModelSelectWin.do")
	public ModelAndView popUpProjectNModelSelectWin(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/common"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * 
	 * @메소드명	: projectModelSearchItemAction
	 * @날짜		: 2016. 8. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 + model 선택 팝업 그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "projectModelSearchItem.do")
	public @ResponseBody Map<String, Object> projectModelSearchItemAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpsCommonService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	
	/**
	 * 
	 * @메소드명	: popUpDepartmentSelectWin
	 * @날짜		: 2016. 8. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 선택 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDepartmentSelectWin.do")
	public ModelAndView popUpDepartmentSelectWin(CommandMap commandMap) throws Exception {
		ModelAndView mav = new ModelAndView("/dps/common"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: projectModelSearchItemAction
	 * @날짜		: 2016. 8. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 선택 그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "projectDepartmentSearchItem.do")
	public @ResponseBody Map<String, Object> projectDepartmentSearchItemAction(CommandMap commandMap) throws Exception {
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpsCommonService.getEmployeeInfo(param);
		String isManager = "N";
		
		isManager = dpsCommonService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
		loginUserInfo.put("is_manager", isManager);
		if (dpsCommonService.isTeamManager(String.valueOf(loginUserInfo.get("title"))) ||  
			dpsCommonService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title"))) == "Y"){
			loginUserInfo.put("dept_code", dpsCommonService.getPartListUnderTeamStr(String.valueOf(loginUserInfo.get("dept_code"))));
			commandMap.put("loginUserInfo", loginUserInfo);
		}
			
		
		Map<String,Object> returnMap = dpsCommonService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: projectSearchItemAction
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 지정 그리드 리스트 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "projectSearchItem.do")
	public @ResponseBody Map<String, Object> projectSearchItemAction(CommandMap commandMap) throws Exception {
		Map<String,Object> param = commandMap.getMap();
		String loginID = String.valueOf(param.get("loginID"));
		boolean check = false;
		
		if (loginID.startsWith("M") || loginID.startsWith("O") || loginID.startsWith("S") || loginID.startsWith("H") || loginID.startsWith("T")) check = true;
		param.put("darlian_check",check);
		dpsCommonService.updateProgressSearchableProjectList(param);
		return dpsCommonService.getGridListNoPagingDps(commandMap);
	}
	

	/**
	 * 
	 * @메소드명	: projectSearchAbleItemAction
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 조회가능 호선관리 그리드 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "projectSearchAbleItem.do")
	public @ResponseBody Map<String, Object> projectSearchAbleItemAction(CommandMap commandMap) throws Exception {
		Map<String,Object> param = commandMap.getMap();
		if(!param.containsKey("openOnly")){
			commandMap.put("openOnly", false);
			dpsCommonService.updateProgressSearchableProjectList(param);
		}
		return dpsCommonService.getGridListNoPagingDps(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: projectSavedSearchItemAction
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 지정 - 선택 호선 저장 목록 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "projectSavedSearchItem.do")
	public @ResponseBody Map<String, Object> projectSavedSearchItemAction(CommandMap commandMap) throws Exception {
		String selectedProjectList = String.valueOf(commandMap.get("selectedProjectList"));
		
		if(!"".equals(selectedProjectList)){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(selectedProjectList.split(",")));
			commandMap.put("selectedProjectList", temp);
		}
		return dpsCommonService.getGridListNoPagingDps(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: saveProjectSearchItemAction
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선 지정 - 선택 호선 저장 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveProjectSearchItem.do")
	public @ResponseBody Map<String, String> saveProjectSearchItemAction(CommandMap commandMap) throws Exception {
		dpsCommonService.deleteSaveProjectList(commandMap);
		return dpsCommonService.saveGridListDps(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: projectSaveSearchAbleItem
	 * @날짜		: 2016. 7. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 조회가능 호선 수정 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "projectSaveSearchAbleItem.do")
	public @ResponseBody Map<String, String> projectSaveSearchAbleItemAction(CommandMap commandMap) throws Exception {
		ArrayList<String> externalKey = new ArrayList<String>();
		externalKey.add("category");
		return dpsCommonService.projectSaveSearchAbleItem(commandMap,externalKey);
	}
	
	/**
	 * 
	 * @메소드명	: popUpProjectSelectMng
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 조회가능 호선 관리 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProjectSelectMng.do")
	public ModelAndView popUpProjectSelectMng(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/common"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: getBaseWorkTime
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 기간의 당연투입시수를 쿼리
	 * </pre>
	 * @param dept_code_list
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getBaseWorkTime.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getBaseWorkTime(CommandMap commandMap) throws Exception{
		return dpsCommonService.getBaseWorkTime(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: getPartPerson2
	 * @날짜		: 2016. 8. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서(파트)의 구성원(파트원) 목록을 쿼리 - 퇴사자 & 시수입력 비 대상자 제외 (다수 개 부서 처리)
	 * </pre>
	 * @param dept_code
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getPartPersons2.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartPersons2(@RequestParam("dept_code_list")String dept_code_list) throws Exception{
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("dept_code_list", dept_code_list.split(","));
		List<Map<String,Object>> partPerson = new ArrayList<Map<String,Object>>();
		partPerson = dpsCommonService.getPartPersons2(param);
		return DisJsonUtil.listToJsonstring(partPerson);
	}
	/**
	 * 
	 * @메소드명	: getMHInputConfirmYN
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 사번 + 날짜의 시수입력의 결재 여부를 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getMHInputConfirmYN.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getMHInputConfirmYN(CommandMap commandMap) throws Exception{
		return dpsCommonService.getMHInputConfirmYN(commandMap);
	}
	

	/**
	 * 
	 * @메소드명	: getDateDPInfo
	 * @날짜		: 2016. 8. 23.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *  해당 일자의 평일/휴일 여부와 결재여부 등을 쿼리하여 결과를 리턴
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDateDPInfo.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDateDPInfo(CommandMap commandMap) throws Exception{
		return DisJsonUtil.mapToJsonstring(dpsCommonService.getDateDPInfo(commandMap));
	}
	/**
	 * 
	 * @메소드명	: popUpDepartmentSelectWin
	 * @날짜		: 2016. 8. 24.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 설계부서 전체와 각 부서의 시수입력 LOCk 정보를 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputLockControlView.do")
	public ModelAndView popUpInputLockControlView(CommandMap commandMap) throws Exception {
		ModelAndView mav = new ModelAndView("/dps/common"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpInputLockControlViewMainGridAction
	 * @날짜		: 2016. 8. 24.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *설계부서 전체와 각 부서의 시수입력 LOCk 정보를 쿼리 그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpInputLockControlViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpInputLockControlViewMainGridAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = dpsCommonService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: popUpDesignApprovalViewMainGridSaveAction
	 * @날짜		: 2016. 8. 24.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *계부서 전체와 각 부서의 시수입력 LOCk 정보를 수정
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDesignApprovalViewMainGridSave.do")
	public @ResponseBody Map<String, String> popUpDesignApprovalViewMainGridSaveAction(CommandMap commandMap) throws Exception {
		return dpsCommonService.saveGridListDps(commandMap);
	}
	/**
	 * 
	 * @메소드명	: getDesignMHConfirmExist
	 * @날짜		: 2016. 8. 29.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 사번 + 기간에 결재완료된 입력시수가 존재하는지 체크(쿼리)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDesignMHConfirmExist.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDesignMHConfirmExist(CommandMap commandMap) throws Exception{
		return DisJsonUtil.mapToJsonstring(dpsCommonService.getDesignMHConfirmExist(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: getDesignProgressInfo
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 도면 하나에 대한 공정정보 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDesignProgressInfo.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDesignProgressInfo(CommandMap commandMap) throws Exception{
		return DisJsonUtil.mapToJsonstring(dpsCommonService.getDesignProgressInfo(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingTypesForWorkAction
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 + 호선에 대해 할당된 도면구분(도면코드의 첫 글자)들을 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDrawingTypesForWork.do")
	public @ResponseBody String getDrawingTypesForWorkAction(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(dpsCommonService.getDrawingTypesForWorkAction(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: getShipType
	 * @날짜		: 2016. 8. 30.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * DPS에 정의된 선종 리스트 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getShipType.do")
	public @ResponseBody String getShipTypeAction(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(dpsCommonService.getShipTypeAction(commandMap));
	}
	
	
	/**
	 * 
	 * @메소드명	: getDateHolidayInfo
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	휴일/비휴일 등의 정보 리턴
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDateHolidayInfo.do")
	public @ResponseBody String getDateHolidayInfo(CommandMap commandMap) throws Exception {
		return dpsCommonService.getDateHolidayInfo(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: getDrawingWorkStartDate
	 * @날짜		: 2016. 9. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 도면의 출도일자 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDrawingWorkStartDate.do")
	public @ResponseBody String getDrawingWorkStartDate(CommandMap commandMap) throws Exception {
		return dpsCommonService.getDrawingWorkStartDate(commandMap);
	}
	/**
	 * 
	 * @메소드명	: getDPProgressLockDate
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 부서별 lock date 리턴
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getDPProgressLockDate.do")
	public @ResponseBody String getDPProgressLockDate(CommandMap commandMap) throws Exception {
		return dpsCommonService.getDPProgressLockDate(commandMap.getMap());
	}
	
	
	/**
	 * 
	 * @메소드명	: getKeyEventDates
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 호선의 Key Event 일자를 쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getKeyEventDates.do")
	public @ResponseBody String getKeyEventDates(CommandMap commandMap) throws Exception {
		return DisJsonUtil.mapToJsonstring(dpsCommonService.getKeyEventDates(commandMap.getMap()));
	}
	/**
	 * 
	 * @메소드명	: getPartPersons_Dalian
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *대련중공 설계인원의 공정조회 기능 부여
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getPartPersons_Dalian.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartPersons_Dalian(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(dpsCommonService.getPartPersons_Dalian(commandMap.getMap()));
	}
	 
	/**
	 * 
	 * @메소드명	: getPartPersons_Dalian
	 * @날짜		: 2016. 10. 5.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *부서(파트)의 외주구성원 목록을 쿼리 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getPartOutsidePersonsForDPProgress.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartOutsidePersonsForDPProgress(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(dpsCommonService.getPartOutsidePersonsForDPProgress(commandMap.getMap()));
	}
}	
