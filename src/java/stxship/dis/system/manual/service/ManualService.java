package stxship.dis.system.manual.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface ManualService extends CommonService {

	View manualFileDownload(CommandMap commandMap, Map<String, Object> modelMap);

	Map<String, Object> manualAddSave(HttpServletResponse response, HttpServletRequest request, CommandMap commandMap) throws Exception;

	Map<String, String> manualFileDelete(CommandMap commandMap) throws Exception;

}
