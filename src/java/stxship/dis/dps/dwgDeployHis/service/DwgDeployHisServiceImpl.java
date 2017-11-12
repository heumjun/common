package stxship.dis.dps.dwgDeployHis.service;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import stxship.dis.dps.common.service.DpsCommonServiceImpl;
import stxship.dis.dps.dwgDeployHis.dao.DwgDeployHisDAO;
import stxship.dis.dps.dwgRegister.dao.DwgRegisterDAO;

@Service("dwgDeployHisService")
public class DwgDeployHisServiceImpl extends DpsCommonServiceImpl implements DwgDeployHisService {
	
	@Resource(name = "dwgDeployHisDAO")
	private DwgDeployHisDAO dwgDeployHisDAO;
	
	
}
