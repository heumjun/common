package stxship.dis.buyerClass.buyerClassProjectMgnt.service;

import java.sql.Connection;
import java.sql.Statement;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.stx.common.interfaces.DBConnect;

import stxship.dis.buyerClass.buyerClassProjectMgnt.dao.BuyerClassProjectMgntDAO;
import stxship.dis.common.command.CommandMap;
import stxship.dis.common.constants.DisConstants;
import stxship.dis.common.service.CommonServiceImpl;
import stxship.dis.common.util.DisMessageUtil;
import stxship.dis.common.util.DisStringUtil;

/**
 * @파일명 : BuyerClassProjectMgntServiceImpl.java
 * @프로젝트 : DIS
 * @날짜 : 2015. 12. 3.
 * @작성자 : 황경호
 * @설명
 * 
 * 	<pre>
 * BuyerClassProjectMgnt에서 사용되는 서비스
 *     </pre>
 */
@Service("buyerClassProjectMgntService")
public class BuyerClassProjectMgntServiceImpl extends CommonServiceImpl implements BuyerClassProjectMgntService {

	@Resource(name = "buyerClassProjectMgntDAO")
	private BuyerClassProjectMgntDAO buyerClassProjectMgntDAO;

	@Override
	public Map<String, String> buyerClassProjectMgntProcess(CommandMap commandMap) throws Exception {
		String project 			= DisStringUtil.nullString(commandMap.get("project"));
		String drawingType 		= DisStringUtil.nullString(commandMap.get("drawingType"));
		String refType 			= DisStringUtil.nullString(commandMap.get("refType"));
		String workRank 		= DisStringUtil.nullString(commandMap.get("workRank"));
		String mailList			= DisStringUtil.nullString(commandMap.get("mailList"));
		String position			= DisStringUtil.nullString(commandMap.get("position"));
		String companyName		= DisStringUtil.nullString(commandMap.get("companyName"));
		String address			= DisStringUtil.nullString(commandMap.get("address"));
		String faxNum			= DisStringUtil.nullString(commandMap.get("faxNum"));
		String eMailAddr		= DisStringUtil.nullString(commandMap.get("eMailAddr"));
		String phoneNum			= DisStringUtil.nullString(commandMap.get("phoneNum"));
		String mailListFlag		= DisStringUtil.nullString(commandMap.get("mailListFlag"));
		String companyNameFlag	= DisStringUtil.nullString(commandMap.get("companyNameFlag"));
		String addressFlag		= DisStringUtil.nullString(commandMap.get("addressFlag"));
		String faxNumFlag		= DisStringUtil.nullString(commandMap.get("faxNumFlag"));
		String department		= DisStringUtil.nullString(commandMap.get("department"));
		String refBasis			= DisStringUtil.nullString(commandMap.get("refBasis"));
		String processType		= DisStringUtil.nullString(commandMap.get("processType"));
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		conn.setAutoCommit(false);
		
		if("add".equals(processType)){
			//project , drawingType , refType , workRank , mailList , position , companyName , address , faxNum , eMailAddr , phoneNum , mailListFlag , companyNameFlag , addressFlag , faxNumFlag , department , refBasis , processType
			StringBuffer updateSQL = new StringBuffer();
			updateSQL.append("update stx_oc_project_receive_list ");
			updateSQL.append("   set priority = priority + 1 ");
			updateSQL.append(" where project = '"+project+"' ");
			updateSQL.append("   and drawing_type = '"+drawingType+"' ");
			updateSQL.append("   and receive_type = '"+refType+"' ");
			updateSQL.append("   and priority >= '"+workRank+"' ");
			
			Statement stmt = conn.createStatement();
			stmt.executeQuery(updateSQL.toString());
			
			conn.commit();
			
			if(stmt!=null)
				stmt.close();
			
			StringBuffer insertSQL = new StringBuffer();
			insertSQL.append("insert into stx_oc_project_receive_list( ");
			insertSQL.append("       project, ");
			insertSQL.append("       drawing_type, ");
			insertSQL.append("       receive_type, ");
			insertSQL.append("       priority, ");
			insertSQL.append("       receiver, ");
			insertSQL.append("       position, ");
			insertSQL.append("       company, ");
			insertSQL.append("       address, ");
			insertSQL.append("       fax, ");
			insertSQL.append("       email, ");
			insertSQL.append("       phone, ");
			insertSQL.append("       receiver_flag, ");
			insertSQL.append("       company_flag, ");
			insertSQL.append("       address_flag, ");
			insertSQL.append("       fax_flag, ");
			insertSQL.append("       department, ");
			insertSQL.append("       basis) ");
			insertSQL.append("values( ");
			insertSQL.append("       '"+project+"', ");
			insertSQL.append("       '"+drawingType+"', ");
			insertSQL.append("       '"+refType+"', ");
			insertSQL.append("       '"+workRank+"', ");
			insertSQL.append("       '"+mailList+"', ");
			insertSQL.append("       '"+position+"', ");
			insertSQL.append("       '"+companyName+"', ");
			insertSQL.append("       '"+address+"', ");
			insertSQL.append("       '"+faxNum+"', ");
			insertSQL.append("       '"+eMailAddr+"', ");
			insertSQL.append("       '"+phoneNum+"', ");
			insertSQL.append("       '"+mailListFlag+"', ");
			insertSQL.append("       '"+companyNameFlag+"', ");
			insertSQL.append("       '"+addressFlag+"', ");
			insertSQL.append("       '"+faxNumFlag+"', ");
			insertSQL.append("       '"+department+"', ");
			insertSQL.append("       '"+refBasis+"') ");
			
			Statement stmt2 = conn.createStatement();
			stmt2.executeQuery(insertSQL.toString());
			
			conn.commit();
			
			if(stmt2!=null)
				stmt2.close();
			if(conn!=null)
				conn.close();
		}else if("save".equals(processType)){
			StringBuffer selectSQL = new StringBuffer();
			selectSQL.append("update stx_oc_project_receive_list ");
			selectSQL.append("   set project = '"+project+"' , ");
			selectSQL.append("       drawing_type = '"+drawingType+"' , ");
			selectSQL.append("       receive_type = '"+refType+"' , ");
			selectSQL.append("       priority = '"+workRank+"' , ");
			selectSQL.append("       receiver = '"+mailList+"' , ");
			selectSQL.append("       position = '"+position+"' , ");
			selectSQL.append("       company = '"+companyName+"' , ");
			selectSQL.append("       address = '"+address+"' , ");
			selectSQL.append("       fax = '"+faxNum+"' , ");
			selectSQL.append("       email = '"+eMailAddr+"' , ");
			selectSQL.append("       phone = '"+phoneNum+"' , ");
			selectSQL.append("       receiver_flag = '"+mailListFlag+"' , ");
			selectSQL.append("       company_flag = '"+companyNameFlag+"' , ");
			selectSQL.append("       address_flag = '"+addressFlag+"' , ");
			selectSQL.append("       fax_flag = '"+faxNumFlag+"' , ");
			selectSQL.append("       department = '"+department+"' , ");
			selectSQL.append("       basis = '"+refBasis+"' ");
			selectSQL.append(" where project = '"+project+"' ");
			selectSQL.append("   and drawing_type = '"+drawingType+"' ");
			selectSQL.append("   and receive_type = '"+refType+"' ");
			selectSQL.append("   and receiver = '"+mailList+"' ");
			
			Statement stmt = conn.createStatement();
			stmt.executeQuery(selectSQL.toString());
			
			if(stmt!=null)
				stmt.close();
			if(conn!=null)
				conn.close();
		}else if("del".equals(processType)){
			StringBuffer deleteSQL = new StringBuffer();
			deleteSQL.append("delete ");
			deleteSQL.append("  from stx_oc_project_receive_list ");
			deleteSQL.append(" where project = '"+project+"'");
			deleteSQL.append("   and drawing_type = '"+drawingType+"'");
			deleteSQL.append("   and receive_type = '"+refType+"' ");
			deleteSQL.append("   and receiver = '"+mailList+"' ");
			
			Statement stmt = conn.createStatement();
			stmt.executeQuery(deleteSQL.toString());
			
			conn.commit();
			
			if(stmt!=null)
				stmt.close();
			
			StringBuffer updateSQL = new StringBuffer();
			updateSQL.append("update stx_oc_project_receive_list ");
			updateSQL.append("   set priority = priority - 1 ");
			updateSQL.append(" where project = '"+project+"' ");
			updateSQL.append("   and drawing_type = '"+drawingType+"' ");
			updateSQL.append("   and receive_type = '"+refType+"' ");
			updateSQL.append("   and priority >= '"+workRank+"' ");
			updateSQL.append("   and priority <> 0");
			
			Statement stmt2 = conn.createStatement();
			stmt2.executeQuery(updateSQL.toString());
			
			conn.commit();
			
			if(stmt2!=null)
				stmt2.close();
			if(conn!=null)
				conn.close();
		}
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}

