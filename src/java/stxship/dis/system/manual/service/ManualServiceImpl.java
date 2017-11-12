package stxship.dis.system.manual.service;

import java.io.File;
import java.io.FileInputStream;
import java.util.Map;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.View;
import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.system.manual.dao.ManualDAO;

@Service("manualService")
public class ManualServiceImpl extends CommonServiceImpl implements ManualService {

	@Resource(name = "manualDAO")
	private ManualDAO manualDAO;

	@Override
	public View manualFileDownload(CommandMap commandMap, Map<String, Object> modelMap) {
		
		Map<String, Object> rs = manualDAO.manualFileDownload(commandMap);
		modelMap.put("data", (byte[]) rs.get("BLOBDATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("FILENAME"));
		return new FileDownLoad();
	}

	@Override
	public Map<String, Object> manualAddSave(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap) throws Exception {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Object pos_file = multipartRequest.getFile("fileName");
		
		// 파일 정보
		String fileName = ((MultipartFile) pos_file).getOriginalFilename();
		String fileType = ((MultipartFile) pos_file).getContentType();
		long fileSize = ((MultipartFile) pos_file).getSize();
		
		//파일 복호화
		File DecryptFile = null; 
		DecryptFile = DisEGDecrypt.createDecryptFile((MultipartFile) pos_file);
		
		FileInputStream input = new FileInputStream(DecryptFile);
		MultipartFile multipartFile = new MockMultipartFile("fileItem",
				DecryptFile.getName(), fileType, IOUtils.toByteArray(input));
		input.close();
		
		commandMap.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("filename", fileName);
		commandMap.put("filecontenttype", fileType);
		commandMap.put("fileSize", fileSize);
		commandMap.put("blobdata", multipartFile.getBytes());
		
		int sizeLimit = 5 * 1024 * 1024;
		
		if (fileSize > sizeLimit) {
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('용량 제한으로 인해 실패');");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			return null;
		}
		
		try {
			
			manualDAO.insertManualInfo(commandMap);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('"+fileName+" 업로드 성공');");
			//sb.append("opener.location = 'manual.do';");
			sb.append("window.opener.fn_search();");
			sb.append("window.opener.fn_detailSearch('"+commandMap.get("p_pgm_id")+"');");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('업로드 실패');");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			return null;
		} finally {
			DisEGDecrypt.deleteDecryptFile(DecryptFile);
		}
		return null;
	}

	@Override
	public Map<String, String> manualFileDelete(CommandMap commandMap) throws Exception {
		String result = DisConstants.RESULT_FAIL;
		
		result = manualDAO.manualFileDelete(commandMap.getMap());
		
		if (result.equals(DisConstants.RESULT_SUCCESS)) {
			// 결과값에 따른 메시지를 담아 전송
			return DisMessageUtil.getResultMessage(result);
		} else if (result.equals(DisConstants.RESULT_FAIL)) {
			// 실패한경우(실패 메시지가 없는 경우)
			throw new DisException();
		} else {
			// 실패한경우(실패 메시지가 있는 경우)
			throw new DisException(result);
		}
	}
	

}
