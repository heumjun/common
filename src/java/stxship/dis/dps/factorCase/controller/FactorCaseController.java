/**
 * 
 */
package stxship.dis.dps.factorCase.controller;

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
import stxship.dis.dps.factorCase.service.FactorCaseService;

/** 
 * @파일명	: FactorCaseController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 8. 9. 
 * @작성자	: 조중호 
 * @설명
 * <pre>
 * 시수 적용율 Case관리
 * </pre>
 */

@Controller
public class FactorCaseController extends CommonController {
	
	@Resource(name = "factorCaseService")
	private FactorCaseService factorCaseService;
	
	/**
	 * 
	 * @메소드명	: stxPECDPDwgRegister
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수 적용율 Case관리 화면
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stxPECDPMHFactorCaseInput.do")
	public ModelAndView stxPECDPDwgRegister(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/factorCase" + commandMap.get(DisConstants.JSP_NAME));
		mv.addAllObjects(commandMap.getMap());
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = factorCaseService.getEmployeeInfo(param);
		List<Map<String,Object>> mhFactorCaseList = null;
		
		if(loginUserInfo != null){
			if(loginUserInfo.containsKey("is_admin")){
                mhFactorCaseList = factorCaseService.getMHFactorCaseList();
            }
		} else {
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}

		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		}
		
		// 시수입력 가능한 사용자가 아닌 경우 Exit
		if(String.valueOf(loginUserInfo.get("is_admin")).equals("N")){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		
		param.clear();
		param.put("mhFactorCaseList", mhFactorCaseList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	/**
	 * 
	 * @메소드명	: factorCaseMainGridAction
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수 적용율 Case관리 MainGrid
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "factorCaseMainGrid.do")
	public @ResponseBody Map<String, Object> factorCaseMainGridAction(CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = factorCaseService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: dwgRegisterMainGridSaveAction
	 * @날짜		: 2016. 8. 9.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수 적용율 Case관리 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	
	@RequestMapping(value = "factorCaseMainGridSave.do")
	public @ResponseBody Map<String, String> dwgRegisterMainGridSaveAction(CommandMap commandMap) throws Exception {
		return factorCaseService.dwgRegisterMainGridSave(commandMap);
	}
}
