package stxship.dis.system.notice.service;

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
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisEGDecrypt;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.system.notice.dao.NoticeDAO;

@Service("noticeService")
public class NoticeServiceImpl extends CommonServiceImpl implements NoticeService {

	@Resource(name = "noticeDAO")
	private NoticeDAO noticeDAO;

	@Override
	public void updateReadCount(CommandMap commandMap) {
		noticeDAO.updateReadCount(commandMap.getMap());
	}
	
	@Override
	public Map<String, Object> NoticeAddSave(HttpServletResponse response, HttpServletRequest request,
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
			
			noticeDAO.updateNoticeInfo(commandMap);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('"+fileName+" 업로드 성공');");
			sb.append("window.opener.fn_search();");
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
	public View noticeFileDownload(CommandMap commandMap, Map<String, Object> modelMap) {
		
		Map<String, Object> rs = noticeDAO.noticeFileDownload(commandMap);
		modelMap.put("data", (byte[]) rs.get("BLOBDATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("FILENAME"));
		return new FileDownLoad();
	}

	@Override
	public Map<String, Object> frmNoticeAddSave(HttpServletResponse response, HttpServletRequest request,
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
		
		if(fileSize > 0) {
			DecryptFile = DisEGDecrypt.createDecryptFile((MultipartFile) pos_file);
			
			FileInputStream input = new FileInputStream(DecryptFile);
			MultipartFile multipartFile = new MockMultipartFile("fileItem",
					DecryptFile.getName(), fileType, IOUtils.toByteArray(input));
			input.close();
			
			commandMap.put("blobdata", multipartFile.getBytes());
		} else {
			commandMap.put("blobdata", "");
		}
		
		commandMap.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("filename", fileName);
		commandMap.put("filecontenttype", fileType);
		commandMap.put("fileSize", fileSize);
		
		
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
			// Notice 등록
			noticeDAO.insertNoticeInfo(commandMap);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('"+fileName+" 등록 성공');");
			sb.append("window.opener.fn_search();");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			
		} catch (Exception e) {
			e.printStackTrace();
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('등록 실패');");
			sb.append("self.close();");
			sb.append("</script>");
			response.getWriter().println(sb);
			response.getWriter().flush();
			return null;
		} finally {
			if(fileSize > 0) {
				DisEGDecrypt.deleteDecryptFile(DecryptFile);
			}
		}
		return null;
		
	}

}
