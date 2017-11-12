package stxship.dis.paint.area.service;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintAreaService extends CommonService {

	ModelAndView areaExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception;

	/**
	 * @메소드명 : paintAreaExcelExport
	 * @날짜 : 2015. 12. 14.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력을 실행
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	View paintAreaExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	Map<String, Object> saveExcelPaintArea(CommandMap commandMap) throws Exception;

}
