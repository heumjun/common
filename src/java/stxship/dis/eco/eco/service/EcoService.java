package stxship.dis.eco.eco.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EcoService extends CommonService {

	View ecoExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, String> saveEco(CommandMap commandMap) throws Exception;
	
	Map<String, String> saveEco1(CommandMap commandMap) throws Exception;

	Map<String, String> promoteDemote(CommandMap commandMap) throws Exception;

	Map<String, String> saveEcrResult(CommandMap commandMap) throws Exception;

	Map<String, String> saveReleaseNotificationResults(CommandMap commandMap) throws Exception;
	
	Map<String, String> saveEcoReleaseNotificationGroup(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> ecoRegisterInfo(CommandMap commandMap) throws Exception;

	Map<String, String> delEcoReleaseNotificationGroup(CommandMap commandMap) throws Exception;
}
