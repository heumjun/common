package stxship.dis.paint.area.controller;

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
import stxship.dis.paint.area.service.PaintAreaService;

/**
 * @파일명 : PaintAreaController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 30.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  Paint Area 컨트롤러
 *     </pre>
 */
@Controller
public class PaintAreaController extends CommonController {
	/**
	 * PaintArea 서비스
	 */
	@Resource(name = "paintAreaService")
	private PaintAreaService paintAreaService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.PaintArea 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintArea.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : paintAreaListAction
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 * 
	 *     <pre>
	 * PaintArea 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "paintAreaList.do")
	public @ResponseBody Map<String, Object> paintAreaListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return paintAreaService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : savePaintAreaAction
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	변경된 그리드 정보를 가져와서 데이타베이스에 반영한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "savePaintArea.do")
	public @ResponseBody Map<String, String> savePaintAreaAction(CommandMap commandMap) throws Exception {
		return paintAreaService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : paintAreaExcelImportAction
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드를 실행
	 * 
	 *     </pre>
	 * 
	 * @param file
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "areaExcelImport.do")
	public ModelAndView areaExcelImportAction(@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile(file);
		
		return paintAreaService.areaExcelImport(DecryptFile, commandMap, response);
	}

	/**
	 * @메소드명 : paintAreaExcelExport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 * 
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "paintAreaExcelExport.do")
	public View paintAreaExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return paintAreaService.paintAreaExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : saveExcelPaintAreaAction
	 * @날짜 : 2015. 12. 30.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * Excel로 Paint Area정보를 저장
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveExcelPaintArea.do")
	public @ResponseBody Map<String, Object> saveExcelPaintAreaAction(CommandMap commandMap) throws Exception {
		return paintAreaService.saveExcelPaintArea(commandMap);
	}

	/**
	 * @메소드명 : popUpLossCodeAction
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LOSE CODE 취득 팝업
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpLossCode.do")
	public ModelAndView popUpLossCodeAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.PAINT + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoLossCodeListAction
	 * @날짜 : 2016. 3. 8.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * LOSE CODE 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "infoLossCodeList.do")
	public @ResponseBody Map<String, Object> infoLossCodeListAction(CommandMap commandMap) {
		return paintAreaService.getGridListNoPaging(commandMap);
	}
}
