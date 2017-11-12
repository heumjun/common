package stxship.dis.baseInfo.formFile.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

/**
 * @파일명 : FormFileService.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * FormFile에서 사용되는 서비스
 *     </pre>
 */
public interface FormFileService extends CommonService {
	/**
	 * @메소드명 : downLoadFile
	 * @날짜 : 2015. 12. 4.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 폼파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param response
	 * @throws Exception
	 */
	void downLoadFile(CommandMap commandMap, HttpServletResponse response) throws Exception;

	Map<String, String> saveFormFile(CommandMap commandMap, HttpServletRequest request) throws Exception;

	Map<String, String> delFormFile(CommandMap commandMap) throws Exception ;
}
