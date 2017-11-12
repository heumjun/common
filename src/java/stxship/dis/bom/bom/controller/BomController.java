package stxship.dis.bom.bom.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.bom.bom.service.BomService;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;

@Controller
public class BomController extends CommonController {
	/**
	 * Bom 서비스
	 */
	@Resource(name = "bomService")
	private BomService bomService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.Bom 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bom.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : getGridListAction
	 * @날짜 : 2015. 12. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Bom 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomList.do")
	public @ResponseBody Map<String, Object> getGridListAction(CommandMap commandMap) {
		// 공통 서비스에서 사용되어질 커스텀 서비스를 설정한다.
		// 각 서비스별로 별도 로직이 이루어진다.
		if(commandMap.get("p_item_code").equals("*"))  {
			commandMap.put("p_item_code", "");
		}
		
		return bomService.getGridList(commandMap);
	}


	/**
	 * @메소드명 : bomExcelExport
	 * @날짜 : 2015. 12. 10.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * Bom 리스트 엑셀 다운로드
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "bomExcelExport.do")
	public View bomExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return bomService.bomExcelExport(commandMap, modelMap);
	}
	
	/**
	 * @메소드명 : popUpItem
	 * @날짜 : 2017. 3. 4.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * 검색버튼을 선택하였을때 BOM 아이템 검색화면 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItem.do")
	public ModelAndView popUpItem(CommandMap commandMap) {
		ModelAndView mav = getUserRoleAndLink(commandMap);
		mav.setViewName(DisConstants.BOM + DisConstants.POPUP + commandMap.get(DisConstants.JSP_NAME));
		return mav;
	}
	
	/**
	 * @메소드명 : infoSearchItemAction
	 * @날짜 : 2017. 3. 4.
	 * @작성자 : 조흠준
	 * @설명 :
	 * 
	 *     <pre>
	 * BOM 아이템 검색
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "popUpItemList.do")
	public @ResponseBody Map<String, Object> popUpItemList(CommandMap commandMap) throws Exception {
		return bomService.getGridList(commandMap);
	}
	
	
}
