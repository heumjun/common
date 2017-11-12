package stxship.dis.paint.loss.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintLossService extends CommonService {

	Map<String, String> savePaintLoss(CommandMap commandMap) throws Exception;

	View lossExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
