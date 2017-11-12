package stxship.dis.paint.pe.controller;

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
import stxship.dis.common.controller.CommonController;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.paint.pe.service.PaintPEService;

/**
 * @파일명 : PaintPEController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint PE 컨트롤러
 *     </pre>
 */
@Controller
public class PaintPEController extends CommonController {
	@Resource(name = "paintPEService")
	private PaintPEService paintPEService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint PE 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPE.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchPaintPEAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintPE.do")
	public @ResponseBody Map<String, Object> searchPaintPEAction(CommandMap commandMap) {
		return paintPEService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : selectPEBlockCodeListtAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintBlockList.do")
	public @ResponseBody Map<String, Object> selectPEBlockCodeListtAction(CommandMap commandMap) {
		return paintPEService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveOutfittingAreaAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE 정보 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintPE.do")
	public @ResponseBody Map<String, String> saveOutfittingAreaAction(CommandMap commandMap) throws Exception {
		return paintPEService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : peExcelImportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE정보 엑셀 정보의 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "peExcelImport.do")
	public ModelAndView peExcelImportAction(@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		return paintPEService.peExcelImport(DecryptFile, commandMap, response);
	}

	/**
	 * @메소드명 : saveExcelPaintPEAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE정보 엑셀에서 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveExcelPaintPE.do")
	public @ResponseBody Map<String, Object> saveExcelPaintPEAction(CommandMap commandMap) throws Exception {
		return paintPEService.saveExcelPaintPE(commandMap);
	}

	/**
	 * @메소드명 : peExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PE정보의 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "peExcelExport.do")
	public View peExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintPEService.peExcelExport(commandMap, modelMap);
	}

}
