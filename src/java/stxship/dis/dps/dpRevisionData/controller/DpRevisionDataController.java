/**
 * 
 */
package stxship.dis.dps.dpRevisionData.controller;

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

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.dps.dpRevisionData.service.DpRevisionDataService;

/** 
 * @파일명	: DpRevisionDataController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 22. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 부서별 개정시수조회 Controller
 * </pre>
 */
@Controller
public class DpRevisionDataController extends CommonController {
	
	@Resource(name="dpRevisionDataService")
	private DpRevisionDataService dpRevisionDataService;
	
	/**
	 * 
	 * @메소드명	: stxPECDPRevisionData
	 * @날짜		: 2016. 8. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서별 개정시수 조회 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stxPECDPRevisionData.do")
	public ModelAndView stxPECDPRevisionData(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpRevisionData" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpRevisionDataService.getEmployeeInfo(param);
		List<Map<String,Object>> facotrCaseList = null;
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> opCodeList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			facotrCaseList = dpRevisionDataService.getMHFactorCaseAndValueList();
			departmentList = dpRevisionDataService.getAllDepartmentList();
			opCodeList = dpRevisionDataService.getOPCodesForRevision();
			
			isManager = dpRevisionDataService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			loginUserInfo.put("is_manager", isManager);
			if (dpRevisionDataService.isTeamManager(String.valueOf(loginUserInfo.get("title")))) 
				loginUserInfo.put("dept_code_list", dpRevisionDataService.getPartListUnderTeamStr(String.valueOf(loginUserInfo.get("dept_code"))));
	            
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
		param.put("opCodeList", opCodeList);
		param.put("factorCaseList", facotrCaseList);
		param.put("departmentList", departmentList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	/**
	 * 
	 * @메소드명	: dpRevisionDataMainGridAction
	 * @날짜		: 2016. 8. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 부서별 개정 시수 조회
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpRevisionDataMainGrid.do")
	public @ResponseBody Map<String, Object> dpRevisionDataMainGridAction(CommandMap commandMap) throws Exception {
		if(commandMap.get("departmentList") != null && !"".equals(String.valueOf(commandMap.get("departmentList"))))
			commandMap.put("dept_code_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(","))));
		if(commandMap.get("projectList") != null && !"".equals(String.valueOf(commandMap.get("projectList"))))
			commandMap.put("project_no_list", new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(","))));
		
		Map<String,Object> returnData = dpRevisionDataService.getGridListNoPagingDps(commandMap);
		ArrayList<CaseInsensitiveMap> rows = (ArrayList<CaseInsensitiveMap>) returnData.get("rows");
		DecimalFormat df = new DecimalFormat("###,###.##");
		ArrayList<CaseInsensitiveMap> newRows = new ArrayList<CaseInsensitiveMap>();
		List<Map<String,Object>> opCodeList = dpRevisionDataService.getOPCodesForRevision();
		
		String deptCode = "";
		CaseInsensitiveMap newMap = null;
	    for(CaseInsensitiveMap map : rows){
	    	if (!deptCode.equals(String.valueOf(map.get("dept_code")))) {
	    		if (newMap != null) newRows.add(newMap);
	    		newMap = new CaseInsensitiveMap();
	    		newMap.put("dept_code", map.get("dept_code"));
	    		newMap.put("dept_name", map.get("dept_name"));
				deptCode = String.valueOf(map.get("dept_code"));
	    	}
	    	newMap.put(String.valueOf(map.get("op_code")), map.get("op_wtime"));
	    }
	    if (newMap != null) newRows.add(newMap);
	    
	    for(CaseInsensitiveMap map : newRows){
	    	float opWTimeRowTotal = 0;
            float opWTimeRowTotal2 = 0;
            
            for(Map<String,Object> opMap : opCodeList){
            	 String keyStr = (String)opMap.get("key");
                 String valueStr = "";

                 if (map.containsKey(keyStr)) {
                     float opWTimeVal = Float.parseFloat((String)map.get(keyStr));

                     opWTimeRowTotal += opWTimeVal;
                     valueStr = df.format(opWTimeVal);

                     if ("5K,5L,5M,5R".indexOf(keyStr) < 0) opWTimeRowTotal2 += opWTimeVal;
                 }
                 map.put(keyStr, valueStr);
            }
            String valueStr = df.format(opWTimeRowTotal);
            map.put("op_wtime_row_total", valueStr);
            valueStr = "";
            if (opWTimeRowTotal2 != 0){
            	valueStr = df.format(opWTimeRowTotal2);
            	map.put("op_wtime_row_total2", valueStr);
            }
            valueStr = "";
            if (map.containsKey("20")) {
                float opWTimeVal = Float.parseFloat((String)map.get("20"));
                valueStr = df.format(opWTimeVal);
                map.put("op_wtime_val", valueStr);
            }
	    }
		return returnData;
	}
}
