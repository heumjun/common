package stxship.dis.item.itemInterface.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface ItemInterfaceService extends CommonService {
	Map<String, String> saveItemToErp(CommandMap commandMap) throws Exception;
}
