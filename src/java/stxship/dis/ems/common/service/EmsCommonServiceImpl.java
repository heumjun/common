package stxship.dis.ems.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.ems.common.dao.EmsCommonDAO;

@Service("emsCommonService")
public class EmsCommonServiceImpl extends CommonServiceImpl {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "emsCommonDAO")
	private EmsCommonDAO emsCommonDAO;

	/** 
	 * @메소드명	: dbMasterSendEmail
	 * @날짜		: 2016. 03. 18. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * DB MASTER 메일 발송
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> dbMasterSendEmail(Map<String, Object> map) {
		return emsCommonDAO.dbMasterSendEmail(map);
	}
	
	/** 
	 * @메소드명	: sendEmail
	 * @날짜		: 2016. 03. 18. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 메일 발송
	 * </pre>
	 * @param commandMap
	 * @return
	 */
	public Map<String, Object> sendEmail(Map<String, Object> map) {
		return emsCommonDAO.sendEmail(map);
	}
	
	/**
	 * @메소드명 : getPurNo
	 * @날짜 : 2016. 03. 18.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * PUR NO를 가져옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getPurNo(Map<String, Object> map) throws Exception {

		String p_master = map.get("p_master").toString();
		String p_dwg_no = map.get("p_dwg_no").toString();
		String p_state = map.get("p_state").toString();

		String dwgNoArray[] = p_dwg_no.split(",");
		String stateArray[] = p_state.split(",");

		Map<String, Object> rowData = new HashMap<>();
		rowData.put("p_master", p_master);
		rowData.put("p_dwg_no", p_dwg_no);
		rowData.put("p_state", p_state);
		rowData.put("dwgNoArray", dwgNoArray);
		rowData.put("stateArray", stateArray);

		List<Map<String, Object>> pur_no = emsCommonDAO.getPurNo(rowData);

		return pur_no;
	}

	/**
	 * @메소드명 : getBuyer
	 * @날짜 : 2016. 03. 18.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 조달 담당자를 가져옴
	 *     </pre>
	 * 
	 * @param map
	 * @return
	 */
	public List<Map<String, Object>> getBuyer(Map<String, Object> map) throws Exception {

		String p_master = map.get("p_master").toString();
		String p_dwg_no = map.get("p_dwg_no").toString();
		String p_item_code = map.get("p_item_code") != null ? map.get("p_item_code").toString() : "";
		String p_pur_no = map.get("p_pur_no").toString();

		String purNoArray[] = p_pur_no.split(",");

		Map<String, Object> rowData = new HashMap<>();
		rowData.put("p_master", p_master);
		rowData.put("p_dwg_no", p_dwg_no);
		rowData.put("p_item_code", p_item_code);
		rowData.put("p_pur_no", p_pur_no);
		rowData.put("purNoArray", purNoArray);

		List<Map<String, Object>> getBuyer = emsCommonDAO.getBuyer(rowData);

		return getBuyer;
	}
	
	/** 
	 * @메소드명	: getUserInfo
	 * @날짜		: 2016. 03. 21. 
	 * @작성자	: 이상빈
	 * @설명		: 
	 * <pre>
	 * 유저 정보를 가져옴
	 * </pre>
	 * @param map
	 * @return 
	 */
	public Map<String, Object> getUserInfo(Map<String, Object> map){
		
		String loginId = map.get("loginId").toString();
		
		Map<String, Object> rowData = new HashMap<>();
		rowData.put("loginId", loginId);
		
		return emsCommonDAO.getUserInfo(rowData);
	}
}
