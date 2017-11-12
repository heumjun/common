package stxship.dis.paint.usc.service;

import java.util.Map;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface PaintUscService extends CommonService {

	Map<String, String> insertPaintWbsReCreate(CommandMap commandMap) throws Exception;

	Map<String, String> deletePaintUsc(CommandMap commandMap) throws Exception;

	Map<String, String> savePaintUscJobItemCreate(CommandMap commandMap) throws Exception;

	Map<String, String> savePaintUscBom(CommandMap commandMap) throws Exception;

	Map<String, String> savePaintWbsEcoAdd(CommandMap commandMap) throws Exception;
}
