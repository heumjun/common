package stxship.dis.paint.projectCopy.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintProjectCopyService extends CommonService {

	Map<String, String> saveProjectCopyConfirm(CommandMap commandMap) throws Exception;
}
