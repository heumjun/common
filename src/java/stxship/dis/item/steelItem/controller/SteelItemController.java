package stxship.dis.item.steelItem.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.item.steelItem.service.SteelItemService;

/**
 * @파일명 : SteelItemController.java
 * @프로젝트 : DIS
 * @날짜 : 2017. 1. 17.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * 강재 ITEM 생성의 컨트롤러
 *     </pre>
 */
@Controller
public class SteelItemController extends CommonController {
	@Resource(name = "steelItemService")
	private SteelItemService steelItemService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2017. 1. 17.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM현황 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "steelItem.do")
	public ModelAndView steelItem(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		return mav;
	}

	/**
	 * @메소드명 : steelItemList
	 * @날짜 : 2017. 1. 17.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * steelItemList
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "steelItemList.do")
	public @ResponseBody Map<String, Object> steelItemList(CommandMap commandMap) {		
		return steelItemService.getSteelItemList(commandMap);
	}	
	
	/**
	 * @메소드명 : saveSteelItem
	 * @날짜 : 2017. 1. 17.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * SteelItem 아이템 채번
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveSteelItem.do")
	public @ResponseBody Map<String, Object> saveSteelItem(CommandMap commandMap) throws Exception {
		return steelItemService.saveSteelItem(commandMap);
	}

}
