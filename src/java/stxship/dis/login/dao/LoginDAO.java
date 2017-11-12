package stxship.dis.login.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

/** 
 * @파일명	: LoginDAO.java 
 * @프로젝트	: DIS
 * @날짜		: 2015. 11. 17. 
 * @작성자	: 황경호 
 * @설명
 * <pre>
 * 
 * </pre>
 */
@Repository("loginDAO")
public class LoginDAO extends CommonDAO {
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> selectLogin(Map<String, Object> map) {
		return (Map<String, Object>)selectOne("LoginUser.selectLogin", map);
	}

	public List<Map<String, Object>> popupList(Map<String, Object> map) {
		return selectList("LoginUser.popupList", map);
	}	
}
