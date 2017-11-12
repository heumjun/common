package stxship.dis.baseInfo.purchasingGroupCode.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.baseInfo.purchasingGroupCode.service.PurchasingGroupCodeService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : PurchasingGroupCodeController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * CatelogType의 컨트롤러
 *     </pre>
 */
@Controller
public class PurchasingGroupCodeController extends CommonController {
	@Resource(name = "purchasingGroupCodeService")
	private PurchasingGroupCodeService purchasingGroupCodeService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PurchasingGroupCode 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "purchasingGroupCode.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PurchasingGroupCode  리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "purchasingGroupCodeList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return purchasingGroupCodeService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PurchasingGroupCode  저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePurchasingGroupCode.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return purchasingGroupCodeService.saveGridList(commandMap);
	}
	
	/**
	 * @메소드명 : purchasingGroupCodeExcelExport
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
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
	@RequestMapping(value = "purchasingGroupCodeExcelExport.do")
	public View purchasingGroupCodeExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return purchasingGroupCodeService.excelExport(commandMap, modelMap);
	}
}
