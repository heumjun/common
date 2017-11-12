package stxship.dis.system.mailing.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.wps.service.WpsService;


/**
 * 
 * @파일명		: MailingController.java 
 * @프로젝트	: DIMS
 * @날짜		: 2017. 10. 23. 
 * @작성자		: 이상빈
 * @설명
 * <pre>
 * 	
 * </pre>
 */
@Controller
public class MailingController extends CommonController {

	@Resource(name = "WpsService")
	private WpsService wpsService;
	
	/**
	 * 
	 * @메소드명	: wpsCodeManage
	 * @날짜		: 2017. 10. 23.
	 * @작성자		: 이상빈
	 * @설명
	 * <pre>
	 *
	 * </pre>
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "mailingManager.do")
	public ModelAndView wpsCodeManage(CommandMap commandMap) throws Exception {
		return getUserRoleAndLink(commandMap);
	}
	
}
