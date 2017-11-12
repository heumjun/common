package stxship.dis.paint.afvolume.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintAfvolumeService extends CommonService {

	Map<String, String> savePaintAfvolume(CommandMap commandMap) throws Exception;

}
