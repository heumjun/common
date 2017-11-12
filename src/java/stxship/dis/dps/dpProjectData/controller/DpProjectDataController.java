/**
 * 
 */
package stxship.dis.dps.dpProjectData.controller;

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
import stxship.dis.dps.dpProjectData.service.DpProjectDataService;

/** 
 * @파일명	: DpProjectDataController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 17. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 호선별 시수조회 컨트롤러
 * </pre>
 */
@Controller
public class DpProjectDataController extends CommonController {
	@Resource(name="dpProjectDataService")
	private DpProjectDataService dpProjectDataService;
	
	/**
	 * 
	 * @메소드명	: stxPECDPPersonData
	 * @날짜		: 2016. 8. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선별 시수조회 화면 로드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stxPECDPProjectData.do")
	public ModelAndView stxPECDPPersonData(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpProjectData" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpProjectDataService.getEmployeeInfo(param);
		List<Map<String,Object>> facotrCaseList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			facotrCaseList = dpProjectDataService.getMHFactorCaseAndValueList();
			
			isManager = dpProjectDataService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			/*if(loginUserInfo.containsKey("is_admin") && !"Y".equals(String.valueOf(loginUserInfo.get("is_admin")))){
				loginUserInfo.put("is_admin", isManager);
			}*/
			loginUserInfo.put("is_manager", isManager);
			if (dpProjectDataService.isTeamManager(String.valueOf(loginUserInfo.get("title")))) 
				loginUserInfo.put("dept_code_list", dpProjectDataService.getPartListUnderTeamStr(String.valueOf(loginUserInfo.get("dept_code"))));
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
	 * @메소드명	: dpProejctDataMainGridAction
	 * @날짜		: 2016. 8. 19.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 호선별 시수조회 메인 그리드 로드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpProjectDataMainGrid.do")
	public @ResponseBody Map<String, Object> dpProejctDataMainGridAction(CommandMap commandMap) throws Exception {
		if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
			commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
		if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
			commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
		
		Map<String,Object> returnData = dpProjectDataService.getGridListNoPagingDps(commandMap);
		String baseworktime = dpProjectDataService.getBaseWorkTime(commandMap);
		returnData.put("baseworktime", baseworktime);
        
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: popUpProjectDataERPIFFS
	 * @날짜		: 2016. 8. 18.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP 인터페이스 팝업 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProjectDataERPIFFS.do")
	public ModelAndView popUpProjectDataERPIFFS(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpProjectData"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		List<Map<String,Object>> facotrCaseList = dpProjectDataService.getMHFactorCaseAndValueList();
		
		mv.addObject("factorCaseList",facotrCaseList);
		return mv;
	}
	
	/*popUpProjectDataERPIFFSMainGrid*/
	/**
	 * 
	 * @메소드명	: popUpProjectDataERPIFFSMainGridAction
	 * @날짜		: 2016. 8. 18.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP INTERFACE POPUP MAIN GRID
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProjectDataERPIFFSMainGrid.do")
	public @ResponseBody Map<String, Object> popUpProjectDataERPIFFSMainGridAction(CommandMap commandMap) throws Exception {
		if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
			commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
		if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
			commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
		
		Map<String,Object> returnData = dpProjectDataService.getGridListNoPagingDps(commandMap);
		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		DecimalFormat df = new DecimalFormat("###,###.##");
		
		ArrayList<CaseInsensitiveMap> newRows = new ArrayList<CaseInsensitiveMap>(); 
		for(CaseInsensitiveMap map : rows){
            
            if (map.containsKey("erp_create_date") && !"".equals(String.valueOf(map.get("erp_create_date")))) {
            	map.put("erpifyn", "Y");
            } else {
            	map.put("erpifyn", "N");
            }
            
            float erp_wtime_f = !map.containsKey("erp_wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("erp_wtime_f")));
            float wtime = !map.containsKey("wtime") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime")));
            float wtime_f = !map.containsKey("wtime_f") ? 0 : Float.parseFloat(String.valueOf(map.get("wtime_f")));
            map.put("erp_wtime_f", (erp_wtime_f == 0) ? "&nbsp;" : df.format(erp_wtime_f));
            map.put("wtime_f", (wtime_f == 0) ? "&nbsp;" : df.format(Math.round(wtime_f*100)/100.0));
            map.put("wtime", (wtime == 0) ? "&nbsp;" : df.format(wtime));
            
            newRows.add(map);
		}
		
		returnData.put("rows", newRows);
		
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: popUpProjectDataERPIFFSMainGridSave
	 * @날짜		: 2016. 8. 18.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * ERP INTERFACE POP UP GRID SAVE
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpProjectDataERPIFFSMainGridSave.do")
	public @ResponseBody Map<String, String> popUpProjectDataERPIFFSMainGridSaveAction(CommandMap commandMap) throws Exception {
		return dpProjectDataService.popUpProjectDataERPIFFSMainGridSave(commandMap);
	}
	
	
	@RequestMapping(value = "dpProjectDataExcelExport.do")
	public View dpProjectDataExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return dpProjectDataService.dpsExcelExport(commandMap, modelMap);
	}
}
