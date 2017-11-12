package stxship.dis.item.itemInterface.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.controller.CommonController;
import stxship.dis.item.itemInterface.service.ItemInterfaceService;

@Controller
public class ItemInterfaceController extends CommonController {
	/**
	 * ItemInterface 서비스
	 */
	@Resource(name = "itemInterfaceService")
	private ItemInterfaceService itemInterfaceService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.ItemInterface 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemInterface.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * ItemInterface 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemInterfaceList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		return itemInterfaceService.getGridList(commandMap);
	}

	/**
	 * @메소드명 : saveItemToErp
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 *	변경된 그리드 정보를 가져와서 데이타베이스에 반영한다.
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "saveItemToErp.do")
	public @ResponseBody Map<String, String> saveItemToErp(CommandMap commandMap) throws Exception {
		return itemInterfaceService.saveItemToErp(commandMap);
	}
}
