package stxship.dis.baseInfo.updateItemsAttr.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.baseInfo.updateItemsAttr.service.UpdateItemsAttrService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : UpdateItemsAttrController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * Update Item Attr 메뉴가 선택되었을때 사용되는 컨트롤러
 *     </pre>
 */
@Controller
public class UpdateItemsAttrController extends CommonController {
	@Resource(name = "updateItemsAttrService")
	private UpdateItemsAttrService updateItemsAttrService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Update Item Attr 화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "updateItemAttribute.do")
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
	 * Update Item Attr 정보 리스트 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "updateItemAttributeList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		return updateItemsAttrService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Update Item Attr 정보의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveUpdateItemAttribute.do")
	public @ResponseBody Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception {
		return updateItemsAttrService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : updatePlmErpDB
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PLM ERP DB를 업데이트 한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "updatePlmErpDB.do")
	public @ResponseBody Map<String, String> updatePlmErpDB(CommandMap commandMap) throws Exception {
		return updateItemsAttrService.updatePlmErpDBcommandMap(commandMap);
	}

	/**
	 * @메소드명 : itemAttributeExcelImport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀의 내용을 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "itemAttributeExcelImport.do")
	public void itemAttributeExcelImport(@RequestParam("fileName") CommonsMultipartFile file,
			HttpServletResponse response, CommandMap commandMap) throws Exception {
		
		updateItemsAttrService.itemAttributeExcelImport(file, response, commandMap);
		
	}

}
