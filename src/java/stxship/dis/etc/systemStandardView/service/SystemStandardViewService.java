package stxship.dis.etc.systemStandardView.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * 
 * @파일명	: SystemStandardViewService.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 9. 8. 
 * @작성자	: 정재동 
 * @설명
 * <pre>
 * 	 SystemStandardView에서 사용되는 서비스
 * </pre>
 */
public interface SystemStandardViewService extends CommonService {

	Map<String, Object> systemStandardViewList(CommandMap commandMap);

	Map<String, Object> systemStandardViewFileList(CommandMap commandMap);

	View systemStandardExcelExport(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, String> saveSystemStandardView(CommandMap commandMap)throws Exception;

	Map<String, Object> systemStandardFileUpload(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap)throws Exception;

	Map<String, String> saveSystemStandardFile(CommandMap commandMap)throws Exception;

	View systemStandardFileDownload(CommandMap commandMap, Map<String, Object> modelMap);

	
}
