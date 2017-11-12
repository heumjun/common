package stxship.dis.ems.partList.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsPartListService extends CommonService {

	public Map<String, Object> emsPartListMainList(CommandMap commandMap) throws Exception ;
	
	public View emsPartListExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	public Map<String, Object> emsPartListSaveAction(CommandMap commandMap) throws Exception ;
	
	public List<Map<String, Object>> emsPartListJobList(CommandMap commandMap);
	
	public Map<String, Object> emsPartListSelectOne(CommandMap commandMap) ;
	
	public List<Map<String, Object>> emsPartListBomDetail(CommandMap commandMap);
	
	public Map<String, Object> emsPartListProjectCopyNextList(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> emsPartListProjectCopySave(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> emsPartListImportAction(CommandMap commandMap) throws Exception;
}

