package stxship.dis.paint.pe.service;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintPEService extends CommonService {

	ModelAndView peExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception;

	Map<String, Object> saveExcelPaintPE(CommandMap commandMap) throws Exception;

	View peExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}
