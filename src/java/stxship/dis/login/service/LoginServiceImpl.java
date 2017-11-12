package stxship.dis.login.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.util.DisCodeUtil;
import stxship.dis.common.util.DisSessionUtil;
import stxship.dis.login.dao.LoginDAO;

/**
 * @파일명 : LoginServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 17.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 로그인 서비스
 *     </pre>
 */
@Service("loginService")
public class LoginServiceImpl implements LoginService {
	

	@Resource(name = "loginDAO")
	private LoginDAO loginDAO;

	@Override
	public boolean isUser(CommandMap commandMap) {
		if (commandMap.get("loginID") != null) {
			commandMap.put("loginID", DisCodeUtil.decrypt(commandMap.get("loginID") + ""));
			DisSessionUtil.setObject("loginID", commandMap.get("loginID"));
		}
		// 로그인 유저를 DB로부터 취득
		Object loginUser = loginDAO.selectLogin(commandMap.getMap());
		if (loginUser != null) {
			// 유저정보가 있는경우 유저정보를 세션에 설정
			DisSessionUtil.setLoginUserObject(loginUser);
			return true;
		}
		// 유저정보가 없는경우
		return false;
	}

	@Override
	public List<Map<String, Object>> popupList(CommandMap commandMap) {
		return loginDAO.popupList(commandMap.getMap());
	}
}
