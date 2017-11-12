package stxship.dis.paint.quantity.service;


import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintQuantityService extends CommonService {

	Map<String, String> savePaintQuantity(CommandMap commandMap) throws Exception;

	Map<String, String> undefinePaintQuantity(CommandMap commandMap) throws Exception;

	View allQuantityExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, String> savePaintQuantityTransfer(CommandMap commandMap) throws Exception;

	Map<String, String> savePaintQuantityAutoTransfer(CommandMap commandMap)throws Exception;
}
