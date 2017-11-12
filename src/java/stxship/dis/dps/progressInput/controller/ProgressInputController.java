package stxship.dis.dps.progressInput.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.apache.commons.collections.map.HashedMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.dps.progressInput.service.ProgressInputService;

/**
 * @파일명 : ProgressInputController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * ProgressInputController의 컨트롤러
 *     </pre>
 */
@Controller
public class ProgressInputController extends CommonController {
	@Resource(name = "progressInputService")
	private ProgressInputService progressInputService;

	/**
	 * 
	 * @메소드명	: stxPECDPProgressViewAction
	 * @날짜		: 2016. 9. 27.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 공정 조회/입력
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "stxPECDPProgressView.do")
	public ModelAndView stxPECDPProgressViewAction(CommandMap commandMap) throws Exception{
		ModelAndView mv = new ModelAndView("/dps/progressInput" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = progressInputService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> projectList = null;
		List<Map<String,Object>> personsList = null;
		List<Map<String,Object>> partOutsidePersonsList = null;  // 2nd 담당자 : 포스텍 외주 인원 목록
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			loginUserInfo.put("loginId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			isManager = progressInputService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			loginUserInfo.put("is_manager", isManager);
			
			departmentList = progressInputService.getProgressDepartmentList();
			personsList = progressInputService.getPartPersonsForDPProgress(loginUserInfo);
			
			loginUserInfo.put("category", "PROGRESS");
			projectList = progressInputService.getProgressSearchableProjectList(loginUserInfo, true);
            partOutsidePersonsList = progressInputService.getPartOutsidePersonsForDPProgress(loginUserInfo);
            
		} else { // (FOR DALIAN) 대련중공 설계인원의 공정조회 기능 부여 (* 임시기능)
			loginUserInfo = progressInputService.getEmployeeInfoDalian(param);
			if (loginUserInfo != null) 
            {
				loginUserInfo.put("designerId", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
				departmentList = progressInputService.getProgressDepartmentList();
				personsList = progressInputService.getPartPersons_Dalian(loginUserInfo);
				projectList = progressInputService.getProgressSearchableProjectList_Dalian(loginUserInfo);
            }else {
    			return new ModelAndView("/common/stxPECDP_LoginFailed");
    		}
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		
		loginUserInfo.put("is_manager", isManager);
		
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
 		if(loginUserInfo.get("designerid") == null || "".equals(loginUserInfo.get("designerid"))){
 			return new ModelAndView("/common/stxPECDP_LoginFailed");
 		}
 		// 시수입력 가능한 사용자가 아닌 경우 Exit
 		if( 
 			(!"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("mh_yn"))) &&
 			 !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("progress_yn"))) ||
 			 loginUserInfo.get("termination_date") != null)){
 			return new ModelAndView("/common/stxPECDP_LoginFailed2");
 		}
 		
 		param.clear();
		param.put("loginUserInfo", loginUserInfo);
		param.put("dpmList", departmentList);
		param.put("personsList", personsList);
		param.put("projectList", projectList);
		param.put("partOutsidePersonsList", partOutsidePersonsList);

		mv.addAllObjects(param);
		return mv;
	}
	
	@RequestMapping(value = "progressInputSearch.do", produces = "text/json; charset=UTF-8")
	public @ResponseBody String progressInputSearch(CommandMap commandMap) throws Exception {
		long start = System.currentTimeMillis() ; 
		String msg = "";
		
		String dateCondition = (String)commandMap.get("dateCondition");
		List<Map<String, Object>> returnMap = progressInputService.getDpsProgressInputSearchList(commandMap);
		
		long end = System.currentTimeMillis(); 
		System.out.println((end-start)/1000 +" 초 걸림");
		return new Gson().toJson(returnMap);
	}
	/**
	 * 
	 * @메소드명	: popUpProgressProjectSelectMng
	 * @날짜		: 2016. 9. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 공정 조회/입력 조회가능호선관리 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProgressProjectSelectMng.do")
	public ModelAndView popUpProgressProjectSelectMng(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/progressInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpProgressLockControl
	 * @날짜		: 2016. 9. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 입력제한
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProgressLockControl.do")
	public ModelAndView popUpProgressLockControl(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/progressInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpProgressProjectDateChange
	 * @날짜		: 2016. 9. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	실적입력
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="popUpProgressProjectDateChange.do")
	public ModelAndView popUpProgressProjectDateChange(CommandMap commandMap) throws Exception{
		ModelAndView mav = new ModelAndView("/dps/progressInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		List<Map<String,Object>> dateChangeAbleTypeList = progressInputService.getPLM_DATE_CHANGE_ABLE_DWG_TYPE();
		StringBuilder checkString = new StringBuilder();
		for(Map<String,Object> temp : dateChangeAbleTypeList){
			checkString.append((String)temp.get("dwg_kind") + "|"+(String)temp.get("dwg_type")+",");
		}
		commandMap.put("slDWGTypeKind", checkString.toString());
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: progressProjectDateChangeAction
	 * @날짜		: 2016. 9. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 실적입력관리 메인그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "progressProjectDateChange.do")
	public @ResponseBody Map<String, Object> progressProjectDateChangeAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = progressInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	/**
	 * 
	 * @메소드명	: progressProjectDateChangeMainGridSaveAction
	 * @날짜		: 2016. 9. 30.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 실적입력관리 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "progressProjectDateChangeMainGridSave.do")
	public @ResponseBody Map<String, String> progressProjectDateChangeMainGridSaveAction(CommandMap commandMap) throws Exception {
		Map<String,Object> param = commandMap.getMap();
		Iterator<String> itr = param.keySet().iterator();
		final String bRegex = "^basic\\[[0-9]\\]$";
		final String mRegex = "^maker\\[[0-9]\\]$";
		final String pRegex = "^product\\[[0-9]\\]$";
		
		List<String> basicCheckList = new ArrayList<String>();
		List<String> makerCheckList = new ArrayList<String>();
		List<String> productCheckList = new ArrayList<String>();
		
		while(itr.hasNext()){
			String key = itr.next();
			if(key.matches(bRegex)){
				basicCheckList.add((String)param.get(key));
			}
			if(key.matches(mRegex)){
				makerCheckList.add((String)param.get(key));
			}
			if(key.matches(pRegex)){
				productCheckList.add((String)param.get(key));
			}
		}
		
		List<Map<String,Object>> mlDWGTYPEnKIND = progressInputService.getPLM_DATE_CHANGE_ABLE_DWG_TYPE();
		List<Map<String,Object>> mlDeleteList = new ArrayList<Map<String,Object>>();
		
		for(Map<String,Object> mapDWGTypeKind : mlDWGTYPEnKIND ){
			String dwg_kind = (String)mapDWGTypeKind.get("dwg_kind");
    		String dwg_type = (String)mapDWGTypeKind.get("dwg_type");
    		
    		if(dwg_kind.equals("기본도"))
    		{
    			if(basicCheckList.contains(dwg_type))
   				{
    				basicCheckList.remove(dwg_type);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
    		if(dwg_kind.equals("MAKER"))
    		{
    			if(makerCheckList.contains(dwg_type))
   				{
    				makerCheckList.remove(dwg_type);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
    		if(dwg_kind.equals("생설도"))
    		{
    			if(productCheckList.contains(dwg_type))
   				{
    				productCheckList.remove(dwg_type);
   				} else {
   					mlDeleteList.add(mapDWGTypeKind);
   				}
    		}
		}
		try{
			for(int index = 0;index<basicCheckList.size();index++)
	    	{
	    		String DWG_TYPE = (String)basicCheckList.get(index);
	    		progressInputService.addPLM_DATE_CHANGE_ABLE_DWG_TYPE("기본도",DWG_TYPE);
	    	}
	    	for(int index = 0;index<makerCheckList.size();index++)
	    	{
	    		String DWG_TYPE = (String)makerCheckList.get(index);
	    		progressInputService.addPLM_DATE_CHANGE_ABLE_DWG_TYPE("MAKER",DWG_TYPE);
	    	}
	    	for(int index = 0;index<productCheckList.size();index++)
	    	{
	    		String DWG_TYPE = (String)productCheckList.get(index);
	    		progressInputService.addPLM_DATE_CHANGE_ABLE_DWG_TYPE("생설도",DWG_TYPE);
	    	}
	    	
	    	for(Map<String,Object> map : mlDeleteList){
	    		progressInputService.delPLM_DATE_CHANGE_ABLE_DWG_TYPE(map);
	    	}
	    	
	    	return progressInputService.progressProjectDateChangeMainGridSave(commandMap);
		}catch(Exception e){
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		}
	}
	
	/**
	 * 
	 * @메소드명	: popUpProgressInputLockAction
	 * @날짜		: 2016. 9. 29.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 입력제한
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProgressInputLock.do")
	public @ResponseBody Map<String, Object> popUpProgressInputLockAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnMap = progressInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	
	/**
	 * 
	 * @메소드명	: popUpProgressInputLockMainGridSaveAction
	 * @날짜		: 2016. 9. 30.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 입력제한 그리드 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProgressInputLockMainGridSave.do")
	public @ResponseBody Map<String, String> popUpProgressInputLockMainGridSaveAction(CommandMap commandMap) throws Exception {
		return progressInputService.saveGridListDps(commandMap);
	}
	
	/**
	 * 	
	 * @메소드명	: popUpProgressDwgRevisionHistoryView
	 * @날짜		: 2016. 10. 6.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 도면 정보 팝업
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value="popUpProgressDwgRevisionHistoryView.do")
	public ModelAndView popUpProgressDwgRevisionHistoryView(CommandMap commandMap){
		ModelAndView mav = new ModelAndView("/dps/progressInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpProgressDwgRevisionHistoryAction
	 * @날짜		: 2016. 10. 6.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 도면정보 그리드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProgressDwgRevisionHistory.do")
	public @ResponseBody Map<String, Object> popUpProgressDwgRevisionHistoryAction(CommandMap commandMap) throws Exception {
		commandMap.put("dwgNoSubStr", ((String)commandMap.get("dwgNo")).substring(0, 5));
		commandMap.put("dwgNoSubStr1", ((String)commandMap.get("dwgNo")).substring(5));
		Map<String,Object> returnMap = progressInputService.getGridListNoPagingDps(commandMap);
		return returnMap;
	}
	
	
	/**
	 * 
	 * @메소드명	: getChangableDateDPList
	 * @날짜		: 2016. 10. 7.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 변경가능 일자정보 쿼리
	 * 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "getChangableDateDPList.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getChangableDateDPList(CommandMap commandMap) throws Exception {
		return DisJsonUtil.listToJsonstring(progressInputService.getChangableDateDPList(commandMap.getMap()));
	}
	
	/**
	 * 
	 * @메소드명	: progressInputMainGridSaveAction
	 * @날짜		: 2016. 10. 11.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 메인 그리드 저장 처리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "progressInputMainGridSave.do")
	public @ResponseBody Map<String, String> progressInputMainGridSaveAction(CommandMap commandMap) throws Exception {
		commandMap.put("mybatisName","progressInputMainGridSave");
		Map<String,String> resultValue = new HashMap<String,String>();
		//1차 담당자
		commandMap.put("mybatisId", "saveOneStPartPerson");
		resultValue = progressInputService.progressInputMainGridSave(commandMap);
		
		//2차 담당자		
		commandMap.put("mybatisId", "saveTwoNdPartPerson");
		resultValue = progressInputService.progressInputMainGridSave(commandMap);
		
		ArrayList<String> actionStart = new ArrayList<String>(
				Arrays.asList("dw_act_s","ow_act_s","cl_act_s","rf_act_s","wk_act_s"));
		
		commandMap.put("mybatisId", "saveStartPPStmt");
		for(String start : actionStart){
			//StartAction
			commandMap.put("targetDate", start);
			commandMap.put("actionAddCode", start.substring(0, 2).toUpperCase());
			resultValue = progressInputService.progressInputMainGridSave(commandMap);
		}

		ArrayList<String> actionFinish = new ArrayList<String>(
				Arrays.asList("dw_act_f","ow_act_f","cl_act_f"));
		
		commandMap.put("mybatisId", "saveFinishPPStmt");
		for(String finish : actionFinish){
			//Finish Action
			commandMap.put("targetDate", finish);
			commandMap.put("actionAddCode", finish.substring(0, 2).toUpperCase());
			resultValue = progressInputService.progressInputMainGridSave(commandMap);
		}
		commandMap.remove("targetDate");
		commandMap.remove("mybatisId");
		commandMap.remove("actionAddCode");
		commandMap.remove("mybatisName");
		return resultValue;
	}
	
	/**
	 * @메소드명 : popupProgressPersonConfirmMsgAction
	 * @날짜 : 2017. 5. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * 1. 공정조회 입력화면에서 일괄담당자 입력 적용 시 confirm message 선택창
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */	
	@RequestMapping(value = "popUpProgressPersonConfirmMsg.do")
	public ModelAndView popUpProgressPersonConfirmMsgAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("/dps/progressInput"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}	

}
