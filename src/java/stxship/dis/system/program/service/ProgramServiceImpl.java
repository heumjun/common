package stxship.dis.system.program.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.system.program.dao.ProgramDAO;

@Service("programService")
public class ProgramServiceImpl extends CommonServiceImpl implements ProgramService {

	@Resource(name = "programDAO")
	private ProgramDAO programDAO;

}
