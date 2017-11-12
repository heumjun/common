package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.ItemDescChangeService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : ItemDescChangeController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 1.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Text Filter가 선택되어졌을대 사용되는 액션
 *     </pre>
 */
@Controller
public class ItemDescChangeController extends CommonController {

	@Resource(name = "itemDescChangeService")
	private ItemDescChangeService itemDescChangeService;

	/**
	 * @메소드명 : popUpCatalogItemDescChangeAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Text Filter 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogItemDescChange.do")
	public ModelAndView popUpCatalogItemDescChangeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoCatalogAttributeNameAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Item 속성 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCatalogAttributeName.do")
	public @ResponseBody Map<String, Object> infoCatalogAttributeNameAction(CommandMap commandMap) {
		return itemDescChangeService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoCommonAttributeNameAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 코드 Item 속성 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCommonAttributeName.do")
	public @ResponseBody Map<String, Object> infoCommonAttributeNameAction(CommandMap commandMap) {
		return itemDescChangeService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoCatalogAttributeNameList
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Item 속성 정보 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoCatalogAttributeNameList.do")
	public @ResponseBody Map<String, Object> infoCatalogAttributeNameList(CommandMap commandMap) {
		return itemDescChangeService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveCatalogAttributeName
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통Item 속성 일괄반영을 클릭하였을때 실행 >> 버튼
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCommonAttributeName.do")
	public @ResponseBody Map<String, String> saveCatalogAttributeName(CommandMap commandMap) throws Exception {
		return itemDescChangeService.saveCommonAttributeName(commandMap);
	}

	/**
	 * @메소드명 : saveChangeCatalogItemAttr
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Catalog Item 속성 일괄반영을 저장하였을때 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveChangeCatalogItemAttr.do")
	public @ResponseBody Map<String, String> saveChangeCatalogItemAttr(CommandMap commandMap) throws Exception {
		return itemDescChangeService.saveChangeCatalogItemAttr(commandMap);
	}
}
