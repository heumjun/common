package stxship.dis.paint.zone.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintZoneService extends CommonService {

	View zoneExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, String> savePaintZone(CommandMap commandMap) throws Exception;

	Map<String, Object> checkExistPaintZone(CommandMap commandMap) throws Exception;
}
