package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.AddItemAttrService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : AddItemAttrController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 1.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatalogMgnt의 부가속성이 선택되었을때 사용되는 액션
 *     </pre>
 */
@Controller
public class AddItemAttrController extends CommonController {

	/** CatalogMgnt 서비스정의 */
	@Resource(name = "addItemAttrService")
	private AddItemAttrService addItemAttrService;

	/**
	 * @메소드명 : popUpCatalogAddItemAttrAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 부가속성 팝업 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogAddItemAttr.do")
	public ModelAndView popUpCatalogAddItemAttrAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoItemAddAttributeAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 부가속성 정보 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemAddAttribute.do")
	public @ResponseBody Map<String, Object> infoItemAddAttributeAction(CommandMap commandMap) {
		return addItemAttrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoItemAddValueAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 부가속성 Item Value정보를 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemAddValue.do")
	public @ResponseBody Map<String, Object> infoItemAddValueAction(CommandMap commandMap) {
		return addItemAttrService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveItemAddAttributeAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogMgnt 부가속성을 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveItemAddAttribute.do")
	public @ResponseBody Map<String, String> saveItemAddAttributeAction(CommandMap commandMap) throws Exception {
		return addItemAttrService.saveItemAddAttribute(commandMap);
	}
}
