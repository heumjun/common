package stxship.dis.doc.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.View;

import stxship.dis.common.command.CommandMap;
import stxship.dis.common.service.CommonService;

public interface DocService extends CommonService {

	String saveDoc(HttpServletRequest request, CommandMap commandMap) throws Exception;

	Map<String, String> delDoc(HttpServletRequest request, CommandMap commandMap) throws Exception;

	View docDownloadFile(CommandMap commandMap, Map<String, Object> modelMap) throws Exception;
}
