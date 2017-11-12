package stxship.dis.bom.bomStatus.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.bom.bomStatus.service.BomStatusService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : BomStatusController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * BOM현황의 컨트롤러
 *     </pre>
 */
@Controller
public class BomStatusController extends CommonController {
	@Resource(name = "bomStatusService")
	private BomStatusService bomStatusService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM현황 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomStatus.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		return mav;
	}

	/**
	 * @메소드명 : popUpSearchItemAction
	 * @날짜 : 2016. 2. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 검색버튼을 선택하였을때 BOM 아이템 검색화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpSearchItem.do")
	public ModelAndView popUpSearchItemAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * @메소드명 : infoSearchItemAction
	 * @날짜 : 2016. 2. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM 아이템 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "infoSearchItem.do")
	public @ResponseBody Map<String, Object> infoSearchItemAction(CommandMap commandMap) throws UnsupportedEncodingException {
		
		//생성자 파라미터 한글깨짐 방지
		commandMap.put("p_emp_no", URLDecoder.decode(commandMap.get("p_emp_no").toString(), "UTF-8"));
		commandMap.put("p_eco_emp_no", URLDecoder.decode(commandMap.get("p_eco_emp_no").toString(), "UTF-8"));
		
		return bomStatusService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : infoBomTreeAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 두가지 리스트를 함께 사용
	 * 1. BOM현황 -> 정전개 -> 좌측 트리구조리스트
	 * 2. BOM현황 -> 정전개 -> 우측 ITEM 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomTree.do")
	public @ResponseBody Map<String, Object> infoBomTreeAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}
	
	/**
	 * @메소드명 : infoBomPaintTreeAction
	 * @날짜 : 2017. 02. 09.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 * paint job 편집 
	 *     <pre>
	 * 두가지 리스트를 함께 사용
	 * 1. BOM현황 -> 정전개 -> 좌측 트리구조리스트
	 * 2. BOM현황 -> 정전개 -> 우측 ITEM 리스트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomPaintTree.do")
	public @ResponseBody Map<String, Object> infoBomPaintTreeAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoBomReverseTreeAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM현황 -> 역전개 ITEM CODE로 역전개 트리구조리스트를 표현
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomReverseTree.do")
	public @ResponseBody Map<String, Object> infoBomReverseTreeAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpDwgNoSearchAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 DWG NO를 검색하기 위한 팝업창이동
	 * 신규추가인경우에만 팝업창이 표현된다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpDwgNoSearch.do")
	public ModelAndView popUpDwgNoSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoDwgNoAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 DWG NO를 검색하기 위한 팝업창-리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoDwgNoSearch.do")
	public @ResponseBody Map<String, Object> infoDwgNoAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpBomItemAttrAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *	 정전개화면의 우측 ITEM 리스트에서 ITEM속성 를 검색하기 위한 팝업창이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpBomItemAttr.do")
	public ModelAndView popUpBomItemAttrAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoBomItemAttrAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 ITEM속성 를 검색하기 위한 팝업창이동 - 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomItemAttr.do")
	public @ResponseBody Map<String, Object> infoBomItemAttrAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpBomAttrAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 BOM속성 를 검색하기 위한 팝업창이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpBomAttr.do")
	public ModelAndView popUpBomAttrAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoBomAttrAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 BOM속성 를 검색하기 위한 팝업창이동 - 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomAttr.do")
	public @ResponseBody Map<String, Object> infoBomAttrAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpBomItemHistoryAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 HISTORY 를 검색하기 위한 팝업창이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpBomItemHistory.do")
	public ModelAndView popUpBomItemHistoryAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoBomItemHistoryAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면의 우측 ITEM 리스트에서 HISTORY 를 검색하기 위한 팝업창이동 - 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomItemHistory.do")
	public @ResponseBody Map<String, Object> infoBomItemHistoryAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpDpsDeptAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면 상단의 DPS부서 검색 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpDpsDept.do")
	public ModelAndView popUpDpsDeptAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoDwgDeptAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면 상단의 DPS부서 검색 팝업창 이동 - 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoDwgDept.do")
	public @ResponseBody Map<String, Object> infoDwgDeptAction(CommandMap commandMap) {
		
		return bomStatusService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpCatalogSearchAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면 우측리스트의 ADD버튼 -> Catalog검색 창이동
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogSearch.do")
	public ModelAndView popUpCatalogSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoItemCatalogCodeAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 정전개화면 우측리스트의 ADD버튼 -> Catalog검색 창이동 - 리스트 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemCatalogCode.do")
	public @ResponseBody Map<String, Object> infoItemCatalogCodeAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveBomJobItemAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 채번 및 BOM 생성 버튼을 선택했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveBomJobItem.do")
	public @ResponseBody Map<String, String> saveBomJobItemAction(CommandMap commandMap) throws Exception {
		return bomStatusService.saveBomJobItem(commandMap);
	}

	/**
	 * @메소드명 : saveJobItemAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 저장 버튼을 클릭했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveJobItem.do")
	public @ResponseBody Map<String, String> saveJobItemAction(CommandMap commandMap) throws Exception {
		return bomStatusService.saveJobItem(commandMap);
	}

	/**
	 * @메소드명 : selectJobTypeAction
	 * @날짜 : 2015. 12. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 시스템 내부적으로 JOP TYPE 를 받아두는 처리
	 * 취득후 JOP TYPE는 채번 및 BOM생성에서 사용된다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectJobType.do")
	public @ResponseBody Map<String, Object> selectJobTypeAction(CommandMap commandMap) throws Exception {
		return bomStatusService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : addSpecificStructure
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수구조 추가버튼을 선택했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "addSpecificStructure.do")
	public @ResponseBody Map<String, String> addSpecificStructure(CommandMap commandMap) throws Exception {
		return bomStatusService.addSpecificStructure(commandMap);
	}

	/**
	 * @메소드명 : saveDwgEcoCreateAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ECO 버튼을 선택했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveDwgEcoCreate.do")
	public @ResponseBody Map<String, String> saveDwgEcoCreateAction(CommandMap commandMap) throws Exception {
		return bomStatusService.saveDwgEcoCreate(commandMap);
	}

	/**
	 * @메소드명 : popUpItemDetail
	 * @날짜 : 2016. 1. 13.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM ITEM 상세화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpBomItemDetail.do")
	public ModelAndView popUpItemDetail(CommandMap commandMap) {
		return new ModelAndView(DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
	}

	/**
	 * @메소드명 : infoItemDetail
	 * @날짜 : 2016. 1. 13.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM ITEM 상세정보취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoBomItemDetail.do")
	public @ResponseBody Map<String, Object> infoItemDetail(CommandMap commandMap) throws Exception {
		return bomStatusService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : infoBomAttListAction
	 * @날짜 : 2016. 2. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM ITEM 의 Catalog정보 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBomAttList.do")
	public @ResponseBody Map<String, Object> infoBomAttListAction(CommandMap commandMap) {
		
		return bomStatusService.getGridListNoPaging(commandMap);
	}

}
