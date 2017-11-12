/**
 * 
 */
package stxship.dis.dps.dpDeptData.controller;

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
import stxship.dis.dps.dpDeptData.service.DpDepartmentDataService;

/** 
 * @파일명	: DpDepartmentDataController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 19. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 부서별 시수조회 컨트롤러
 * </pre>
 */
@Controller
public class DpDepartmentDataController extends CommonController {
	
	@Resource(name="dpDepartmentDataService")
	private DpDepartmentDataService dpDepartmentDataService;
	
	/**
	 * 
	 * @메소드명	: stxPECDPPersonData
	 * @날짜		: 2016. 8. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서별 시수조회 화면 로드 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stxPECDPDepartmentData.do")
	public ModelAndView stxPECDPPersonData(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpDeptData" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpDepartmentDataService.getEmployeeInfo(param);
		List<Map<String,Object>> facotrCaseList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			facotrCaseList = dpDepartmentDataService.getMHFactorCaseAndValueList();
			
			isManager = dpDepartmentDataService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			/*if(loginUserInfo.containsKey("is_admin") && !"Y".equals(String.valueOf(loginUserInfo.get("is_admin")))){
				loginUserInfo.put("is_admin", isManager);
			}*/
			loginUserInfo.put("is_manager", isManager);
			if (dpDepartmentDataService.isTeamManager(String.valueOf(loginUserInfo.get("title")))) 
				loginUserInfo.put("dept_code_list", dpDepartmentDataService.getPartListUnderTeamStr(String.valueOf(loginUserInfo.get("dept_code"))));
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
	
	@RequestMapping(value = "dpDepartmentDataMainGrid.do")
	public @ResponseBody Map<String, Object> dpDepartmentDataMainGridAction(CommandMap commandMap) throws Exception {
		if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
			commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
		if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
			commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
		
		Map<String,Object> returnData = dpDepartmentDataService.getGridListNoPagingDps(commandMap);
		String baseworktime = dpDepartmentDataService.getBaseWorkTime(commandMap);
		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		DecimalFormat df = new DecimalFormat("###,###.##");
        
		return returnData;
	}
	
	
	@RequestMapping(value = "dpDeptDataExcelExport.do")
	public View dpDeptDataExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return dpDepartmentDataService.dpsExcelExport(commandMap, modelMap);
	}
}
