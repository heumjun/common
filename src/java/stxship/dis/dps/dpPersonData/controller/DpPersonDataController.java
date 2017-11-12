/**
 * 
 */
package stxship.dis.dps.dpPersonData.controller;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.dps.dpPersonData.service.DpPersonDataService;

/** 
 * @파일명	: DpPersonDataController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 16. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Controller
public class DpPersonDataController extends CommonController {
	
	@Resource(name="dpPersonDataService")
	private DpPersonDataService dpPersonDataService;
	
	@RequestMapping(value = "stxPECDPPersonData.do")
	public ModelAndView stxPECDPPersonData(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpPersonData" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpPersonDataService.getEmployeeInfo(param);
		List<Map<String,Object>> facotrCaseList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			facotrCaseList = dpPersonDataService.getMHFactorCaseAndValueList();
			
			isManager = dpPersonDataService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			/*if(loginUserInfo.containsKey("is_admin") && !"Y".equals(String.valueOf(loginUserInfo.get("is_admin")))){
				loginUserInfo.put("is_admin", isManager);
			}*/
			loginUserInfo.put("is_manager", isManager);
			if (dpPersonDataService.isTeamManager(String.valueOf(loginUserInfo.get("title")))) 
				loginUserInfo.put("dept_code_list", dpPersonDataService.getPartListUnderTeamStr(String.valueOf(loginUserInfo.get("dept_code"))));
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
		if( 
			(!"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("is_admin"))) &&
			 !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("is_manager"))) ||
			 loginUserInfo.get("termination_date") != null)){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		param.clear();
		param.put("factorCaseList", facotrCaseList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfAll
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *해당 기간의 전체(기술부문) 잔업 평균
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getAverageOvertimeOfAll.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getAverageOvertimeOfAll(CommandMap commandMap) throws Exception{
		return dpPersonDataService.getAverageOvertimeOfAll(commandMap);
	}
	/**
	 * 
	 * @메소드명	: getAverageOvertimeOfSelectedDepts
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해당 기간의 선택된 부서(들)의 잔업 평균
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getAverageOvertimeOfSelectedDepts.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getAverageOvertimeOfSelectedDepts(CommandMap commandMap) throws Exception{
		return dpPersonDataService.getAverageOvertimeOfSelectedDepts(commandMap);
	}
	/**
	 * 
	 * @메소드명	: dpPersonDataMainGridAction
	 * @날짜		: 2016. 8. 16.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 개인별 시수조회 메인그리드 조회쿼리
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpPersonDataMainGrid.do")
	public @ResponseBody Map<String, Object> dpPersonDataMainGridAction(CommandMap commandMap) throws Exception {
		if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
			commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
		Map<String,Object> returnData = dpPersonDataService.getGridListNoPagingDps(commandMap);
		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		ArrayList<CaseInsensitiveMap> newRows = new ArrayList<CaseInsensitiveMap>();
		
		DecimalFormat df = new DecimalFormat("###,###.##");//시수 포맷
		DecimalFormat df1 = new DecimalFormat("#.#");//비율 포맷
		
		float TOTAL_MH_TAKE_F = 0;  // 총 투입 실적 시수
		
		for(int i =0; i < rows.size(); i++){
			CaseInsensitiveMap map  = (CaseInsensitiveMap)rows.get(i);
			float MH_FACTOR_F = !map.containsKey("mh_factor") ? 0 : Float.parseFloat(String.valueOf(map.get("mh_factor")));
            float MH_TAKE_F = !map.containsKey("mh_take") ? 0 : Float.parseFloat(String.valueOf(map.get("mh_take")));
            float NORMAL_TIME_F = !map.containsKey("normal_time") ? 0 : Float.parseFloat(String.valueOf(map.get("normal_time")));
            float OVER_TOTAL_F = !map.containsKey("over_total") ? 0 : Float.parseFloat(String.valueOf(map.get("over_total")));
            float MH_D1_F = !map.containsKey("mh_d1") ? 0 : Float.parseFloat(String.valueOf(map.get("mh_d1")));
            
            float MH_TAKE_RATE_F = (MH_TAKE_F == 0 || TOTAL_MH_TAKE_F == 0) ? 0 : MH_TAKE_F / TOTAL_MH_TAKE_F * 100; // 총투입실적 차지율
            float NORMAL_TIME_RATE_F = (MH_TAKE_F == 0 || NORMAL_TIME_F == 0) ? 0 : MH_TAKE_F / NORMAL_TIME_F * 100; // 당연투입시수 사용율
            float MH_D1_RATE_F = (MH_TAKE_F == 0 || MH_D1_F == 0) ? 0 : MH_D1_F / (MH_TAKE_F+MH_D1_F) * 100;         // 근태 시수율
            float OVER_TOTAL_RATE_F = (MH_TAKE_F == 0 || OVER_TOTAL_F == 0) ? 0 : OVER_TOTAL_F / MH_TAKE_F * 100;    // 잔업율
            
            String MH_TAKE_RATE = df1.format(MH_TAKE_RATE_F);
            String NORMAL_TIME_RATE = df1.format(NORMAL_TIME_RATE_F);
            String MH_D1_RATE = df1.format(MH_D1_RATE_F);
            String OVER_TOTAL_RATE = df1.format(OVER_TOTAL_RATE_F);
            
            if(i==0)
            { 
            	TOTAL_MH_TAKE_F = MH_TAKE_F;   // 총투입실적 총합계를 차지율 계산을 위해 세팅
            	// TOTAL 라인은 비율 없음
            	MH_TAKE_RATE = "";
            	NORMAL_TIME_RATE = "";
            	MH_D1_RATE = "";
            	OVER_TOTAL_RATE = "";
            }
            map.put("MH_TAKE_RATE", MH_TAKE_RATE);
            map.put("NORMAL_TIME_RATE", NORMAL_TIME_RATE);
            map.put("MH_D1_RATE", MH_D1_RATE);
            map.put("OVER_TOTAL_RATE", OVER_TOTAL_RATE);
            
            newRows.add(map);
		}
		
        returnData.put("rows", newRows);
		return returnData;
	}
	
	@RequestMapping(value = "dpPersonDataExcelExport.do")
	public View dpPersonDataExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return dpPersonDataService.dpsExcelExport(commandMap, modelMap);
	}
}
