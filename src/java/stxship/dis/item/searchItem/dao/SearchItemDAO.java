package stxship.dis.item.searchItem.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("searchItemDAO")
public class SearchItemDAO extends CommonDAO {

	public List<Map<String, Object>> searchItemExcelList(Map<String, Object> map) {
		return selectList("searchItemExcelList.list", map);
	}

	public List<Map<String, Object>> searchItemList(Map<String, Object> map) {
		return selectList("searchItemList.list", map);
	}
	
	
	public int getPrintSeqH(Map<String, Object> map) {
		return update("searchItemDwgPopupView.getPrintSeqH", map);
	}

	public int getPrintSeqD(Map<String, Object> map) {
		return update("searchItemDwgPopupView.getPrintSeqD", map);
		
	}

	public int getPrintSeq(Map<String, Object> map) {
		return update("searchItemDwgPopupView.getPrintSeq", map);
		
	}

	public List<Map<String, Object>> searchItemDwgPopupViewList(Map<String, Object> map) {
		return selectList("searchItemDwgPopupView.dwgPopupViewList", map);
	}
}
