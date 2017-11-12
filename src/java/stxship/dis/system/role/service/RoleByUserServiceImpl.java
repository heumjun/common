package stxship.dis.system.role.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.ExceptionHandler.DisException;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.system.role.dao.RoleByUserDAO;

@Service("roleByUserService")
public class RoleByUserServiceImpl extends CommonServiceImpl implements RoleByUserService {

	@Resource(name = "roleByUserDAO")
	private RoleByUserDAO roleByUserDAO;

	@Override
	public Map<String, String> roleCopy(CommandMap commandMap) throws Exception {
		commandMap.put("emp_no", commandMap.get("p_emp_no"));
		int cnt = roleByUserDAO.selectOne("saveAdmin.duplicate", commandMap.getMap());
		if (cnt == 0) {
			commandMap.put("emp_no", commandMap.get("t_emp_no"));
			roleByUserDAO.insert("Role.deleteRoleByUser", commandMap.getMap());
			roleByUserDAO.insert("Role.copyRole", commandMap.getMap());

			return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
		} else {
			throw new DisException("관리자권한을 소유한 인원의 권한은 복사할 수 없습니다.");
		}
	}

	public String gridDataUpdate(Map<String, Object> rowData) {
		if (super.gridDataUpdate(rowData).equals(DisConstants.RESULT_FAIL)) {
			return super.gridDataInsert(rowData);
		}
		return DisConstants.RESULT_SUCCESS;
	}
}
