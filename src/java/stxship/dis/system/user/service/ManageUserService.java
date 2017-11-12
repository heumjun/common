package stxship.dis.system.user.service;

import java.util.Map;

import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface ManageUserService extends CommonService {

	ModelAndView savePopUpUserInfo(CommandMap commandMap);
	
	Map<String, Object> saveBookmarkEdit(CommandMap commandMap);
}
