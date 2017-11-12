package stxship.dis.wps.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * 
 * @파일명		: WpsService.java 
 * @프로젝트	: DIMS
 * @날짜		: 2017. 10. 11. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 
 * </pre>
 */
public interface WpsService extends CommonService {

	String wpsCodeTypeSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> wpsCodeTypeSelectBoxGridList(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsCodeManageList(CommandMap commandMap) throws Exception;
	
	Map<String, Object> saveWpsCodeManage(CommandMap commandMap) throws Exception;

	String wpsPlateTypeSelectBoxDataList(CommandMap commandMap) throws Exception;

	String wpsProcessTypeSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	String wpsTypeSelectBoxDataList(CommandMap commandMap) throws Exception;
	
	Map<String, Object> wpsManageList(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsPositionCodeList(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsApprovalCodeList(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsMetalCodeList(CommandMap commandMap) throws Exception;

	List<Map<String, Object>> wpsProcessTypeSelectBoxGridList(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> wpsTypeSelectBoxGridList(CommandMap commandMap) throws Exception;
	
	List<Map<String, Object>> wpsPlateTypeSelectBoxGridList(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsFileUpLoad(CommandMap commandMap, HttpServletRequest request) throws Exception;

	Map<String, Object> wpsManageSaveAction(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsConfirmList(CommandMap commandMap) throws Exception;

	String wpsApprovalClassTypeSelectBoxDataList(CommandMap commandMap) throws Exception;

	String wpsPositionTypeSelectBoxDataList(CommandMap commandMap) throws Exception;

	String wpsBaseMetalTypeSelectBoxDataList(CommandMap commandMap) throws Exception;

	Map<String, Object> saveWpsConfirmAction(CommandMap commandMap) throws Exception;

	Map<String, Object> wpsChangeList(CommandMap commandMap) throws Exception;

	String wpsChangeTypeSelectBoxDataList(CommandMap commandMap) throws Exception;

	
}
