package stxship.dis.item.itemInterface.service;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisJsonUtil;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.item.itemInterface.dao.ItemInterfaceDAO;

@Service("itemInterfaceService")
public class ItemInterfaceServiceImpl extends CommonServiceImpl implements ItemInterfaceService {

	@Resource(name = "itemInterfaceDAO")
	private ItemInterfaceDAO itemInterfaceDAO;

	/**
	 * @메소드명 : saveGridListAction
	 * @날짜 : 2016. 3. 9.
	 * @작성자 : 황경호
	 * @설명 :
	 * 
	 *     <pre>
	 * ITEM을 ERP에 반영
	 *     </pre>
	 * 
	 * @param commandMap
	 * @return
	 * @throws Exception
	 */
	@Override
	public Map<String, String> saveItemToErp(CommandMap commandMap) throws Exception {
		// List Map 형식으로 형변환
		List<Map<String, Object>> saveList = DisJsonUtil.toList(commandMap.get(DisConstants.FROM_GRID_DATA_LIST));
		// 결과값 최초
		String sErrMsg = null;
		for (Map<String, Object> rowData : saveList) {
			// CommandMap에 저장되어있는 DB용 로그인 아이디, 맵퍼네임 등을 설정한다.
			rowData.put(DisConstants.SET_DB_LOGIN_ID, commandMap.get(DisConstants.SET_DB_LOGIN_ID));
			rowData.put(DisConstants.MAPPER_NAME, commandMap.get(DisConstants.MAPPER_NAME));

			rowData.put("p_item_code", rowData.get("item_code"));
			rowData.put("p_loginId", rowData.get("loginId"));

			itemInterfaceDAO.saveGridListAction(rowData);

			sErrMsg = (String) rowData.get("p_error_msg");

		}
		if (sErrMsg != null) {
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_FAIL);
		} else {
			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		}
	}
}
