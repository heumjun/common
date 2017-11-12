package stxship.dis.baseInfo.pdUpperStructureMgnt.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.pdUpperStructureMgnt.service.PdUpperStructureMgntService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : PdUpperStructureMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * PdUpperStructureMgnt의 컨트롤러
 *     </pre>
 */
@Controller
public class PdUpperStructureMgntController extends CommonController {
	@Resource(name = "pdUpperStructureMgntService")
	private PdUpperStructureMgntService pdUpperStructureMgntService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatagoryType 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "pdUpperStructureMgnt.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "popUpPdCatalogSearch.do")
	public ModelAndView popUpCatalogSearchAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	@RequestMapping(value = "infoCatalogSearch.do")
	public @ResponseBody Map<String, Object> infoCatalogSearchAction(CommandMap commandMap) {
		return pdUpperStructureMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatagoryType 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPdUpperStructureMgntList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return pdUpperStructureMgntService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * CatagoryType 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePdUpperStructureMgntList.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return pdUpperStructureMgntService.savePdUpperStructureMgntList(commandMap);
	}
}
