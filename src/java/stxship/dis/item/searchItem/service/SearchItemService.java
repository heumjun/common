package stxship.dis.item.searchItem.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface SearchItemService extends CommonService {

	View searchItemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;

	Map<String, Object> searchItemList(CommandMap commandMap) throws Exception;
	
	public String searchItemDwgPopupViewList(CommandMap commandMap) throws Exception;
}
