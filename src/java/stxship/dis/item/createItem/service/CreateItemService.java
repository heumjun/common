package stxship.dis.item.createItem.service;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.View;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface CreateItemService extends CommonService {
	Map<String, Object> saveItemNextAction(CommandMap commandMap) throws Exception;
	
	Map<String, Object> saveItemCreate(CommandMap commandMap) throws Exception;

	View itemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	void itemExcelImport(CommandMap commandMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception;

	String selectTempCatalogItemExist(CommandMap commandMap) throws Exception;

	Map<String, Object> selectItemCatalogAttribute(CommandMap commandMap);

	Map<String, Object> selectItemAllCatalog(CommandMap commandMap);

	String itemAttributeCheck(CommandMap commandMap) throws Exception;

	Map<String, Object> itemCloneAction(CommandMap commandMap) throws Exception;

	Map<String, Object> itemAttributeDelete(CommandMap commandMap) throws Exception;

}
