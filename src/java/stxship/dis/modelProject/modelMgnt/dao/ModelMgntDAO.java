package stxship.dis.modelProject.modelMgnt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("modelMgntDAO")
public class ModelMgntDAO extends CommonDAO {

	public List<Map<String, Object>> saveGridListAction(Map<String, Object> map) {
		return selectOne("saveModelMgnt.saveModel", map);
	}
}
