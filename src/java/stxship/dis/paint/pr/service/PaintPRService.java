package stxship.dis.paint.pr.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintPRService extends CommonService {

	Map<String, String> savePaintPRGruop(CommandMap commandMap) throws Exception;

	Map<String, String> saveCreatePaintPR(CommandMap commandMap) throws Exception;

	ModelAndView prBlockExcelImport(File file, CommandMap commandMap, HttpServletResponse response)
			throws Exception;

	Map<String, String> saveExcelPaintPRBlock(CommandMap commandMap) throws Exception;

	View prBlockExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	Map<String, String> saveBlockList(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> prItemExcelImport(CommonsMultipartFile file, CommandMap commandMap, HttpServletResponse response) throws Exception;
}
