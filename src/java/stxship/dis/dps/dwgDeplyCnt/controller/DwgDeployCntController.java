package stxship.dis.dps.dwgDeplyCnt.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.dps.dwgDeplyCnt.service.DwgDeployCntService;
/**
 * 
 * @파일명	: DwgDeployCntController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 8. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 도면 출도 건 수 조회
 * </pre>
 */
@Controller
public class DwgDeployCntController extends CommonController {

	@Resource(name="dwgDeployCntService")
	private DwgDeployCntService dwgDeployCntService;
	/**
	 * 
	 * @메소드명	: stxPECDPDwgDeployedCnt
	 * @날짜		: 2016. 8. 8.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *도면 출도 건수 조회 메인
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="stxPECDPDwgDeployedCnt.do")
	public ModelAndView stxPECDPDwgDeployedCnt(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dwgDeployCnt" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dwgDeployCntService.getEmployeeInfo(param);
		
		
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
		if(loginUserInfo == null){
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		// 관리자가 아닌 경우 Exit
		if( 
			("N".equals(String.valueOf(loginUserInfo.get("is_admin"))) ||
			 loginUserInfo.get("termination_date") != null)){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		if(loginUserInfo.get("loginId") != null && "200043".equals(String.valueOf(loginUserInfo.get("loginId")))){
			loginUserInfo.put("is_admin", "Y");
		}// 조선해양연구소 이광일 과장 - 연구소 Hard Copy 출도정보 조회가 필요하여 예외적으로 적용
		
		List<Map<String,Object>> departmentList = dwgDeployCntService.getDepartmentList();
		List<Map<String,Object>> reasonCodeList = dwgDeployCntService.getReasonCodeList();
		
		param.clear();
		param.put("loginUserInfo", loginUserInfo);
		param.put("departmentList", departmentList);
		param.put("reasonCodeList", reasonCodeList);
		
		mv.addAllObjects(param);
		
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: dwgDeployCntMainGrid
	 * @날짜		: 2016. 8. 8.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 도면 출도 건 수 조회 메인 그리드 데이터 수집
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dwgDeployCntMainGrid.do")
	public @ResponseBody Map<String, Object> dwgDeployCntMainGridAction(CommandMap commandMap) throws Exception {
		String selectedProjectList = String.valueOf(commandMap.get("projectList"));
		
		if(!"".equals(selectedProjectList)){
			ArrayList<String> temp = new ArrayList<String>(Arrays.asList(selectedProjectList.split(",")));
			commandMap.put("projectList", temp);
		} else {
			commandMap.remove("projectList");	
		}
		
		String erpSessionId = dwgDeployCntService.getERPSessionValue();
		commandMap.put("sessionid", erpSessionId);
		dwgDeployCntService.deleteERPDwgDpsTemp(erpSessionId);
		dwgDeployCntService.insertERPDwgDpsTemp(commandMap.getMap());
		Map<String,Object> returnData = dwgDeployCntService.getGridListNoPagingDps(commandMap);
		dwgDeployCntService.deleteERPDwgDpsTemp(erpSessionId);
		return returnData;
	}
}
