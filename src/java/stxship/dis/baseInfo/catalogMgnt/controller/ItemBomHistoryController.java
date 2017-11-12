package stxship.dis.baseInfo.catalogMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.catalogMgnt.service.CatalogMgntService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : ItemBomHistoryController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 1.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Item/Bom History가 선택되어졌을때 사용되는 액션
 *     </pre>
 */
@Controller
public class ItemBomHistoryController extends CommonController {

	/** CatalogMgnt 서비스정의 */
	@Resource(name = "catalogMgntService")
	private CatalogMgntService catalogMgntService;

	/**
	 * @메소드명 : popUpItemBomHistoryAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Item/Bom History 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemBomHistory.do")
	public ModelAndView popUpItemBomHistoryAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoItemBomHistoryAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Item/Bom History 정보 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoItemBomHistory.do")
	public @ResponseBody Map<String, Object> infoItemBomHistoryAction(CommandMap commandMap) {
		return catalogMgntService.getGridListNoPaging(commandMap);
	}
}
