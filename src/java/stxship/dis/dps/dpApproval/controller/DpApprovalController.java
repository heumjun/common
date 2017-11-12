package stxship.dis.dps.dpApproval.controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.map.CaseInsensitiveMap;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.dps.dpApproval.service.DpApprovalService;

/**
 * @파일명 : DpApprovalController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DpApprovalController의 컨트롤러
 *     </pre>
 */
@Controller
public class DpApprovalController extends CommonController {
	@Resource(name = "dpApprovalService")
	private DpApprovalService dpApprovalService;

	/**
	 * 
	 * @메소드명	: stxPECDPApprovalAction
	 * @날짜		: 2016. 9. 20.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 일일시수 결재관리 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "stxPECDPApproval.do")
	public ModelAndView stxPECDPApprovalAction(CommandMap commandMap) throws Exception {
		ModelAndView mv = new ModelAndView("/dps/dpApproval" + commandMap.get(DisConstants.JSP_NAME));
		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		
		/*기본정보 설정 시작*/
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("loginId",commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		Map<String,Object> loginUserInfo = dpApprovalService.getEmployeeInfo(param);
		List<Map<String,Object>> departmentList = null;
		String isManager = "N";
		
		if(loginUserInfo != null){
			loginUserInfo.put("employeeID", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			isManager = dpApprovalService.isDepartmentManagerYN(String.valueOf(loginUserInfo.get("title")));
			loginUserInfo.put("is_manager", isManager);
		} else {
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
		
		if(!loginUserInfo.containsKey("is_admin")){
			loginUserInfo.put("is_admin", "N");
		} else {
			departmentList = dpApprovalService.getDepartmentList();
		}
		// SDPS 시스템에 등록된 사용자가 아닌 경우 Exit
		if(loginUserInfo.get("employeeID") == null || "".equals(loginUserInfo.get("employeeID"))){
			return new ModelAndView("/common/stxPECDP_LoginFailed");
		}
	    // 매너저(파트장) 권한이 아니면 Exit
		if(!isManager.equals("Y") && "N".equals(String.valueOf(loginUserInfo.get("is_admin")))){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		// 퇴사자인 경우 Exit
		if(loginUserInfo.get("termination_date") != null){
			return new ModelAndView("/common/stxPECDP_LoginFailed2");
		}
		param.clear();
		param.put("departmentList", departmentList);
		param.put("loginUserInfo", loginUserInfo);
		mv.addAllObjects(param);
		
		return mv;
	}
	
	/**
	 * 
	 * @메소드명	: popUpApprovalListView
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 시수입력 (DIS)
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="popUpApprovalListView.do")
	public ModelAndView popUpApprovalListView(HttpServletRequest request,CommandMap commandMap) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView("/dps/dpApproval"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpApprovalListViewMainGrid
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 결제조회 메인그리드 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpApprovalListViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpApprovalListViewMainGrid(CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: popUpApprovalInputRateView
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 입력률 조회 화면
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="popUpApprovalInputRateView.do")
	public ModelAndView popUpApprovalInputRateView(HttpServletRequest request,CommandMap commandMap) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView("/dps/dpApproval"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpApprovalInputRateViewMainGrid
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 결제조회 메인그리드 
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpApprovalInputRateViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpApprovalInputRateViewMainGrid(HttpServletRequest request,CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: popUpApprovalHolidayCheckView
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 *	휴일체크
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="popUpApprovalHolidayCheckView.do")
	public ModelAndView popUpApprovalHolidayCheckView(HttpServletRequest request,CommandMap commandMap) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		ModelAndView mav = new ModelAndView("/dps/dpApproval"+DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	/**
	 * 
	 * @메소드명	: popUpApprovalHolidayCheckViewMainGrid
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 휴일체크
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpApprovalHolidayCheckViewMainGrid.do")
	public @ResponseBody Map<String, Object> popUpApprovalHolidayCheckViewMainGrid(HttpServletRequest request,CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: getPartDPConfirmsList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 결제 현황
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getPartDPConfirmsList.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartDPConfirmsList(CommandMap commandMap) throws Exception{
		return DisJsonUtil.listToJsonstring(dpApprovalService.getPartDPConfirmsList(commandMap));
	}
	
	/**
	 * 
	 * @메소드명	: getPartDPInputRateList
	 * @날짜		: 2016. 9. 21.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 시수 입력률
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getPartDPInputRateList.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getPartDPInputRateList(CommandMap commandMap) throws Exception{
		return DisJsonUtil.listToJsonstring(dpApprovalService.getPartDPInputRateList(commandMap));
	}
	/**
	 * 
	 * @메소드명	: dpApprovalPersonMainGrid
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *부서(파트) + 날짜에 해당하는 입력시수 결재 여부를 쿼리
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpApprovalPersonMainGrid.do")
	public @ResponseBody Map<String, Object> dpApprovalPersonMainGrid(HttpServletRequest request,CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	/**
	 * 
	 * @메소드명	: dpApprovalPersonDetailMainGrid
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 상세 입력시수 조회   사번 + 날짜의 시수입력 사항을 쿼리
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpApprovalPersonDetailMainGrid.do")
	public @ResponseBody Map<String, Object> dpApprovalPersonDetailMainGrid(HttpServletRequest request,CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	/**
	 * 
	 * @메소드명	: getDwgDeptGubun
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 부서의 종류(상선, 해양, 특수선)를 판단 - TODO (현재는 해양부서 여부만 Hard Code 로 판단)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="getDwgDeptGubun.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String getDwgDeptGubun(CommandMap commandMap) throws Exception{
		return dpApprovalService.getDwgDeptGubun(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: dpApprovalPersonDetailOceanMainGrid
	 * @날짜		: 2016. 9. 22.
	 * @작성자	: 조중호
	 * @설명		: 
	 * <pre>
	 * 해양부서 초과 시수 조회
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpApprovalPersonDetailOceanMainGrid.do")
	public @ResponseBody Map<String, Object> dpApprovalPersonDetailOceanMainGrid(HttpServletRequest request,CommandMap commandMap) throws Exception {
		Map<String,Object> returnData = dpApprovalService.getGridListNoPagingDps(commandMap);
		return returnData;
	}
	
	/**
	 * 
	 * @메소드명	: dpApprovalMainGridSave
	 * @날짜		: 2016. 9. 23.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * saveApprovals() : 시수결재 사항을 DB에 저장 + 공정 시수 업데이트 + 시수마감
	 * 2015-10-06 : PLM_DESIGN_MH_CLOSE_PROC가 saveApprovals()에서 수행하던 시수결재 저장, 공정 시수 업데이트, 시수마감 등 수행
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "dpApprovalMainGridSave.do")
	public @ResponseBody Map<String, String> dpApprovalMainGridSave(CommandMap commandMap) throws Exception {
		return dpApprovalService.dpApprovalMainGridSave(commandMap);
	}
	
}
