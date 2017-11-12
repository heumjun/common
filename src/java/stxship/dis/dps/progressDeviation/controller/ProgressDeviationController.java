package stxship.dis.dps.progressDeviation.controller;

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
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.progressDeviation.service.ProgressDeviationService;


/** 
 * @파일명	: ProgressDeviationController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 7. 7. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 	공정 지연현황 조회(DIS)
 *	 ProgressDeviationController의 컨트롤러
 * </pre>
 */
@Controller
public class ProgressDeviationController extends CommonController {
	
	@Resource(name = "progressDeviationService")
	private ProgressDeviationService progressDeviation;
	
	/**
	 * 
	 * @메소드명	: stxPECDPProgressDeviation
	 * @날짜		: 2016. 7. 7.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	공정 지연현황 조회(DIS) 헤더
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "stxPECDPProgressDeviation.do")
	public ModelAndView stxPECDPProgressDeviationHeader(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/progressDeviation" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = progressDeviation.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> personsList = null;
		
		if(loginUserInfo != null){
			
			loginUserInfo.put("designerID", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			departmentList = progressDeviation.getProgressDepartmentList();
			personsList = progressDeviation.getPartPersonsForDPProgress(loginUserInfo);
			
		} else {
            loginUserInfo = progressDeviation.getEmployeeInfoDalian(param);
            
            if (loginUserInfo != null) 
            {
            	loginUserInfo.put("designerID", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
            	departmentList = progressDeviation.getProgressDepartmentList();
            	personsList = progressDeviation.getPartPersons_Dalian(loginUserInfo);
            }else {
    			return new ModelAndView("/common/stxPECDP_LoginFailed");
    		}
		}
		
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
		if(loginUserInfo == null || loginUserInfo.get("designerid") == null || "".equals(loginUserInfo.get("designerid"))){
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		// 시수입력 가능한 사용자가 아닌 경우 Exit
		if( 
			(!"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("mh_yn"))) &&
			 !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("progress_yn"))) ||
			 loginUserInfo.get("termination_date") != null)){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		
		loginUserInfo.put("lockDate", progressDeviation.getDPProgressLockDate(loginUserInfo));
		
		
		
		param.clear();
		param.put("loginUserInfo", loginUserInfo);
		param.put("departmentList", departmentList);
		param.put("personsList", personsList);
		
		mv.addAllObjects(param);

		/*기본정보 설정 종료*/
		return mv;
	}
	
	
	/**
	 * 
	 * @메소드명	: stxPECDPProgressDeviationMainGridAction
	 * @날짜		: 2016. 7. 13.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * Main 그리드 표시 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "progressDeviationMainGrid.do")
	public @ResponseBody Map<String, Object> progressDeviationMainGridAction(CommandMap commandMap) throws Exception {
		String selectedProjectList = String.valueOf(commandMap.get("projectList"));
		
		if(!"".equals(selectedProjectList)){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(selectedProjectList.split(",")));
			commandMap.put("projectList", temp);
		}
		
		if(!commandMap.containsKey("searchComplete"))commandMap.put("searchComplete", "false");
		
		if(commandMap.containsKey("searchAll") && "true".equals(String.valueOf(commandMap.get("searchAll")))){
			commandMap.put("searchComplete", "false");
		}
		
		Map<String,Object> temp = progressDeviation.getGridListNoPagingDps(commandMap);
		return temp;
	}
	
	/**
	 * 
	 * @메소드명	: popUpDelayReasonDesc
	 * @날짜		: 2016. 7. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	특기사항 지연사유 입력팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="popUpDelayReasonDesc.do")
	public ModelAndView popUpDelayReasonDesc(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/progressDeviation"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		Map<String,Object> resultMap = progressDeviation.getPLMActivityDeviationDesc(commandMap);
		if(resultMap != null)commandMap.put("delayReasonDesc", resultMap.containsKey("delayreason_desc") ? resultMap.get("delayreason_desc"):"");
		else commandMap.put("delayReasonDesc", "");
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpSaveDelayresonDescAction
	 * @날짜		: 2016. 7. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 지연사유 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="popUpSaveDelayresonDesc.do")
	public @ResponseBody String popUpSaveDelayresonDescAction(CommandMap commandMap) throws Exception{
		Map<String,Object> param = commandMap.getMap();
		progressDeviation.savePLMActivityDeviationDesc(param);
		return String.valueOf(param.get("delayreason_desc"));
	}
	
	/**
	 * 
	 * @메소드명	: progressDeviationMainGridSaveAction
	 * @날짜		: 2016. 7. 25.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 데이터 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "progressDeviationMainGridSave.do")
	public @ResponseBody Map<String, String> progressDeviationMainGridSaveAction(CommandMap commandMap) throws Exception {
		commandMap.put("mybatisName","progressDeviationMainGridSave");
		Map<String,String> resultValue = new HashMap<String,String>();
		
		//지연사유
		commandMap.put("mybatisId", "saveDelayResaonPPStmt");
		resultValue = progressDeviation.progressDeviationMainGridSave(commandMap);
		
		//조치예정일
		commandMap.put("mybatisId", "savePlanDatePPStmt");
		resultValue = progressDeviation.progressDeviationMainGridSave(commandMap);
		
		//현장필요시점
		commandMap.put("mybatisId", "saveReqDatePPStmt");
		resultValue = progressDeviation.progressDeviationMainGridSave(commandMap);
		
		ArrayList<String> actionStart = new ArrayList<String>(
				Arrays.asList("dw_act_s","ow_act_s","cl_act_s","rf_act_s","wk_act_s"));
		
		commandMap.put("mybatisId", "saveStartPPStmt");
		for(String start : actionStart){
			//StartAction
			commandMap.put("targetDate", start);
			commandMap.put("actionAddCode", start.substring(0, 2).toUpperCase());
			resultValue = progressDeviation.progressDeviationMainGridSave(commandMap);
		}
		
		ArrayList<String> actionFinish = new ArrayList<String>(
				Arrays.asList("dw_act_f","ow_act_f","cl_act_f"));
		
		commandMap.put("mybatisId", "saveFinishPPStmt");
		for(String finish : actionFinish){
			//Finish Action
			commandMap.put("targetDate", finish);
			commandMap.put("actionAddCode", finish.substring(0, 2).toUpperCase());
			resultValue = progressDeviation.progressDeviationMainGridSave(commandMap);
		}
		commandMap.remove("targetDate");
		commandMap.remove("mybatisId");
		commandMap.remove("actionAddCode");
		commandMap.remove("mybatisName");
		return resultValue;
	}
	
	/**
	 * 
	 * @메소드명	: getPartPerson
	 * @날짜		: 2016. 7. 11.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서 선택이 변경되면 해당 부서의 구성원(파트원)들 목록을 쿼리하여 사번 SELECT LIST를 채움
	 * </pre>
	 * @param dept_code
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="getPartPersonsForDPProgress.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartPerson(@RequestParam("dept_code")String dept_code) throws Exception{
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("dept_code", dept_code);
		List<Map<String,Object>> partPerson = new ArrayList<Map<String,Object>>();
		partPerson = progressDeviation.getPartPersonsForDPProgress(param);
		return DisJsonUtil.listToJsonstring(partPerson);
	}
}
