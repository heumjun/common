package stxship.dis.baseInfo.catalogCodeLength.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.catalogCodeLength.service.CatalogCodeLengthService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : CatalogCodeLengthController.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 12. 6.
 * @작성자 : 황성준
 * @설명
 * 
 * 	<pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class CatalogCodeLengthController extends CommonController {
	@Resource(name = "catalogCodeLengthService")
	private CatalogCodeLengthService catalogCodeLengthService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2016. 12. 6.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogCodeLength 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogCodeLength.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2016. 12. 6.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogCodeLength  리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "catalogCodeLengthList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return catalogCodeLengthService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2016. 12. 6.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * CatalogCodeLength  저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCatalogCodeLength.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return catalogCodeLengthService.saveGridList(commandMap);
	}
	
	/**
	 * @메소드명 : catalogCodeLengthExcelExport
	 * @날짜 : 2016. 12. 6.
	 * @작성자 : 황성준
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "catalogCodeLengthExcelExport.do")
	public View catalogCodeLengthExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return catalogCodeLengthService.excelExport(commandMap, modelMap);
	}
}
