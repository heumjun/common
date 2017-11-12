package stxship.dis.common.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonService;
import stxship.dis.common.util.DisSessionUtil;

/**
 * @파일명 : CommonController.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 11. 24.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * 컨트롤러의 공통 처리를 담당한다. 각 로직의 컨트롤러에서 상속됨
 *     </pre>
 */
public class CommonController {
	@Resource(name = "commonService")
	public CommonService commonService;

	/**
	 * @메소드명 : getUserRoleAndLink
	 * @날짜 : 2015. 11. 24.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 공통 : 유저정보를 취득하고 각 로직별 해당 페이지로 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	public ModelAndView getUserRoleAndLink(CommandMap commandMap){
		// 상위 링크가 없을시에는 세션에서 상위링크를 가져온다.
		String nextViewLink = commandMap.get(DisConstants.NEXT_VIEW_LINK).toString();
		String parentUrl = "";
		if (commandMap.get(DisConstants.VIEW_PARENT_URL) == null) {
			parentUrl = DisSessionUtil.getObject(DisConstants.VIEW_PARENT_URL).toString();
			if (nextViewLink.startsWith(DisConstants.POPUP)) {
				nextViewLink = DisConstants.POPUP + nextViewLink;
			}
			nextViewLink = parentUrl + nextViewLink;
		}

		ModelAndView mv = new ModelAndView(nextViewLink);

		// get으로 받은 모든 파라미터를 ModelAndView로 넘겨준다.
		/*try {
			System.out.println(commandMap.getMap());
			if(commandMap.get("menu_id") != null) {
				commandMap.put("manualInfo", commonService.manualInfoList(commandMap));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		mv.addAllObjects(commandMap.getMap());
		// 권한정보
		mv.addObject(DisConstants.VIEW_USER_ROLE_KEY, commonService.getUserRole(commandMap));
		return mv;
	}
	
	@ModelAttribute("manualInfo")
	public Map<String,Object> getManualInfoList(CommandMap commandMap){		
		try {
			if(commandMap.get("menu_id") != null) {
				return commonService.manualInfoList(commandMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
