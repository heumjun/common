package stxship.dis.paint.paintAreaList.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintAreaListService  extends CommonService {

	View paintAreaListExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}
