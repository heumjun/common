package stxship.dis.system.role.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface RoleByUserService extends CommonService {

	Map<String, String> roleCopy(CommandMap commandMap) throws Exception;
}
