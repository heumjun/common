package stxship.dis.supplyPlan.supplyChart.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface SupplyChartService extends CommonService{

	Map<String, Object> supplyChartSaveAction(CommandMap commandMap) throws Exception;

	public Map<String, Object> supplyChartList(CommandMap commandMap) throws Exception;

}
