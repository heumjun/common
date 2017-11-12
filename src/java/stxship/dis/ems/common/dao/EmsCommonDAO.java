package stxship.dis.ems.common.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.dao.CommonDAO;

@Repository("emsCommonDAO")
public class EmsCommonDAO extends CommonDAO {

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
		return selectOne("emsCommonMain.dbMasterSendEmail", map);
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
		return selectOne("emsCommonMain.sendEmail", map);
	}
	
	/** 
	 * @메소드명	: getPurNo
	 * @날짜		: 2016. 03. 18. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * PUR NO를 가져옴
	 * </pre>
	 * @param map
	 * @return
	 */	
	public List<Map<String, Object>> getPurNo(Map<String, Object> map) {
		return selectList("emsCommonMain.getPurNo", map);
	}
	
	/** 
	 * @메소드명	: getBuyer
	 * @날짜		: 2016. 03. 18. 
	 * @작성자	: 이상빈 
	 * @설명		: 
	 * <pre>
	 * 조달 담당자를 가져옴
	 * </pre>
	 * @param map
	 * @return
	 */	
	public List<Map<String, Object>> getBuyer(Map<String, Object> map) {
		return selectList("emsCommonMain.getBuyer", map);
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
	public Map<String, Object> getUserInfo(Map<String, Object> map) {
		return selectOne("emsCommonMain.getUserInfo", map);
	}


}
