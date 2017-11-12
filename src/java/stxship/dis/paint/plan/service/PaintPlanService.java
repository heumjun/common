package stxship.dis.paint.plan.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintPlanService extends CommonService{

	Map<String, String> savePlanRevAdd(CommandMap commandMap) throws Exception;

	Map<String, String> savePlanProjectAdd(CommandMap commandMap) throws Exception;

}
