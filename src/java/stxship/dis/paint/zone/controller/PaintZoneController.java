package stxship.dis.paint.zone.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.paint.zone.service.PaintZoneService;

/**
 * @파일명 : PaintZoneController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * Zone의 컨트롤러
 *     </pre>
 */
@Controller
public class PaintZoneController extends CommonController {
	@Resource(name = "paintZoneService")
	private PaintZoneService paintZoneService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Paint Zone 으로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintZone.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchPaintZoneAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "searchPaintZone.do")
	public @ResponseBody Map<String, Object> searchPaintZoneAction(CommandMap commandMap) {
		return paintZoneService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : selectZoneAreaCodeListAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone의 AreaCode리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "selectZoneAreaCodeList.do")
	public @ResponseBody Map<String, Object> selectZoneAreaCodeListAction(CommandMap commandMap) {
		return paintZoneService.getGridListNoPaging(commandMap);
	}

	/**
	 * @메소드명 : saveOutfittingAreaAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone 정보의 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	/*
	@RequestMapping(value = "savePaintZone.do")
	public @ResponseBody Map<String, String> saveOutfittingAreaAction(CommandMap commandMap) throws Exception {
		return paintZoneService.saveGridList(commandMap);
	}
	*/
	
	@RequestMapping(value = "savePaintZone.do")
	public @ResponseBody Map<String, String> savePaintPatternAction(CommandMap commandMap) throws Exception {		
		return paintZoneService.savePaintZone(commandMap);
		
	}	
	
	/**
	 * @메소드명 : checkExistPaintZoneAction
	 * @날짜 : 2016. 03. 10.
	 * @작성자 : 강선중
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone - Group 일괄적용 시 입력된 Zone가 유효한지 체크
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */	
	@RequestMapping(value = "checkExistPaintZone.do")
	public @ResponseBody Map<String, Object> checkExistPaintZoneAction(CommandMap commandMap) throws Exception {		
		return paintZoneService.checkExistPaintZone(commandMap);		
	}	

	/**
	 * @메소드명 : zoneExcelExportAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Zone의 엑셀 출력
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "zoneExcelExport.do")
	public View zoneExcelExportAction(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintZoneService.zoneExcelExport(commandMap, modelMap);
	}
}
