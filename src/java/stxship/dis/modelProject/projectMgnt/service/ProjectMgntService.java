package stxship.dis.modelProject.projectMgnt.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface ProjectMgntService extends CommonService {

	// 변경된 그리드 정보를 가져와서 데이타베이스에 반영한다.
	Map<String, String> saveGridListAction(CommandMap commandMap) throws Exception;
}
