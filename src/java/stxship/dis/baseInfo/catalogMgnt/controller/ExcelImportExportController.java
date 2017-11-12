package stxship.dis.baseInfo.catalogMgnt.controller;

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

import stxship.dis.baseInfo.catalogMgnt.service.ExcelImportExportService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

/**
 * @파일명 : ExcelImportExportController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 1.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 *  엑셀 인포트,익스포트가 선택되어졌을때 사용되는 액션
 *     </pre>
 */
@Controller
public class ExcelImportExportController extends CommonController {

	@Resource(name = "excelImportExportService")
	private ExcelImportExportService excelImportExportService;

	/**
	 * @메소드명 : popUpCatalogExcelUploadAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드 팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpCatalogExcelUpload.do")
	public ModelAndView popUpCatalogExcelUploadAction(CommandMap commandMap) {
		ModelAndView mav = new ModelAndView(
				DisConstants.BASEINFO + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoCatalogAttrExistAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 업로드시에 업로드된 Catalog속성이 있는지를 확인
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoCatalogAttrExist.do")
	public @ResponseBody String infoCatalogAttrExistAction(CommandMap commandMap) throws Exception {
		return excelImportExportService.catalogAttrExist(commandMap);
	}

	/**
	 * @메소드명 : catalogExcelImportAction
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
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
	@RequestMapping(value = "catalogExcelImport.do")
	public void catalogExcelImportAction(@RequestParam("file") CommonsMultipartFile file, CommandMap commandMap,
			HttpServletResponse response) throws Exception {
		excelImportExportService.catalogExcelImport(file, commandMap, response);
	}

	/**
	 * @메소드명 : catalogExcelExport
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
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
	@RequestMapping(value = "catalogExcelExport.do")
	public View catalogExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return excelImportExportService.catalogExcelExport(commandMap, modelMap);
	}

}
