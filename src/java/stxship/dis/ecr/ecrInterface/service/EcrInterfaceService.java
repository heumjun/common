package stxship.dis.ecr.ecrInterface.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;

public interface EcrInterfaceService {
	
	public Map<String, Object> getEcrInterfaceList( CommandMap commandMap );
	
	public Map<String, Object> saveECRInterface01( CommandMap commandMap ) throws Exception;
	
	public Map<String, Object> saveECRInterface02( CommandMap commandMap ) throws Exception;
}
