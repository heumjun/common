package stxship.dis.paint.cosmetic.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintCosmeticService extends CommonService {

	Map<String, String> saveCosmeticArea(CommandMap commandMap) throws Exception;

	Map<String, String> saveAddCosmetic(CommandMap commandMap) throws Exception;

	Map<String, String> saveMinusCosmetic(CommandMap commandMap) throws Exception;

	View cosmeticExcelExport(CommandMap commandMap, Map<String, Object> modelMap);
}
