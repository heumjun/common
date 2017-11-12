package stxship.dis.item.searchItem.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.controller.CommonController;
import stxship.dis.item.searchItem.service.SearchItemService;

@Controller
public class SearchItemController extends CommonController {
	/**
	 * searchItem 서비스
	 */
	@Resource(name = "searchItemService")
	private SearchItemService searchItemService;

	/**
	 * @메소드명 : linkSelectedMenu
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 1.유저의 권한체크
	 * 2.searchItem 페이지 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "itemList.do")
	public ModelAndView linkSelectedMenu(CommandMap commandMap) {
		return getUserRoleAndLink(commandMap);
	}

	/**
	 * @메소드명 : searchItemListAction
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * searchItem 리스트 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value = "searchItemList.do")
	public @ResponseBody Map<String, Object> searchItemListAction(CommandMap commandMap) throws Exception {
		return searchItemService.searchItemList(commandMap);
	}

	/**
	 * @메소드명 : saveItemStateCancel
	 * @날짜 : 2015. 12. 09.
	 * @작성자 : 이상빈
	 * @설명 :
	 * 
	 *     <pre>
	 * 선택항목 상태취소 업데이트
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "updateItemStatesCancel.do")
	public @ResponseBody Map<String, String> updateItemStatesCancel(CommandMap commandMap) throws Exception {

		return searchItemService.saveGridList(commandMap);
	}

	/**
	 * @메소드명 : searchItemExcelExport
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 엑셀 출력 액션
	 *     </pre>
	 * 
	 * @param commandMap
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "searchItemExcelExport.do")
	public View searchItemExcelExport(CommandMap commandMap, Map<String, Object> modelMap) throws Exception {
		return searchItemService.searchItemExcelExport(commandMap, modelMap);
	}

	/**
	 * @메소드명 : popUpItemDetail
	 * @날짜 : 2016. 1. 7.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 아이템의 상세팝업창 이동
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 */
	@RequestMapping(value = "popUpItemDetail.do")
	public ModelAndView popUpItemDetail(CommandMap commandMap) {
		
		ModelAndView mav = new ModelAndView("item/popUp/" + commandMap.get(DisConstants.JSP_NAME));
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}

	/**
	 * @메소드명 : infoItemDetail
	 * @날짜 : 2016. 1. 12.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 아이템의 상세 내용 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoItemDetail.do")
	public @ResponseBody Map<String, Object> infoItemDetail(CommandMap commandMap) throws Exception {
		return searchItemService.getDbDataOne(commandMap);
	}

	/**
	 * @메소드명 : infoItemAttListAction
	 * @날짜 : 2016. 1. 12.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * 아이템의 상세 내용 취득
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "infoItemAttList.do")
	public @ResponseBody Map<String, Object> infoItemAttListAction(CommandMap commandMap) throws Exception {

		return searchItemService.getGridListNoPaging(commandMap);
	}
	
	@RequestMapping(value = "searchItemDwgPopupView.do")
	public ModelAndView dwgPopupView(CommandMap commandMap) {
		// commandMap에 마스터 입력해준다.
		ModelAndView mav = new ModelAndView("item/popUp/" + commandMap.get(DisConstants.MAPPER_NAME));
		
		mav.addAllObjects(commandMap.getMap());
		return mav;
	}
	
	@RequestMapping(value = "searchItemDwgPopupViewList.do", produces="text/plain;charset=UTF-8")
	public @ResponseBody String searchItemDwgPopupViewList(CommandMap commandMap) throws Exception {
		return searchItemService.searchItemDwgPopupViewList(commandMap);
	}

}
