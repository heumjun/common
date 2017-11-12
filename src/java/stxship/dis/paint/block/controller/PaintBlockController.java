package stxship.dis.paint.block.controller;

import java.io.File;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.paint.block.service.PaintBlockService;

/**
 * @파일명 : PaintBlockController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Paint Block 컨트롤러
 *     </pre>
 */
@Controller
public class PaintBlockController extends CommonController {
	@Resource(name = "paintBlockService")
	private PaintBlockService paintBlockService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Block 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintBlock.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchPaintBlockAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintBlock.do")
	public @ResponseBody Map<String, Object> searchPaintBlockAction(CommandMap commandMap) {
		return paintBlockService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : popUpBlockCodeAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * AreaCode 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpAreaCode.do")
	public ModelAndView popUpBlockCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoAreaCodeListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 *     AreaCodeList취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoAreaCodeList.do")
	public @ResponseBody Map<String, Object> infoAreaCodeListAction(CommandMap commandMap) {
		return paintBlockService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : savePaintBlockAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Block의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintBlock.do")
	public @ResponseBody Map<String, String> savePaintBlockAction(CommandMap commandMap) throws Exception {
		return paintBlockService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : prBlockExcelImportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block정보를 Excel로 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "blockExcelImport.do")
	public ModelAndView prBlockExcelImportAction(@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		return paintBlockService.blockExcelImport(DecryptFile, commandMap, response);
	}

	/**
	 * @메소드명 : saveExcelPaintPRBlockAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block정보를 Excel로 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveExcelPaintBlock.do")
	public @ResponseBody Map<String, Object> saveExcelPaintPRBlockAction(CommandMap commandMap) throws Exception {
		return paintBlockService.saveExcelPaintBlock(commandMap);
	}

	/**
	 * @메소드명 : blockExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block정보를 Excel로 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "blockExcelExport.do")
	public View blockExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintBlockService.blockExcelExport(commandMap, modelMap);
	}
}
