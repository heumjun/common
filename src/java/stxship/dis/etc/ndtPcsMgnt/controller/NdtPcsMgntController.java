package stxship.dis.etc.ndtPcsMgnt.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.etc.ndtPcsMgnt.service.NdtPcsMgntService;

/**
 * @파일명 : NdtPcsMgntController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * NdtPcsMgnt의 컨트롤러
 *     </pre>
 */
@Controller
public class NdtPcsMgntController extends CommonController {
	@Resource(name = "ndtPcsMgntService")
	private NdtPcsMgntService ndtPcsMgntService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * NdtPcsMgnt 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "ndtPcsMgnt.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	@RequestMapping(value = "ndtPcsList.do")
	public @ResponseBody Map<String, Object> ndtPcsListAction(CommandMap commandMap) {
		return ndtPcsMgntService.getGridList(commandMap);
	}
	
	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * NdtPcsMgnt  저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveNdtPcsMgnt.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return ndtPcsMgntService.saveGridList(commandMap);
	}
	
	@RequestMapping(value = "selectDWGDPGroupList.do")
	public @ResponseBody List<Map<String, Object>> selectDWGDPGroupListAction(CommandMap commandMap) {
		return ndtPcsMgntService.getDbDataList(commandMap);
	}
	
}
