package stxship.dis.ecr.ecr.service;

import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EcrService extends CommonService {
	
	public Map<String, Object> saveEcr(CommandMap commandMap) throws Exception;
	
	View ecrExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	public Map<String, Object> saveEcrPromoteDemote(CommandMap commandMap) throws Exception;
	
	public Map<String, String> saveEcrToEcoRelated(CommandMap commandMap) throws Exception;

	public Map<String, Object> deleteRelatedECOs(CommandMap commandMap) throws Exception;
}
