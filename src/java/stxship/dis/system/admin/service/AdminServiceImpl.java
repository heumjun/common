package stxship.dis.system.admin.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.system.admin.dao.AdminDAO;

@Service("adminService")
public class AdminServiceImpl extends CommonServiceImpl implements AdminService {

	@Resource(name = "adminDAO")
	private AdminDAO adminDAO;
}
