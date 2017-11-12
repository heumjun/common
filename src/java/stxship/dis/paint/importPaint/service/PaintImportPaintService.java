package stxship.dis.paint.importPaint.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintImportPaintService extends CommonService {

	Map<String, Object> selectPaintEco(CommandMap commandMap);

	List<Map<String, Object>> selectSeriesProjectNo(CommandMap commandMap);

	Map<String, Object> savePaintRelease(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> paintSelectEcoAddStateList(CommandMap commandMap);

	Map<String, String> savePaintImportCreateBom(CommandMap commandMap) throws Exception;

	View paintImportExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, Object> paintAdminCheck(CommandMap commandMap) throws Exception;;
}
