package stxship.dis.item.itemInterface.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("itemInterfaceDAO")
public class ItemInterfaceDAO extends CommonDAO {

	public String saveGridListAction(Map<String, Object> map) {
		return (String)selectOne("saveItemToErp.saveItem",map);
	}
}
