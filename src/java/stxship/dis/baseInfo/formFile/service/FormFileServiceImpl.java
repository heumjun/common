package stxship.dis.baseInfo.formFile.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import stxship.dis.baseInfo.formFile.dao.FormFileDAO;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;

/**
 * @파일명 : FormFileServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 *     <pre>
 * FormFile에서 사용되는 서비스
 *     </pre>
 */
@Service("formFileService")
public class FormFileServiceImpl extends CommonServiceImpl implements FormFileService {

	@Resource(name = "formFileDAO")
	private FormFileDAO formFileDAO;

	@Override
	public Map<String, String> saveFormFile(CommandMap commandMap, HttpServletRequest request) throws Exception {
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		int result = 0;
		Object formfile = multipartRequest.getFile("formfile");
		if (!(formfile == null || "".equals(formfile))) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("originalFileName", ((CommonsMultipartFile) formfile).getOriginalFilename());
			param.put("uploadFile", ((CommonsMultipartFile) formfile).getBytes());
			param.put("commentes", commandMap.get("commentes"));
			param.put("contentType", ((CommonsMultipartFile) formfile).getContentType());
			result = formFileDAO.insert("FormFile.saveFormFile", param);

		}

		if (result == 0) {
			throw new DisException();
		}

		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

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
	@Override
	public void downLoadFile(CommandMap commandMap, HttpServletResponse response) throws Exception {
		Map<String, Object> rs = formFileDAO.getUploadedFormFile(commandMap.getMap());

		byte[] data = (byte[]) rs.get("fileDataBytes");
		String contentType = (String) rs.get("fileContentType");
		String filename = (String) rs.get("filename");

		String docName = new String(filename.getBytes("euc-kr"), "8859_1");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + docName + "\"");
		response.setHeader("Content-Type", contentType);
		response.setContentLength(data.length);
		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		ServletOutputStream out = response.getOutputStream();
		out.write(data);
		out.flush();
		out.close();
	}

	@Override
	public Map<String, String> delFormFile(CommandMap commandMap) throws Exception {
		List<Map<String, Object>> formFileList = DisJsonUtil.toList(commandMap.get("chmResultList"));

		for (Map<String, Object> rowData : formFileList) {
			formFileDAO.delete("FormFile.deleteFormFile", rowData);
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
}
