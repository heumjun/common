package stxship.dis.etc.systemStandardView.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.type.TypeReference;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.View;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisPageUtil;
import stxship.dis.common.util.DisStringUtil;
import stxship.dis.common.util.FileDownLoad;
import stxship.dis.common.util.GenericExcelView;
import stxship.dis.etc.systemStandardView.dao.SystemStandardViewDAO;

/**
 * 
 * @파일명	: SystemStandardViewServiceImpl.java 
 * @프로젝트	: DIS
 * @날짜		: 2016. 9. 8. 
 * @작성자	: 정재동 
 * @설명
 * <pre>
 *  	SystemStandardView에서 사용되는 서비스
 * </pre>
 */
@Service("systemStandardViewService")
public class SystemStandardViewServiceImpl extends CommonServiceImpl implements SystemStandardViewService {

	@Resource(name = "systemStandardViewDAO")
	private SystemStandardViewDAO systemStandardViewDAO;

	@Override
	public Map<String, Object> systemStandardViewList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = systemStandardViewDAO.systemStandardViewList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public Map<String, Object> systemStandardViewFileList(CommandMap commandMap) {
		// TODO Auto-generated method stub
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			// 페이지 전처리
			DisPageUtil.actionPageBefore(commandMap);
			// 결과 리스트 받음 : 일반 쿼리는 리턴값으로 담겨 온다.
			List<Map<String, Object>> list = systemStandardViewDAO.systemStandardViewFileList(commandMap.getMap());
			// 페이지 후처리
			DisPageUtil.actionPageAfter(commandMap, result, list);

			// 페이징 처리 END
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public View systemStandardExcelExport(CommandMap commandMap, Map<String, Object> modelMap) {
		// TODO Auto-generated method stub
		// COLNAME 설정
		List<String> colName = new ArrayList<String>();
		// 그리드에서 받아온 엑셀 헤더를 설정한다.
		String[] p_col_names = commandMap.get("p_col_name").toString().split(",");
		// COLVALUE 설정
		List<List<String>> colValue = new ArrayList<List<String>>();
		// 그리드에서 받아온 데이터 네임을 배열로 설정
		String[] p_data_names = commandMap.get("p_data_name").toString().split(",");
		
		
		
		// 엑셀 출력 데이터 가져오기
		List<Map<String, Object>> list = systemStandardViewDAO.systemStandardViewList(commandMap.getMap());
		
		boolean startFlag = true;
		for (Map<String, Object> rowData : list) {
			// 그리드의 헤더를 콜네임으로 설정
			List<String> row = new ArrayList<String>();
			for (int i = 0; i < p_col_names.length; i++) {
				if (startFlag) {
					colName.add(p_col_names[i]);
				}
				row.add(DisStringUtil.nullString(rowData.get(p_data_names[i])));
			}
			startFlag = false;
			colValue.add(row);
		}

		// 오늘 날짜 구함 시작
		modelMap.put("excelName", commandMap.get(DisConstants.MAPPER_NAME));
		modelMap.put("colName", colName);
		modelMap.put("colValue", colValue);
		return new GenericExcelView();
	}

	@Override
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Map<String, String> saveSystemStandardView(CommandMap commandMap)throws Exception {
		// TODO Auto-generated method stub
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			int saveResult = systemStandardViewDAO.saveSystemStandardView(rowData);
			if (saveResult == 0) {
				result = DisConstants.RESULT_FAIL;
			} else {
				result = DisConstants.RESULT_SUCCESS;
			}
				
			
		}
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

	@Override
	public Map<String, Object> systemStandardFileUpload(HttpServletResponse response, HttpServletRequest request,
			CommandMap commandMap)throws Exception {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
		Object file1 = multipartRequest.getFile("uploadfile1");
		Object file2 = multipartRequest.getFile("uploadfile2");
		Object file3 = multipartRequest.getFile("uploadfile3");
		Object file4 = multipartRequest.getFile("uploadfile4");
		String fileName1 = ((CommonsMultipartFile) file1).getOriginalFilename();
		String fileName2 = ((CommonsMultipartFile) file2).getOriginalFilename();
		String fileName3 = ((CommonsMultipartFile) file3).getOriginalFilename();
		String fileName4 = ((CommonsMultipartFile) file4).getOriginalFilename();

		int sizeLimit = 10 * 1024 * 1024;
		try {

			String file_id = "";
		
			
			if (!fileName1.equals("")) {
				// file_id seq 받아오기
				file_id = systemStandardViewDAO.selectOneErp("systemStandardView.selectStxStdFileListSeq") + "";
				commandMap.put("file_id", file_id);
				commandMap.put("fileName", fileName1);
				commandMap.put("fileByte", ((CommonsMultipartFile) file1).getBytes());
				int ilen = (int) ((MultipartFile) file1).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('"+fileName1+" 용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					systemStandardViewDAO.insertErp("systemStandardView.insertSystemStandardFile", commandMap.getMap());
				}
			}
			if (!fileName2.equals("")) {
				// file_id seq 받아오기
				file_id = systemStandardViewDAO.selectOneErp("systemStandardView.selectStxStdFileListSeq") + "";
				commandMap.put("file_id", file_id);
				commandMap.put("fileName", fileName2);
				commandMap.put("fileByte", ((CommonsMultipartFile) file2).getBytes());
				int ilen = (int) ((MultipartFile) file2).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('"+fileName2+" 용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					systemStandardViewDAO.insertErp("systemStandardView.insertSystemStandardFile", commandMap.getMap());
				}
			}
			if (!fileName3.equals("")) {
				// file_id seq 받아오기
				file_id = systemStandardViewDAO.selectOneErp("systemStandardView.selectStxStdFileListSeq") + "";
				commandMap.put("file_id", file_id);
				commandMap.put("fileName", fileName3);
				commandMap.put("fileByte", ((CommonsMultipartFile) file3).getBytes());
				int ilen = (int) ((MultipartFile) file3).getSize();
				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('"+fileName3+" 용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					systemStandardViewDAO.insertErp("systemStandardView.insertSystemStandardFile", commandMap.getMap());
				}
			}
			if (!fileName4.equals("")) {
				// file_id seq 받아오기
				file_id = systemStandardViewDAO.selectOneErp("systemStandardView.selectStxStdFileListSeq") + "";
				commandMap.put("file_id", file_id);
				commandMap.put("fileName", fileName4);
				commandMap.put("fileByte", ((CommonsMultipartFile) file4).getBytes());
				int ilen = (int) ((MultipartFile) file4).getSize();

				if (ilen > sizeLimit) {
					StringBuffer sb = new StringBuffer();
					sb.append("<script type=\"text/javascript\" >");
					sb.append("alert('"+fileName4+" 용량 제한으로 인해 실패');");
					sb.append("self.close();");
					sb.append("</script>");
					response.getWriter().println(sb);
					response.getWriter().flush();
					return null;
				} else {
					systemStandardViewDAO.insertErp("systemStandardView.insertSystemStandardFile", commandMap.getMap());
				}
			}

			StringBuffer sb = new StringBuffer();
			sb.append("<script type=\"text/javascript\" >");
			sb.append("alert('정상적으로 저장되었습니다.');");
			sb.append("opener.jqGridFileReload();");
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
	public Map<String, String> saveSystemStandardFile(CommandMap commandMap)throws Exception {
		// TODO Auto-generated method stub
		// 제이슨 데이터를 List Map 형식으로 형변환하기 위한 타입참조
		TypeReference<List<HashMap<String, Object>>> typeRef = new TypeReference<List<HashMap<String, Object>>>() {};
		// 그리드로부터 데이타리스트를 제이슨 형식으로 받아온다.
		String gridDataList = commandMap.get(DisConstants.FROM_GRID_DATA_LIST).toString();
		commandMap.remove(DisConstants.FROM_GRID_DATA_LIST);
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = new ObjectMapper().readValue(gridDataList, typeRef);
		// 결과값 최초
		String result = DisConstants.RESULT_FAIL;
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			int saveResult = systemStandardViewDAO.saveSystemStandardFile(rowData);
			if (saveResult == 0) {
				result = DisConstants.RESULT_FAIL;
			} else {
				result = DisConstants.RESULT_SUCCESS;
			}
				
			
		}
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

	@Override
	public View systemStandardFileDownload(CommandMap commandMap, Map<String, Object> modelMap) {
		// TODO Auto-generated method stub
		Map<String, Object> rs = systemStandardViewDAO.systemStandardFileDownload(commandMap);
		modelMap.put("data", (byte[]) rs.get("FILE_DATA"));
		modelMap.put("contentType", "application/octet-stream;");
		modelMap.put("filename", (String) rs.get("FILE_NAME"));
		return new FileDownLoad();
	}

	
}