	@Override
	public Map<String, String> buyerClassProjectUpdateProcess(CommandMap commandMap) throws Exception {
		String projectNo 		= DisStringUtil.nullString(commandMap.get("projectNo"));
		String docProjectNo 	= DisStringUtil.nullString(commandMap.get("docProjectNo"));
		String sendYN 			= DisStringUtil.nullString(commandMap.get("sendYN"));
		String ownerSendCount 	= DisStringUtil.nullString(commandMap.get("ownerSendCount"));
		String ownerReturnCount = DisStringUtil.nullString(commandMap.get("ownerReturnCount"));
		String classSendCount 	= DisStringUtil.nullString(commandMap.get("classSendCount"));
		String classReturnCount	= DisStringUtil.nullString(commandMap.get("classReturnCount"));
		
		//System.out.println("projectNo === "+projectNo);
		//System.out.println("docProjectNo === "+docProjectNo);
		//System.out.println("sendYN === "+sendYN);
		//System.out.println("ownerSendCount === "+ownerSendCount);
		//System.out.println("ownerReturnCount === "+ownerReturnCount);
		//System.out.println("classSendCount === "+classSendCount);
		//System.out.println("classReturnCount === "+classReturnCount);
		
		Connection conn = DBConnect.getDBConnection("SDPS");
		conn.setAutoCommit(false);
		
		StringBuffer deleteSQL = new StringBuffer();
		deleteSQL.append("delete ");
		deleteSQL.append("  from stx_oc_project_send_number ");
		deleteSQL.append(" where project = '"+projectNo+"'");
		
		Statement stmt = conn.createStatement();
		stmt.executeQuery(deleteSQL.toString());
		
		conn.commit();
		
		StringBuffer insertSQL = new StringBuffer();
		insertSQL.append("insert into stx_oc_project_send_number( ");
		insertSQL.append("       project , ");
		insertSQL.append("       doc_project , ");
		insertSQL.append("       send_flag , ");
		insertSQL.append("       owner_send_number , ");
		insertSQL.append("       owner_return_number , ");
		insertSQL.append("       class_send_number , ");
		insertSQL.append("       class_return_number )");
		insertSQL.append("values( ");
		insertSQL.append("       '"+projectNo+"', ");
		insertSQL.append("       '"+docProjectNo+"', ");
		insertSQL.append("       '"+sendYN+"', ");
		insertSQL.append("       '"+ownerSendCount+"', ");
		insertSQL.append("       '"+ownerReturnCount+"', ");
		insertSQL.append("       '"+classSendCount+"', ");
		insertSQL.append("       '"+classReturnCount+"') ");
		
		Statement stmt2 = conn.createStatement();
		stmt2.executeQuery(insertSQL.toString());
		
		conn.commit();
		
		if(stmt!=null)
			stmt.close();
		if(stmt2!=null)
			stmt2.close();
		if(conn!=null)
			conn.close();
		
		return DisMessageUtil.getResultMessage(DisConstants.RESULT_SUCCESS);
	}
	
}
