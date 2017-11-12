package stxship.dis.paint.common.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintCommonService extends CommonService{

	Map<String, Object> paintPlanProjectNoCheck(CommandMap commandMap);

	Map<String, Object> selectPaintNewRuleFlag(CommandMap commandMap) throws Exception;
}
