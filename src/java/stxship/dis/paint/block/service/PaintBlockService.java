package stxship.dis.paint.block.service;

import java.io.File;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintBlockService extends CommonService {

	ModelAndView blockExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception;

	Map<String, Object> saveExcelPaintBlock(CommandMap commandMap) throws Exception;

	View blockExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}
