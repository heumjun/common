/**
 * 
 */
package stxship.dis.dps.dpDataMgmt.controller;

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
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.dpDataMgmt.service.DataMgmtService;

/** 
 * @파일명	: DataMgmtController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 10. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 설계시수 Data 관리 controller
 * </pre>
 */
@Controller
public class DataMgmtController extends CommonController {
	@Resource(name="dataMgmtService")
	private DataMgmtService dataMgmtService;
	
	@RequestMapping(value = "stxPECDPDataMgmt.do")
	public ModelAndView stxPECDPDataMgmt(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpDataMgmt" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dataMgmtService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		List<Map<String,Object>> facotrCaseList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("designerid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			departmentList = dataMgmtService.getProgressDepartmentList();
			facotrCaseList = dataMgmtService.getMHFactorCaseAndValueList();
			
			isManager = dataMgmtService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			loginUserInfo.put("is_manager", isManager);
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
			(!"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("mh_yn"))) &&
			 !"Y".equalsIgnoreCase(String.valueOf(loginUserInfo.get("progress_yn"))) ||
			 loginUserInfo.get("termination_date") != null)){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		param.clear();
		param.put("departmentList", departmentList);
		param.put("factorCaseList", facotrCaseList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: dataMgmtMainGridAction
	 * @날짜		: 2016. 8. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 설계시수 데이터 관리 그리드 호출
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dataMgmtMainGrid.do")
	public @ResponseBody Map<String, Object> dataMgmtMainGridAction(CommandMap commandMap) throws Exception {
		String drawingNo = "";
		boolean drawingNoCheck = false;
		for (int i = 0; i < 8; i++) {
			if (!"".equals(String.valueOf(commandMap.get("drawingNo["+i+"]")))) {
				drawingNo +=  String.valueOf(commandMap.get("drawingNo["+i+"]"));
				drawingNoCheck = true;
			} else {
				drawingNo += "_";
			}
		}
		if(drawingNoCheck)commandMap.put("drawingNo",drawingNo);
		else commandMap.put("drawingNo","");
		
		if(!"".equals(String.valueOf(commandMap.get("projectList")))){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(",")));
			commandMap.put("projectList", temp);
		} else {
			commandMap.remove("projectList");	
		}
		
		if(!"".equals(String.valueOf(commandMap.get("departmentList")))){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(",")));
			commandMap.put("departmentList", temp);
		} else {
			commandMap.remove("departmentList");	
		}
		
		if (!"".equals(String.valueOf(commandMap.get("designerInput")))) {
			String tempEmpNo =  String.valueOf(commandMap.get("designerInput"));
			commandMap.put("designerList", tempEmpNo);
		}		
		
		Map<String,Object> returnData = dataMgmtService.getGridListDps(commandMap);
		return returnData;
	}
	
	
	/**
	 * 
	 * @메소드명	: dataMgmtExcelExportAction
	 * @날짜		: 2016. 12. 22.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 엑셀 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "dataMgmtExcelExport.do")
	public View dataMgmtExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) {
		String drawingNo = "";
		boolean drawingNoCheck = false;
		for (int i = 0; i < 8; i++) {
			if (!"".equals(String.valueOf(commandMap.get("drawingNo["+i+"]")))) {
				drawingNo +=  String.valueOf(commandMap.get("drawingNo["+i+"]"));
				drawingNoCheck = true;
			} else {
				drawingNo += "_";
			}
		}
		if(drawingNoCheck)commandMap.put("drawingNo",drawingNo);
		else commandMap.put("drawingNo","");
		
		if(!"".equals(String.valueOf(commandMap.get("projectList")))){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("projectList")).split(",")));
			commandMap.put("projectList", temp);
		} else {
			commandMap.remove("projectList");	
		}
		
		if(!"".equals(String.valueOf(commandMap.get("departmentList")))){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(String.valueOf(commandMap.get("departmentList")).split(",")));
			commandMap.put("departmentList", temp);
		} else {
			commandMap.remove("departmentList");	
		}
		
		if (!"".equals(String.valueOf(commandMap.get("designerInput")))) {
			String tempEmpNo =  String.valueOf(commandMap.get("designerInput"));
			commandMap.put("designerList", tempEmpNo);
		}
		
		return dataMgmtService.dataMgmtExcelExport(commandMap, modelMap);
	}
	
	/**
	 * 
	 * @메소드명	: dataMgmtMainGridSaveAction
	 * @날짜		: 2016. 8. 12.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 설계시수 데이터 관리 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	
	/*@RequestMapping(value = "dataMgmtMainGridSave.do")
	public @ResponseBody Map<String, String> dataMgmtMainGridSaveAction(CommandMap commandMap) throws Exception {
		return dataMgmtService.saveGridListDps(commandMap);
	}*/
}
