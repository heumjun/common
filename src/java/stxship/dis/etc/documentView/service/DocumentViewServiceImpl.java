package stxship.dis.etc.documentView.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.etc.documentView.dao.DocumentViewDAO;

/**
 * @파일명 : DocumentViewServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2016. 8. 31.
 * @작성자 : 정재동
 * @설명
 * 
 * 	<pre>
 * DocumentView에서 사용되는 서비스
 *     </pre>
 */
@Service("documentViewService")
public class DocumentViewServiceImpl extends CommonServiceImpl implements DocumentViewService {

	@Resource(name = "documentViewDAO")
	private DocumentViewDAO documentViewDAO;

	@Override
	public List<Map<String, Object>> selectDocumentView(CommandMap commandMap) {
		// TODO Auto-generated method stub
		return  documentViewDAO.selectDocumentView(commandMap);
	}

	@Override
	public View documentFileDownload(CommandMap commandMap, Map<String, Object> modelMap) {
		// TODO Auto-generated method stub
		Map<String, Object> rs = documentViewDAO.documentFileDownload(commandMap);
		modelMap.put("data", (byte[]) rs.get("FILE_DATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("FILE_NAME"));
		return new FileDownLoad();
	}

	@Override
	public Map<String, Object> documentAddSave(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap)throws Exception {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Object pos_file = multipartRequest.getFile("fileName");
		// 파일 정보
		String fileName = ((MultipartFile) pos_file).getOriginalFilename();
		String fileType = ((MultipartFile) pos_file).getContentType();
		long fileSize = ((MultipartFile) pos_file).getSize();
		
		commandMap.put("fileName", fileName);
		commandMap.put("fileType", fileType);
		commandMap.put("fileSize", fileSize);
		commandMap.put("fileByte", ((CommonsMultipartFile) pos_file).getBytes());
		
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
						
			// ERP 첨부파일 테이블 시퀀스 추출
			String file_id = documentViewDAO.getFileIdSeq(commandMap);
			// ERP 첨부문서 테이블 시퀀스 추출
			String document_id = documentViewDAO.getDocumenIdSeq(commandMap);
			// ERP 첨부파일 + 첨부문서 연계 정보 테이블 시퀀스 추출
			String attached_document_id = documentViewDAO.getAttachedDocumenIdSeq(commandMap);
			 
			commandMap.put("file_id", file_id);
			commandMap.put("document_id", document_id);
			commandMap.put("attached_document_id", attached_document_id);
			
			
			// ERP 첨부파일 테이블에 첨부파일 정보 저장
			documentViewDAO.insertFileInfo(commandMap);
			
			// 사번 ID(ERP에서 사용하는) 추출
			String updatePersonId = documentViewDAO.getUpdatePersonId(commandMap);
			commandMap.put("updatePersonId", updatePersonId);
			
			// ERP 첨부문서 테이블에 문서 정보 저장
			documentViewDAO.insertDocumentInfo(commandMap);
			
			// ERP 첨부문서 테이블에 문서 상세 정보 저장
			documentViewDAO.insertAttachedDocumentInfo(commandMap);
         
			 // ERP 첨부파일 + 첨부문서 테이블에 문서 및 첨부파일 연계 정보 저장
			documentViewDAO.insertAttachedDocumentLinkInfo(commandMap);
			
			// DOCUMENT 리스트 관리 테이블에 저장
			documentViewDAO.insertDocumentListMgtInfo(commandMap);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('"+fileName+" 업로드 성공');");
			sb.append("opener.location = 'documentView.do';");
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
		}
		return null;
	}

	@Override
	public Map<String, Object> documentDelete(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap)throws Exception {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		try {
			// 항목 자체를 삭제하는 것이 아니라 disable 처리함.
			documentViewDAO.updateDocumentFile(commandMap);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('삭제 완료');");
			sb.append("location = 'documentView.do';");
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
		}
		return null;
	}

	



}
