package stxship.dis.ems.dbMaster.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.ems.dbMaster.service.EmsDbMasterService;

/** 
 * @파일명	: EmsDbMasterController.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 02. 11. 
 * @작성자	: 이상빈 
 * @설명
 * <pre>
 * EmsDbMaster 컨트롤러
 * </pre>
 */

@Controller
public class EmsDbMasterController extends CommonController {
	@Resource(name = "emsDbMasterService")
	private EmsDbMasterService emsDbMasterService;
	
	/** 
	 * @메소드명	: linkSelectedMenu
	 * @날짜		: 2016. 02. 11. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * EmsDbMaster 모듈로 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsDbMaster.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}
	
	@RequestMapping(value = "emsDbMasterLink.do")
	public ModelAndView emsDbMasterLink(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(DisConstants.EMS + "/emsDbMaster");
		mav.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	/** 
	 * @메소드명	: emsDbMasterLoginGubun
	 * @날짜		: 2016. 04. 18. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 접속 권한정보를 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "emsDbMasterLoginGubun.do")
	public @ResponseBody Map<String, Object> emsDbMasterLoginGubun(CommandMap commandMap) throws Exception {
		return emsDbMasterService.emsDbMasterLoginGubun(commandMap);
	}

	/** 
	 * @메소드명	: getGridListAction
	 * @날짜		: 2016. 02. 11. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * EmsDbMaster 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "emsDbMasterList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}

	/** 
	 * @메소드명	: saveEmsDbMaster
	 * @날짜		: 2016. 02. 19.
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * EmsDbMaster 수정사항 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveEmsDbMaster.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return emsDbMasterService.saveErpGridList(commandMap);
	}	
	
	/**
	 * @메소드명 : emsDbMasterExcelExport
	 * @날짜 : 2016. 02. 22.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "emsDbMasterExcelExport.do")
	public View emsDbMasterExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return emsDbMasterService.emsDbMasterExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : popUpDbMasterItem
	 * @날짜 : 2016. 02. 23.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	popUpEmsDbMasterItem 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterItem.do")
	public ModelAndView popUpDbMasterItem(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterItemList
	 * @날짜		: 2016. 02. 23. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * popUpEmsDbMasterItemList 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterItemList.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterItemList(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterItemApprove
	 * @날짜		: 2016. 02. 23. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * Master Item 요청/승인/반려 작업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsDbMasterItemApprove.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterItemApprove(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpEmsDbMasterItemApprove(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterItemSave
	 * @날짜		: 2016. 02. 24. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * Master Item 저장 작업
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsDbMasterItemSave.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterItemSave(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpEmsDbMasterItemSave(commandMap);
	}
	
	/**
	 * @메소드명 : popUpDbMasterAdd
	 * @날짜 : 2016. 02. 25.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 추가 버튼 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterAdd.do")
	public ModelAndView popUpDbMasterAdd(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddGetCatalogName
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 조회 시 CATALOG NAME 정보를 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddGetCatalogName.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddGetCatalogName(CommandMap commandMap) {
		return emsDbMasterService.popUpEmsDbMasterAddGetCatalogName(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddList_Item
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 버튼 팝업창 조회시 품목 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddList_Item.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddList_Item(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddList_Spec
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 버튼 팝업창 조회시 사양 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddList_Spec.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddList_Spec(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}	
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddItemLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 품목 그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddItemLastNum.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddItemLastNum(CommandMap commandMap) {		
		return emsDbMasterService.popUpEmsDbMasterAddItemLastNum(commandMap);
	}	
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddSpecLastNum
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 사양 그리드 추가 버튼 팝업창에서 행추가시 마지막 번호 가져옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddSpecLastNum.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddSpecLastNum(CommandMap commandMap) {		
		return emsDbMasterService.popUpEmsDbMasterAddSpecLastNum(commandMap);
	}	
	
	/** 
	 * @메소드명	: popUpEmsDbMasterAddSave
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 추가 버튼 팝업창에서 등록(저장)
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsDbMasterAddSave.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterAddSave(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpEmsDbMasterAddSave(commandMap);
	}
	
	/**
	 * @메소드명 : popUpDbMasterShipApp
	 * @날짜 : 2016. 02. 24.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 적용 선종 선택 버튼에 대한 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterShipApp.do")
	public ModelAndView popUpDbMasterShipApp(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterShipAppList
	 * @날짜		: 2016. 02. 24. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 적용 선종 선택 팝업창 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterShipAppList.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterShipAppList(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}
		
	/** 
	 * @메소드명	: popUpEmsDbMasterShipAppSave
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 적용 선종 선택 팝업창 : 등록 버튼
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsDbMasterShipAppSave.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterShipAppSave(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpEmsDbMasterShipAppSave(commandMap);
	}

	/**
	 * @메소드명 : popUpDbMasterShipDp
	 * @날짜 : 2016. 02. 28.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 선종 DP 관리 버튼에 대한 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterShipDp.do")
	public ModelAndView popUpDbMasterShipDp(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterShipAppList
	 * @날짜		: 2016. 02. 29. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 선종 DP 관리 팝업창 리스트
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpEmsDbMasterShipDpList.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterShipDpList(CommandMap commandMap) {
		return emsDbMasterService.getErpGridList(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpEmsDbMasterShipAppSave
	 * @날짜		: 2016. 02. 25. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 선종 DP 관리 팝업창 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpEmsDbMasterShipDpSave.do")
	public @ResponseBody Map<String, Object> popUpEmsDbMasterShipDpSave(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpEmsDbMasterShipDpSave(commandMap);
	}
	
	/**
	 * @메소드명 : popUpDbMasterManager
	 * @날짜 : 2016. 02. 28.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 납기관리자 버튼에 대한 팝업창을 실행한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterManager.do")
	public ModelAndView popUpDbMasterManager(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.EMS + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * @메소드명 : popUpDbMasterManagerList
	 * @날짜 : 2016. 02. 28.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	납기관리자 팝업창 : 리스트 불러옴
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "popUpDbMasterManagerList.do")
	public @ResponseBody Map<String, Object> popUpDbMasterManagerList(CommandMap commandMap) {
		return emsDbMasterService.getErpGridListNoPaging(commandMap);
	}
	
	/** 
	 * @메소드명	: popUpDbMasterManagerSave
	 * @날짜		: 2016. 02. 28. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 납기관리자 팝업창 : 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "popUpDbMasterManagerSave.do")
	public @ResponseBody Map<String, Object> popUpDbMasterManagerSave(CommandMap commandMap) throws Exception {
		return emsDbMasterService.popUpDbMasterManagerSave(commandMap);
	}
}
