package stxship.dis.paint.importPaint.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.importPaint.service.PaintImportPaintService;

/**
 * @파일명 : PaintImportPaintController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 22.
 * @작성자 : 강선중
 * @설명
 * 
 * 	<pre>
 * Paint Import Paint 컨트롤러
 *     </pre>
 */
@Controller
public class PaintImportPaintController extends CommonController {
	@Resource(name = "paintImportPaintService")
	private PaintImportPaintService paintImportPaintService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Import Paint 모듈로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintImportPaint.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : selectPaintImportPaintListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Import Paint 조회
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectPaintImportPaintList.do")
	public @ResponseBody Map<String, Object> selectPaintImportPaintListAction(CommandMap commandMap) {
		return paintImportPaintService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : selectPaintEcoAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Type 별(Block/Pre PE/PE/Hull/Quay/Outfitting/Cosmetic) Create BOM 작업을 수행했던 ECO NO 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "selectPaintEco.do")
	public @ResponseBody Map<String, Object> selectPaintEcoAction(CommandMap commandMap) throws Exception {
		return paintImportPaintService.selectPaintEco(commandMap);

	}

	/**
	 * @메소드명 : selectSeriesProjectNoAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Plan 호선의 시리즈 호선 정보 추출
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectSeriesProjectNo.do")
	public @ResponseBody List<Map<String, Object>> selectSeriesProjectNoAction(CommandMap commandMap) {
		List<Map<String, Object>> result = paintImportPaintService.selectSeriesProjectNo(commandMap);
		return result;
	}

	/**
	 * @메소드명 : savePaintReleaseAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 *     Release
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintRelease.do")
	public @ResponseBody Map<String, Object> savePaintReleaseAction(CommandMap commandMap) throws Exception {
		return paintImportPaintService.savePaintRelease(commandMap);

	}

	/**
	 * @메소드명 : paintSelectEcoAddStateListAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Import Paint - Create BOM 시에 ECO NO 존재 여부 체크
	 * bom.xml의 selectEcoAddStateList을 공용으로 사용중이나.. 일단 따로 추가.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "paintSelectEcoAddStateList.do")
	public @ResponseBody List<Map<String, Object>> paintSelectEcoAddStateListAction(CommandMap commandMap)
			throws Exception {
		List<Map<String, Object>> result = paintImportPaintService.paintSelectEcoAddStateList(commandMap);
		return result;
	}

	/**
	 * @메소드명 : savePaintImportCreateBomAction
	 * @날짜 : 2015. 12. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Import - Create BOM. Paint Bom(USC, SSC)을 생성한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintImportCreateBom.do")
	public @ResponseBody Map<String, String> savePaintImportCreateBomAction(CommandMap commandMap) throws Exception {
		return paintImportPaintService.savePaintImportCreateBom(commandMap);

	}

	/**
	 * @메소드명 : paintImportExcelExportAction
	 * @날짜 : 2016. 1. 22.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Import - Excel 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "paintImportExcelExport.do")
	public View paintImportExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) {
		return paintImportPaintService.paintImportExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : paintAdminCheckAction
	 * @날짜 : 2017. 3. 22.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Import - Paint 관리자 체크. (강제 Release 버튼 활성화)
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "paintAdminCheck.do")
	public @ResponseBody Map<String, Object> paintAdminCheckAction(CommandMap commandMap) throws Exception {
		return paintImportPaintService.paintAdminCheck(commandMap);

	}	
}
