package stxship.dis.bom.bomStatus.controller;

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
 * @파일명 : ManageSpecificStructureController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 11.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  특수구조관리 컨트롤러
 *     </pre>
 */
@Controller
public class ManageSpecificStructureController extends CommonController {
	@Resource(name = "bomStatusService")
	private BomStatusService bomStatusService;

	/**
	 * @메소드명 : popUpManageSpecificStructureAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수 구조관리 화면으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpManageSpecificStructure.do")
	public ModelAndView popUpManageSpecificStructureAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/popUp" + commandMap.get(DisConstants.JSP_NAME));
		// shipType 리스트를 가져온다.
		mav.addObject("spstShipTypeList", bomStatusService.getSpstShipTypeList(commandMap));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoManageSpecificStructureAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수구조관리 리스트를 취득하는 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoManageSpecificStructure.do")
	public @ResponseBody Map<String, Object> infoManageSpecificStructureAction(CommandMap commandMap) {
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpMotherCatalogSearchAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부모 CatalogCode를 조회하는 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpMotherCatalogSearch.do")
	public ModelAndView popUpMotherCatalogSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView("bom/popUp" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoMotherCatalogCodeAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 부모 CatalogCode를 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoMotherCatalogCode.do")
	public @ResponseBody Map<String, Object> infoMotherCatalogCodeAction(CommandMap commandMap) {
		return bomStatusService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : popUpItemCatalogSearchAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ItemCatalog를 조회하는 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemCatalogSearch.do")
	public ModelAndView popUpItemCatalogSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : deleteSpstSubItemAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수구조 관리에서 삭제를 선택했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "deleteSpstSubItem.do")
	public @ResponseBody Map<String, String> deleteSpstSubItemAction(CommandMap commandMap) throws Exception {
		return bomStatusService.deleteSpstSubItem(commandMap);
	}

	/**
	 * @메소드명 : saveWbsSubItemAction
	 * @날짜 : 2015. 12. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 특수 구조 관리에서 저장을 선택했을때의 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSpstSubBom.do")
	public @ResponseBody Map<String, String> saveWbsSubItemAction(CommandMap commandMap) throws Exception {
		return bomStatusService.saveSpstSubBom(commandMap);
	}

}
