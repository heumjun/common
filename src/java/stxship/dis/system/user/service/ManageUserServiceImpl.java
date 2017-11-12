package stxship.dis.system.user.service;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.system.user.dao.ManageUserDAO;

@Service("manageUserService")
public class ManageUserServiceImpl extends CommonServiceImpl implements ManageUserService {

	@Resource(name = "manageUserDAO")
	private ManageUserDAO manageUserDAO;

	@Override
	public ModelAndView savePopUpUserInfo(CommandMap commandMap) {
		commandMap.put("adminid", commandMap.get(DisConstants.SET_DB_LOGIN_ID));
		commandMap.put("adminpw", commandMap.get("old_pw"));
		Object loginUser = manageUserDAO.selectOne("saveLoginUserInfo.selectLogin", commandMap.getMap());

		ModelAndView mav = new ModelAndView();
		if (loginUser == null) {
			mav.addObject("result", "F");
			mav.addObject("message", "기존 비밀번호가 틀립니다. 다시 확인해 주세요.");

		} else {
			commandMap.put("adminpw", commandMap.get("new_pw"));
			manageUserDAO.insert("saveLoginUserInfo.updateUserPw", commandMap.getMap());
			mav.addObject("message", "비밀번호가 정상적으로 변경되었습니다. 로그아웃합니다.");
			mav.addObject("result", "S");
		}
		return mav;
	}
	
	@Override
	public Map<String, Object> saveBookmarkEdit(CommandMap commandMap) {
		int result = 0;
		result = manageUserDAO.delete("saveManageUser.deleteBookmark", commandMap.getMap());
		
		String res = (String) commandMap.get("res");
		String[] arr = res.split(",");
		if(res.length() > 0){
			for (int i=0; i<arr.length; i++) {
				Map<String, Object> rowData = new HashMap<String, Object>();
				rowData.put("loginId", commandMap.get("loginId"));
				rowData.put("roleCode", commandMap.get("roleCode"));
				rowData.put("menu_id", arr[i]);
				rowData.put("order_by", i+1);
				result = manageUserDAO.insert("saveManageUser.insertBookmark", rowData);
			}
		}
		
		Map<String, Object> resultData = new HashMap<String, Object>();
		resultData.put("result", "S");
		resultData.put("message", "BOOKMARK 항목이 정상적으로 반영되었습니다.");

		return resultData;
	}
}
