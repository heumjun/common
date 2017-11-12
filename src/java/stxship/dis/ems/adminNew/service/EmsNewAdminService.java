package stxship.dis.ems.adminNew.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsNewAdminService extends CommonService {
	
	public Map<String, Object> selectEmsAdminMainList(CommandMap commandMap) throws Exception;
	
	public String getEmsApprovedBoxDataList(CommandMap commandMap) throws Exception;
	
	public String selectAutoCompleteDwgNoList(CommandMap commandMap) throws Exception;
	
	View popUpAdminPosDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
	
	public Map<String,Object> selectPosChk(CommandMap commandMap) throws Exception;
	
	public Map<String, Object> popUpAdminNewSpecList(HttpServletRequest request, CommandMap commandMap) throws Exception;
	
	public List<Map<String, Object>> popUpAdminSpecDownList(CommandMap commandMap);

	public Map<String, String> popUpEmsAdminNewConfirm(CommandMap commandMap) throws Exception;
}
