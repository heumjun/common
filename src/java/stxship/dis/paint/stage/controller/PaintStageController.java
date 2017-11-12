package stxship.dis.paint.stage.controller;

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
import stxship.dis.paint.stage.service.PaintStageService;

/**
 * @파일명 : PaintStageController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Stage 컨트롤러
 *     </pre>
 */
@Controller
public class PaintStageController extends CommonController {
	@Resource(name = "paintStageService")
	private PaintStageService paintStageService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Stage 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintStage.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchPaintStageAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Stage 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintStage.do")
	public @ResponseBody Map<String, Object> searchPaintStageAction(CommandMap commandMap) {
		return paintStageService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : savePaintStageAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Stage정보 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintStage.do")
	public @ResponseBody Map<String, String> savePaintStageAction(CommandMap commandMap) throws Exception {
		return paintStageService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : prBlockExcelImportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 업로드된 엑셀에서 stage 정보 인포트
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stageExcelImport.do")
	public ModelAndView prBlockExcelImportAction(@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		return paintStageService.stageExcelImport(DecryptFile, commandMap, response);
	}

	/**
	 * @메소드명 : saveExcelPaintPRBlockAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀로부터 입력된 Stage정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveExcelPaintStage.do")
	public @ResponseBody Map<String, Object> saveExcelPaintPRBlockAction(CommandMap commandMap) throws Exception {
		return paintStageService.saveExcelPaintStage(commandMap);
	}

	/**
	 * @메소드명 : stageExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Stage정보의 엑셀 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "stageExcelExport.do")
	public View stageExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintStageService.stageExcelExport(commandMap, modelMap);
	}
}
