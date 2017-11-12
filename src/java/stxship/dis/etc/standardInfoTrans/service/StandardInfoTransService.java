package stxship.dis.etc.standardInfoTrans.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : StandardInfoTransService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * StandardInfoTrans에서 사용되는 서비스
 *     </pre>
 */
public interface StandardInfoTransService extends CommonService {

	List<Map<String, Object>> standardInfoTransDbList(CommandMap commandMap) throws Exception;

	Map<String, Object> standardInfoTransDbData(CommandMap commandMap) throws Exception;

	Map<String, Object> itemTransFileUpload(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap) throws Exception;

	Map<String, Object> tbcTemporaryStorage(CommandMap commandMap) throws Exception;

	Map<String, Object> itemreceive(CommandMap commandMap) throws Exception;

	Map<String, Object> updateInfoList(CommandMap commandMap) throws Exception;

	Map<String, Object> updateReturn(CommandMap commandMap) throws Exception;

	Map<String, Object> updateRetract(CommandMap commandMap) throws Exception;

	Map<String, Object> deleteDoc(CommandMap commandMap) throws Exception;

	Map<String, Object> deleteDocument(CommandMap commandMap) throws Exception;

	Map<String, Object> adminDelete(CommandMap commandMap) throws Exception;

	View itemTransDownload(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
