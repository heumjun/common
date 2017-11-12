package stxship.dis.paint.pattern.service;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintPatternService extends CommonService{

	ModelAndView searchPaintSeasonCodeList(CommandMap commandMap);

	Map<String, String> savePaintPattern(CommandMap commandMap) throws Exception;

	Map<String, String> deletePatternList(CommandMap commandMap) throws Exception;

	Map<String, String> savePatternConfirm(CommandMap commandMap) throws Exception;

	Map<String, String> savePatternUndefine(CommandMap commandMap) throws Exception;

	View patternExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	
	
}
