package stxship.dis.ems.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface EmsAdminService extends CommonService {

	/** 
	 * @메소드명	: emsAdminGetDeptList
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 조회조건 부서 SelectBox 리스트 불러옴
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public List<Map<String, Object>> emsAdminSelectBoxDept(CommandMap commandMap);
	
	/** 
	 * @메소드명	: emsAdminApprove
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * emsAdmin 선택항목 승인
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> emsAdminApprove(CommandMap commandMap) throws Exception;
	
	/** 
	 * @메소드명	: emsAdminRefuse
	 * @날짜		: 2016. 03. 22. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * emsAdmin 선택항목 승인
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public Map<String, Object> emsAdminRefuse(CommandMap commandMap) throws Exception;

	/**
	 * @메소드명 : popUpAdminSpecDownloadFile
	 * @날짜 : 2016. 03. 31.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 사양서 버튼 팝업창 : 파일 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public View popUpAdminSpecDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
