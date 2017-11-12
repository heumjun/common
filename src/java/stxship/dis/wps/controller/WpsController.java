package stxship.dis.wps.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.wps.service.WpsService;


/**
 * 
 * @파일명		: WpsController.java 
 * @프로젝트	: DIMS
 * @날짜		: 2017. 10. 11. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Controller
public class WpsController extends CommonController {

	@Resource(name = "WpsService")
	private WpsService wpsService;
	
	/**
	 * 
	 * @메소드명	: wpsCodeManage
	 * @날짜		: 2017. 10. 11.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsCodeManage.do")
	public ModelAndView wpsCodeManage(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "wpsCodeTypeSelectBoxDataList.do")
	public @ResponseBody String wpsCodeTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsCodeTypeSelectBoxDataList(commandMap);
	}
	
	@RequestMapping(value = "wpsCodeTypeSelectBoxGridList.do")
	public @ResponseBody List<Map<String, Object>> wpsCodeTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsService.wpsCodeTypeSelectBoxGridList(commandMap);
	}
	
	
	@RequestMapping(value = "wpsCodeManageList.do")
	public @ResponseBody Map<String, Object> wpsCodeManageList(CommandMap commandMap) throws Exception {
		return wpsService.wpsCodeManageList(commandMap);
	}
	
	@RequestMapping(value = "saveWpsCodeManage.do")
	public @ResponseBody Map<String, Object> saveWpsCodeManage(CommandMap commandMap) throws Exception {
		return wpsService.saveWpsCodeManage(commandMap);
	}
	
	
	
	/**
	 * 
	 * @메소드명	: wpsManage
	 * @날짜		: 2017. 10. 11.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	WPS 관리 페이지 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsManage.do")
	public ModelAndView wpsManage(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsPlateTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	Joint Type selectBox Data
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsPlateTypeSelectBoxDataList.do")
	public @ResponseBody String wpsPlateTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsPlateTypeSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsProcessTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	Welding Process selectBox Data
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsProcessTypeSelectBoxDataList.do")
	public @ResponseBody String wpsProcessTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsProcessTypeSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsTypeSelectBoxDataList
	 * @날짜		: 2017. 10. 31.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		Welding Type selectBox Data
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsTypeSelectBoxDataList.do")
	public @ResponseBody String wpsTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsTypeSelectBoxDataList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsProcessTypeSelectBoxGridList
	 * @날짜		: 2017. 10. 26.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		wps Manage 에서 그리드내 welding Process selectBox 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsProcessTypeSelectBoxGridList.do")
	public @ResponseBody List<Map<String, Object>> wpsProcessTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsService.wpsProcessTypeSelectBoxGridList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsTypeSelectBoxGridList
	 * @날짜		: 2017. 10. 26.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		wps Manage 에서 그리드내 welding Type selectBox 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsTypeSelectBoxGridList.do")
	public @ResponseBody List<Map<String, Object>> wpsTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsService.wpsTypeSelectBoxGridList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsPlateTypeSelectBoxGridList
	 * @날짜		: 2017. 10. 26.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		wps Manage 에서 그리드내 Joint Type selectBox 데이터
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsPlateTypeSelectBoxGridList.do")
	public @ResponseBody List<Map<String, Object>> wpsPlateTypeSelectBoxGridList(CommandMap commandMap) throws Exception {
		return wpsService.wpsPlateTypeSelectBoxGridList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsManageList
	 * @날짜		: 2017. 10. 12.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *	WPS 관리 메인 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsManageList.do")
	public @ResponseBody Map<String, Object> wpsManageList(CommandMap commandMap) throws Exception {
		return wpsService.wpsManageList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsPositionCodeList
	 * @날짜		: 2017. 10. 30.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		WPS 관리 - Welding Position 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsPositionCodeList.do")
	public @ResponseBody Map<String, Object> wpsPositionCodeList(CommandMap commandMap) throws Exception {
		return wpsService.wpsPositionCodeList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsApprovalCodeList
	 * @날짜		: 2017. 10. 30.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		WPS 관리 - Approval Class 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsApprovalCodeList.do")
	public @ResponseBody Map<String, Object> wpsApprovalCodeList(CommandMap commandMap) throws Exception {
		return wpsService.wpsApprovalCodeList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsMetalCodeList
	 * @날짜		: 2017. 10. 30.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		WPS 관리 - Qualitied Base Metal 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsMetalCodeList.do")
	public @ResponseBody Map<String, Object> wpsMetalCodeList(CommandMap commandMap) throws Exception {
		return wpsService.wpsMetalCodeList(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsFileUpLoadAction
	 * @날짜		: 2017. 10. 31.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *		WPS Manage Pdf File Upload Action
	 * </pre>
	 * @param commandMap
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsFileUpLoadAction.do")
	public @ResponseBody void wpsFileUpLoadAction(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Map<String, Object> rtnMap = wpsService.wpsFileUpLoad(commandMap, request);
		
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		response.getWriter().write(DisJsonUtil.mapToJsonstring(rtnMap));
	}
	
	@RequestMapping(value = "wpsManageSaveAction.do")
	public @ResponseBody Map<String, Object> wpsManageSaveAction(CommandMap commandMap) throws Exception {
		return wpsService.wpsManageSaveAction(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: wpsConfirm
	 * @날짜		: 2017. 10. 11.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsConfirm.do")
	public ModelAndView wpsConfirm(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "wpsConfirmList.do")
	public @ResponseBody Map<String, Object> wpsConfirmList(CommandMap commandMap) throws Exception {
		return wpsService.wpsConfirmList(commandMap);
	}
	
	@RequestMapping(value = "wpsApprovalClassTypeSelectBoxDataList.do")
	public @ResponseBody String wpsApprovalClassTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsApprovalClassTypeSelectBoxDataList(commandMap);
	}
	
	@RequestMapping(value = "wpsPositionTypeSelectBoxDataList.do")
	public @ResponseBody String wpsPositionTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsPositionTypeSelectBoxDataList(commandMap);
	}
	
	@RequestMapping(value = "wpsBaseMetalTypeSelectBoxDataList.do")
	public @ResponseBody String wpsBaseMetalTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsBaseMetalTypeSelectBoxDataList(commandMap);
	}
	
	@RequestMapping(value = "saveWpsConfirmAction.do")
	public @ResponseBody Map<String, Object> saveWpsConfirmAction(CommandMap commandMap) throws Exception {
		return wpsService.saveWpsConfirmAction(commandMap);
	}
	
	
	/**
	 * 
	 * @메소드명	: wpsUpdate
	 * @날짜		: 2017. 11. 9.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsChange.do")
	public ModelAndView wpsUpdate(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "wpsChangeTypeSelectBoxDataList.do")
	public @ResponseBody String wpsChangeTypeSelectBoxDataList(CommandMap commandMap) throws Exception {
		return wpsService.wpsChangeTypeSelectBoxDataList(commandMap);
	}
	
	
	@RequestMapping(value = "wpsChangeList.do")
	public @ResponseBody Map<String, Object> wpsChangeList(CommandMap commandMap) throws Exception {
		return wpsService.wpsChangeList(commandMap);
	}
	
	
	/**
	 * 
	 * @메소드명	: wpsSearch
	 * @날짜		: 2017. 10. 11.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "wpsSearch.do")
	public ModelAndView wpsSearch(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	

}
