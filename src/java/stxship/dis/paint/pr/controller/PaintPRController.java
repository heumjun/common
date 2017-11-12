package stxship.dis.paint.pr.controller;

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
import stxship.dis.paint.pr.service.PaintPRService;

/**
 * @파일명 : PaintPRController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 22.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 *  Paint PR 컨트롤러
 * </pre>
 */
@Controller
public class PaintPRController extends CommonController {
	@Resource(name = "paintPRService")
	private PaintPRService paintPRService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint PR화면 이동
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintPR.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : infoPaintPRGroupListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR 그룹 리스트 취득
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoPaintPRGroupList.do")
	public @ResponseBody Map<String, Object> infoPaintPRGroupListAction(CommandMap commandMap) {
		return paintPRService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoBlockStageCodeListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR 블럭 리스트 취득
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoBlockStageCodeList.do")
	public @ResponseBody Map<String, Object> infoBlockStageCodeListAction(CommandMap commandMap) {
		return paintPRService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoGroupItemListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR그룹 아이템 리스트 취득
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoGroupItemList.do")
	public @ResponseBody Map<String, Object> infoGroupItemListAction(CommandMap commandMap) {
		return paintPRService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : infoUnregisteredBlockListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 미적용 Block 리스트 취득
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoUnregisteredBlockList.do")
	public @ResponseBody Map<String, Object> infoUnregisteredBlockListAction(CommandMap commandMap) {
		return paintPRService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : savePaintPRGruopAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR그룹저장
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintPRGruop.do")
	public @ResponseBody Map<String, String> savePaintPRGruopAction(CommandMap commandMap) throws Exception {
		return paintPRService.savePaintPRGruop(commandMap);
	}

	/**
	 * @메소드명 : saveBlockListAction
	 * @날짜 : 2016. 3. 11.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Block 정보 저장
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveBlockList.do")
	public @ResponseBody Map<String, String> saveBlockListAction(CommandMap commandMap) throws Exception {
		return paintPRService.saveBlockList(commandMap);
	}

	/**
	 * @메소드명 : saveCreatePaintPRAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR 생성
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveCreatePaintPR.do")
	public @ResponseBody Map<String, String> saveCreatePaintPRAction(CommandMap commandMap) throws Exception {
		return paintPRService.saveCreatePaintPR(commandMap);
	}

	/**
	 * @메소드명 : prBlockExcelImportAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR Block 엑셀 인포트
	 * </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "prBlockExcelImport.do")
	public ModelAndView prBlockExcelImportAction(@RequestParam("file") CommonsMultipartFile file,
			CommandMap commandMap, HttpServletResponse response) throws Exception {
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		return paintPRService.prBlockExcelImport(DecryptFile, commandMap, response);
	}

	/**
	 * @메소드명 : saveExcelPaintPRBlockAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR block 엑셀로 저장
	 * </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveExcelPaintPRBlock.do")
	public @ResponseBody Map<String, String> saveExcelPaintPRBlockAction(CommandMap commandMap) throws Exception {
		return paintPRService.saveExcelPaintPRBlock(commandMap);
	}

	/**
	 * @메소드명 : prBlockExcelExportAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR Block 엑셀 출력
	 * </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "prBlockExcelExport.do")
	public View prBlockExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintPRService.prBlockExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : popUpExcelUploadAction
	 * @날짜 : 2016. 7. 13.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * PR GROUP ITEM의 EXCEL 업로드 화면 이동
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpExcelUploadPrItem.do")
	public ModelAndView popUpExcelUploadAction(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}

	/**
	 * @메소드명 : prItemExcelImport
	 * @날짜 : 2016. 7. 13.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * EXCEL 내용 로드하여 화면으로 반환
	 * </pre>
	 * @param file
	 * @param commandMap
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "prItemExcelImport.do")
	public void prItemExcelImport(@RequestParam("file") CommonsMultipartFile file,
			CommandMap commandMap, HttpServletResponse response) throws Exception {
		paintPRService.prItemExcelImport(file, commandMap, response);
		
	}

}
