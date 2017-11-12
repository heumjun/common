package stxship.dis.bom.bom.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface BomService extends CommonService {
	View bomExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
