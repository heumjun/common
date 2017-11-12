package stxship.dis.system.contactUs.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.system.contactUs.dao.PersonInChargeDAO;

@Service("personInChargeService")
public class PersonInChargeServiceImpl extends CommonServiceImpl implements PersonInChargeService {

	@Resource(name = "personInChargeDAO")
	private PersonInChargeDAO personInChargeDAO;

}
