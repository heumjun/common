package stxship.dis.ems.adminNew.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.ems.adminNew.service.EmsNewAdminService;

/** 
 * @파일명	: EmsAdminController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 03. 21. 
 * @작성자	: 이상빈 
 * @설명
 * <pre>
 * EmsAdmin 컨트롤러
 * </pre>
 */

@Controller
public class EmsNewAdminController extends CommonController {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name = "emsNewAdminService")
	private EmsNewAdminService emsNewAdminService;
	
	/**
	 * 
	 * @메소드명	: linkSelectedMenu
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * emsAdminNew 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsAdminNew.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		String sWorkKey = Long.toString(System.currentTimeMillis());
		commandMap.put("p_work_key", sWorkKey);
		return getUserRoleAndLink(commandMap);
	}
	/**
	 * 
	 * @메소드명	: emsNewAdminList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * emsNewAdminList 로드
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewAdminList.do")
	public @ResponseBody Map<String, Object> emsNewAdminList(CommandMap commandMap) throws Exception {
		return emsNewAdminService.selectEmsAdminMainList(commandMap);
	}
	/**
	 * 
	 * @메소드명	: emsNewAdminApprovedBoxDataList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	ems 승인자 목록
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewAdminApprovedBoxDataList.do")
	public @ResponseBody String emsNewAdminApprovedBoxDataList(CommandMap commandMap) throws Exception {
		return emsNewAdminService.getEmsApprovedBoxDataList(commandMap);
	}
	/**
	 * 
	 * @메소드명	: sscAutoCompleteDwgNoList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ems 도면 자동완성
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsNewAdminAutoCompleteDwgNoList.do")
	public @ResponseBody String sscAutoCompleteDwgNoList(CommandMap commandMap) throws Exception {
		return emsNewAdminService.selectAutoCompleteDwgNoList(commandMap);
	}
	/**
	 * 
	 * @메소드명	: popUpPurchasingNewPosDownloadFile
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 추가 버튼 팝업창 : 파일 다운로드
	 * </pre>
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpAdminNewPosDownloadFile.do")
	public View popUpPurchasingNewPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsNewAdminService.popUpAdminPosDownloadFile(commandMap, modelMap);
	}
	
	/**
	 * 
	 * @메소드명	: emsAdminNewPosChk
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * POS전 검색 조건에서 project 및 dwg_no 체크
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsAdminNewPosChk.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String emsAdminNewPosChk(CommandMap commandMap) throws Exception {
		return DisJsonUtil.mapToJsonstring(emsNewAdminService.selectPosChk(commandMap));
	}
	/**
	 * 
	 * @메소드명	: popUpAdminNewSpec
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * 사양 버튼 팝업창 실행
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAdminNewSpec.do")
	public ModelAndView popUpAdminNewSpec(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpPurchasingNewDp
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * DP 버튼 팝업창 실행
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAdminNewDp.do")
	public ModelAndView popUpPurchasingNewDp(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * 
	 * @메소드명	: popUpAdminNewDpList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * DP 버튼 팝업창 : 조회 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAdminNewDpList.do")
	public @ResponseBody Map<String, Object> popUpAdminNewDpList(CommandMap commandMap) {

		// 선택 호선 배열로 변환
		String projectsArray[] = commandMap.get("p_project").toString().split(",");
		commandMap.put("projectsArray", projectsArray);

		// 선택 도면번호 배열로 변환
		String dwgNosArray[] = commandMap.get("p_dwg_no").toString().split(",");
		commandMap.put("dwgNosArray", dwgNosArray);

		return emsNewAdminService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpAdminNewSpecList
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 *	Spec팝업 리스트
	 * </pre>
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpAdminNewSpecList.do")
	public @ResponseBody Map<String, Object> popUpAdminNewSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception {
		return emsNewAdminService.popUpAdminNewSpecList(request, commandMap);
	}
	
	/**
	 * 
	 * @메소드명	: popUpEmsAdminNewConfirm
	 * @날짜		: 2017. 4. 28.
	 * @작성자	: dkfemdnjs
	 * @설명		: 
	 * <pre>
	 * ADMIN CONFIRM
	 * </pre>
	 * @param req
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpEmsAdminNewConfirm.do")
	public @ResponseBody Map<String, String> popUpEmsAdminNewConfirm(HttpServletRequest req,CommandMap commandMap) throws Exception {
		return emsNewAdminService.popUpEmsAdminNewConfirm(commandMap);
	}
	
}
