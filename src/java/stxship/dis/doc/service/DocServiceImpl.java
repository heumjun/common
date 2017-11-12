package stxship.dis.doc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.doc.dao.DocDAO;

/**
 * @파일명 : DocServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 1. 7.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * DOC 서비스
 *     </pre>
 */
@Service("docService")
public class DocServiceImpl extends CommonServiceImpl implements DocService {

	@Resource(name = "docDAO")
	private DocDAO docDAO;

	/**
	 * @메소드명 : insertDoc
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC file 저장
	 *     </pre>
	 * 
	 * @param file
	 * @param comments
	 * @param createdby
	 * @param main_code
	 * @return
	 */
	private int insertDoc(CommonsMultipartFile file, Object comments, Object createdby, Object main_code) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("uploadfileName", file.getOriginalFilename());
		param.put("uploadfileByte", file.getBytes());
		param.put("uploadfileType", file.getContentType());
		param.put("commentes", comments);
		param.put("createdBy", createdby);
		param.put("main_code", main_code);
		return docDAO.saveDocFileAdd(param);
	}

	/**
	 * @메소드명 : saveDoc
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 입력된 Doc정보를 취득 하여 저장
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public String saveDoc(HttpServletRequest request, CommandMap commandMap) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		int result = 0;
		Object file1 = multipartRequest.getFile("file1");
		Object file2 = multipartRequest.getFile("file2");
		Object file3 = multipartRequest.getFile("file3");
		Object file4 = multipartRequest.getFile("file4");
		Object file5 = multipartRequest.getFile("file5");
		
		CommonsMultipartFile MultipartFile1 = (CommonsMultipartFile) file1;
		String fileName1 = MultipartFile1.getOriginalFilename();
		CommonsMultipartFile MultipartFile2 = (CommonsMultipartFile) file2;
		String fileName2 = MultipartFile2.getOriginalFilename();
		CommonsMultipartFile MultipartFile3 = (CommonsMultipartFile) file3;
		String fileName3 = MultipartFile3.getOriginalFilename();
		CommonsMultipartFile MultipartFile4 = (CommonsMultipartFile) file4;
		String fileName4 = MultipartFile4.getOriginalFilename();
		CommonsMultipartFile MultipartFile5 = (CommonsMultipartFile) file5;
		String fileName5 = MultipartFile5.getOriginalFilename();
		
		if (!(fileName1 == null || "".equals(fileName1))) {
			result = insertDoc((CommonsMultipartFile) file1, commandMap.get("commentes1"), commandMap.get("createdby"),
					commandMap.get("main_code"));
		}
		if (!(fileName2 == null || "".equals(fileName2))) {
			result = insertDoc((CommonsMultipartFile) file2, commandMap.get("commentes2"), commandMap.get("createdby"),
					commandMap.get("main_code"));
		}
		if (!(fileName3 == null || "".equals(fileName3))) {
			result = insertDoc((CommonsMultipartFile) file3, commandMap.get("commentes3"), commandMap.get("createdby"),
					commandMap.get("main_code"));
		}
		if (!(fileName4 == null || "".equals(fileName4))) {
			result = insertDoc((CommonsMultipartFile) file4, commandMap.get("commentes4"), commandMap.get("createdby"),
					commandMap.get("main_code"));
		}
		if (!(fileName5 == null || "".equals(fileName5))) {
			result = insertDoc((CommonsMultipartFile) file5, commandMap.get("commentes5"), commandMap.get("createdby"),
					commandMap.get("main_code"));
		}
		if (result == 0) {
			throw new DisException();
		}

		String resultMsg = "";
		resultMsg = DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS).get("result");
		
		return resultMsg;
	}

	/**
	 * @메소드명 : delDoc
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC을 삭제한다.
	 *     </pre>
	 * 
	 * @param request
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> delDoc(HttpServletRequest request, CommandMap commandMap) throws Exception {
		List<Map<String, Object>> docList = DisJsonUtil.toList(request.getParameter(DisConstants.FROM_GRID_DATA_LIST));
		for (Map<String, Object> rowData : docList) {
			int result = docDAO.deleteFileAdd(rowData);
			if (result == 0) {
				throw new DisException();
			}
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	/**
	 * @메소드명 : docDownloadFile
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * DOC 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public View docDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		Map<String, Object> rs = docDAO.getUploadedFileForDoc(commandMap.getMap());

		modelMap.put("data", (byte[]) rs.get("fileDataBytes"));
		modelMap.put("contentType", (String) rs.get("fileContentType"));
		modelMap.put("filename", (String) rs.get("filename"));
		return new FileDownLoad();
	}
}
