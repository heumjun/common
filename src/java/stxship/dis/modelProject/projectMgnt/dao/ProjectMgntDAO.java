package stxship.dis.modelProject.projectMgnt.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import stxship.dis.common.dao.CommonDAO;

@Repository("projectMgntDAO")
public class ProjectMgntDAO extends CommonDAO {

	public Object saveGridListAction(Map<String, Object> map) {
		return selectOne("saveProjectMgnt.saveProject", map);
	}

}
