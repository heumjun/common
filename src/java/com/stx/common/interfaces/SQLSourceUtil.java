/**
 * 
 */
package com.stx.common.interfaces;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.stx.common.util.FrameworkUtil;
import com.stx.common.util.STXPLMProperty;
import com.stx.common.util.StringUtil;

import stxship.dis.common.util.DisMessageUtil;

/**
 * @author hispres
 *
 */
public class SQLSourceUtil extends DBConnect {
	/**
	 * 
	 */
	private static final String SQL_PARAM_PRE = "#";
	private static final String SQL_PARAM_POST = "#";
	private static final String SQL_FILE_EXTENSION = ".xml";
	private static final String ERP_DBLINK_PARAM = "STX_ERP_DBLINK";

	public SQLSourceUtil() {
		// TODO Auto-generated constructor stub
	}

	private static String getSQLFromDocument(Document doc, String sSQLId, Map mapCondition) throws Exception {
		String sSql = "";
		try {
			NodeList nlChildR = doc.getChildNodes();
			for (int indexR = 0; indexR < nlChildR.getLength(); indexR++) {
				Node ndRoot = nlChildR.item(indexR);
				NodeList nlChild = ndRoot.getChildNodes();
				for (int index = 0; index < nlChild.getLength(); index++) {
					Node ndChild = nlChild.item(index);
					String sNodeName = ndChild.getNodeName();
					if (sNodeName.equals(sSQLId)) {
						sSql = getSqlFromSqlNode(ndChild, mapCondition);
					}
				}
			}
		} catch (Exception e) {
			throw new Exception("The SQL XML is not correct definition");
		}
		return sSql;
	}

	private static String getSqlFromSqlNode(Node node, Map mapCondition) throws Exception {
		StringBuffer sbSql = new StringBuffer();
		NodeList nlChild2 = node.getChildNodes();
		for (int index = 0; index < nlChild2.getLength(); index++) {
			Node ndChilde2 = nlChild2.item(index);
			if (ndChilde2.getNodeType() == ndChilde2.CDATA_SECTION_NODE) {
				sbSql.append(ndChilde2.getNodeValue());
			}
			if (mapCondition != null) {
				if (ndChilde2.getNodeName().equals("notempty")) {
					Map mapAtt = getNodeAttToMap(ndChilde2);
					String sKey = (String) mapAtt.get("name");
					if (mapCondition.get(sKey) != null && !mapCondition.get(sKey).equals("")) {
						if (ndChilde2.getChildNodes() != null && ndChilde2.getChildNodes().item(0) != null) {
							sbSql.append(ndChilde2.getChildNodes().item(0).getNodeValue());
						}
					}
				}
			}
		}
		return sbSql.toString();
	}

	private static Map getNodeAttToMap(Node node) throws Exception {
		Map mapReturn = new HashMap();
		NamedNodeMap attNodeMap = node.getAttributes();
		for (int index = 0; index < attNodeMap.getLength(); index++) {
			Node attNode = attNodeMap.item(index);
			String sKey = attNode.getNodeName();
			String sValue = attNode.getNodeValue();
			mapReturn.put(sKey, sValue);
		}
		return mapReturn;
	}

	public static String getSQLFromXML(String sPath, Map mapParam)
			throws ParserConfigurationException, FileNotFoundException, IOException, SAXException, Exception {

		String sSql = "";

		ArrayList slPath = FrameworkUtil.split(sPath, ".");
		if (slPath.size() != 2) {
			throw new Exception("The SQL File Path is not correct");
		} else {

			String sXMLId = (String) slPath.get(0);
			String sSQLId = (String) slPath.get(1);
			/****
			 * String sXMLHome = "SQL/";
			 * 
			 * ClassLoader loader =
			 * Thread.currentThread().getContextClassLoader(); File file = new
			 * File(loader.getResource(sXMLHome + sXMLId+".xml").getFile());
			 ****/
			String sXMLHome = "/addOnXml/";
			/*File file = new File(sXMLHome + sXMLId + ".xml");*/

			/*String sFilePath = file.getAbsolutePath();*/
			/*System.out.println("~~~~~ sFilePath = " + sFilePath);*/

			DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			DocumentBuilder builder = factory.newDocumentBuilder();
			Document doc = builder.parse(new BufferedInputStream(Thread.currentThread().getContextClassLoader()
		            .getResourceAsStream(sXMLHome + sXMLId + ".xml")));
			sSql = getSQLFromDocument(doc, sSQLId, mapParam);
			sSql = replaceStaticPARAM(sSql);
		}
		return sSql;
	}

	private static String replaceStaticPARAM(String sSql) throws Exception {
		sSql = sSql.replaceAll(ERP_DBLINK_PARAM,DisMessageUtil.getMessage("PLM.ERP.DBLINK.NAME"));
				/*STXPLMProperty.getPLMProperty("stxEngineeringCentralItemStringResource", "PLM.ERP.DBLINK.NAME"));*/
		return sSql;
	}

	private static String replaceParamSQL(String sSql, Map ParamMap) throws Exception {
		if (ParamMap != null) {
			System.out.println(ParamMap);
			Iterator itrParam = ParamMap.keySet().iterator();
			while (itrParam.hasNext()) {
				String sKey = (String) itrParam.next();
				String sKeyTarget = SQL_PARAM_PRE + sKey + SQL_PARAM_POST;
				Object objValue = ParamMap.get(sKey);
				if (objValue == null) {
				} else if (objValue instanceof String) {
					String sValue = (String) objValue;
					sSql = sSql.replaceAll(sKeyTarget, "'" + sValue + "'");
				} else if (objValue instanceof Date) {

				} else if (objValue instanceof Integer) {
					String sValue = (String) objValue;
					sSql = sSql.replaceAll(sKeyTarget, sValue);
				} else {
					throw new Exception(
							"There is unsupported param by SQLUtil when execute select statement! (Supported Param is only String,int,date)");
				}
			}
		}
		System.out.println(sSql);
		return sSql;
	}

	public static void executeUpdate(String sDBName, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		Connection conn = null;
		try {
			conn = DBConnect.getDBConnection(sDBName);
			DBConnect.disableAutoCommit(conn);
			executeUpdate(conn, sSqlId, ParamMap, listInput);
			DBConnect.commitJDBCTransaction(conn);
		} catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			throw e;
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static void executeUpdate(Connection conn, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		PreparedStatement pstmt = null;
		try {
			System.out.println("***************" + sSqlId + "***************");
			pstmt = conn.prepareStatement(getSQLFromXML(sSqlId, ParamMap));

			for (int index = 0; index < listInput.size(); index++) {
				Object objParam = listInput.get(index);

				if (objParam == null) {
					throw new Exception("There is null Param when execute select statement!");
				} else if (objParam instanceof String) {
					pstmt.setString(index + 1, (String) objParam);
				} else if (objParam instanceof Date) {
					pstmt.setDate(index + 1, (Date) objParam);
				} else if (objParam instanceof Integer) {
					pstmt.setInt(index + 1, Integer.parseInt((String) objParam));
					;
				} else {
					throw new Exception(
							"There is unsupported param by SQLUtil when execute select statement! (Supported Param is only String,int,date)");
				}
			}
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	public static void executeUpdate(String sDBName, String sSqlId, Map ParamMap) throws Exception {
		Connection conn = null;
		try {
			conn = DBConnect.getDBConnection(sDBName);
			DBConnect.disableAutoCommit(conn);
			executeUpdate(conn, sSqlId, ParamMap);
			DBConnect.commitJDBCTransaction(conn);
		} catch (Exception e) {
			DBConnect.rollbackJDBCTransaction(conn);
			throw e;
		} finally {
			if (conn != null)
				conn.close();
		}
	}

	public static void executeUpdate(Connection conn, String sSqlId, Map ParamMap) throws Exception {
		PreparedStatement pstmt = null;
		try {
			String sSql = getSQLFromXML(sSqlId, ParamMap);
			System.out.println("***************" + sSqlId + "***************");
			pstmt = conn.prepareStatement(replaceParamSQL(sSql, ParamMap));
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (pstmt != null) {
				pstmt.close();
			}
		}
	}

	public static Map executeSelectSingle(String sDBName, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		Map mapReturn = new HashMap();
		ArrayList mlReturn = executeSelect(sDBName, sSqlId, ParamMap, listInput);
		if (mlReturn.size() > 0) {
			mapReturn = (Map) mlReturn.get(0);
		}
		return mapReturn;
	}

	public static Map executeSelectSingle(Connection conn, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		Map mapReturn = new HashMap();
		ArrayList mlReturn = executeSelect(conn, sSqlId, ParamMap, listInput);
		if (mlReturn.size() > 0) {
			mapReturn = (Map) mlReturn.get(0);
		}
		return mapReturn;
	}

	public static ArrayList executeSelect(String sDBName, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		ArrayList returnList = new ArrayList();
		Connection conn = null;
		try {
			conn = DBConnect.getDBConnection(sDBName);
			returnList = executeSelect(conn, sSqlId, ParamMap, listInput);
		} catch (Exception e) {
			throw e;
		} finally {
			if (conn != null)
				conn.close();
		}
		return returnList;
	}

	public static ArrayList executeSelect(Connection conn, String sSqlId, Map ParamMap, ArrayList listInput)
			throws Exception {
		ArrayList returnList = new ArrayList();
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			pstmt = conn.prepareStatement(getSQLFromXML(sSqlId, ParamMap));

			for (int index = 0; index < listInput.size(); index++) {
				Object objParam = listInput.get(index);

				if (objParam == null) {
					throw new Exception("There is null Param when execute select statement!");
				} else if (objParam instanceof String) {
					pstmt.setString(index + 1, (String) objParam);
				} else if (objParam instanceof Date) {
					pstmt.setDate(index + 1, (Date) objParam);
				} else if (objParam instanceof Integer) {
					pstmt.setInt(index + 1, Integer.parseInt((String) objParam));
					;
				} else {
					throw new Exception(
							"There is unsupported param by SQLUtil when execute select statement! (Supported Param is only String,int,date)");
				}
			}
			rset = pstmt.executeQuery();
			returnList = getResultMapRows(rset);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (rset != null) {
				rset.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
		}
		return returnList;
	}

	public static Map executeSelectSingle(String sDBName, String sSqlId, Map ParamMap) throws Exception {
		Map mapReturn = new HashMap();
		ArrayList mlReturn = executeSelect(sDBName, sSqlId, ParamMap);
		if (mlReturn.size() > 0) {
			mapReturn = (Map) mlReturn.get(0);
		}
		return mapReturn;
	}

	public static Map executeSelectSingle(Connection conn, String sSqlId, Map ParamMap) throws Exception {
		Map mapReturn = new HashMap();
		ArrayList mlReturn = executeSelect(conn, sSqlId, ParamMap);
		if (mlReturn.size() > 0) {
			mapReturn = (Map) mlReturn.get(0);
		}
		return mapReturn;
	}

	public static ArrayList executeSelect(String sDBName, String sSqlId, Map ParamMap) throws Exception {
		ArrayList returnList = new ArrayList();
		Connection conn = null;
		System.out.println("ParamMap : " + ParamMap);
		try {
			conn = DBConnect.getDBConnection(sDBName);
			returnList = executeSelect(conn, sSqlId, ParamMap);
		} catch (Exception e) {
			throw e;
		} finally {
			if (conn != null)
				conn.close();
		}
		return returnList;
	}

	public static ArrayList executeSelect(Connection conn, String sSqlId, Map ParamMap) throws Exception {
		ArrayList returnList = new ArrayList();
		PreparedStatement pstmt = null;
		ResultSet rset = null;
		try {
			String sSql = getSQLFromXML(sSqlId, ParamMap);
			System.out.println("*************** " + sSqlId + " *****************");
			sSql = replaceParamSQL(sSql, ParamMap);
			pstmt = conn.prepareStatement(sSql);
			rset = pstmt.executeQuery();
			returnList = getResultMapRows(rset);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			if (rset != null) {
				rset.close();
			}
			if (pstmt != null) {
				pstmt.close();
			}
		}
		return returnList;
	}

	private static ArrayList getResultMapRows(ResultSet rs) throws Exception {
		ArrayList mlReturn = new ArrayList();
		ResultSetMetaData metaData = rs.getMetaData();
		while (rs.next()) {
			HashMap mapReturn = new HashMap();
			for (int index = 0; index < metaData.getColumnCount(); index++) {
				String sColumnName = metaData.getColumnName(index + 1);
				mapReturn.put(StringUtil.setEmpty(sColumnName), StringUtil.setEmpty(rs.getString(sColumnName)));
			}
			mlReturn.add(mapReturn);
		}
		return mlReturn;
	}

	public static String getXMLResultFromArrayList(ArrayList mlList) throws Exception {
		String sReturn = "";
		if (mlList.size() > 0) {
			org.jdom.output.XMLOutputter outputter = new org.jdom.output.XMLOutputter();
			org.jdom.Document outDocument = new org.jdom.Document();

			org.jdom.Element root = new org.jdom.Element("RESULT");
			outDocument.setRootElement(root);

			for (int i = 0; mlList != null && i < mlList.size(); i++) {
				org.jdom.Element elResult = new org.jdom.Element("RESULTRECORD");
				Map mapResult = (Map) mlList.get(i);
				getSimpleElementFromMap(elResult, mapResult);
				root.addContent(elResult);
			}
			sReturn = outputter.outputString(outDocument);
		}
		return sReturn;
	}

	public static String genXMLFromMap(Map mapInput) throws Exception {
		org.jdom.output.XMLOutputter outputter = new org.jdom.output.XMLOutputter();
		org.jdom.Document outDocument = new org.jdom.Document();
		org.jdom.Element root = new org.jdom.Element("RESULT");
		outDocument.setRootElement(root);
		getSimpleElementFromMap(root, mapInput);
		return outputter.outputString(outDocument);
	}

	public static org.jdom.Element getSimpleElementFromMap(org.jdom.Element elParent, Map mapInput) throws Exception {
		Iterator itrKey = mapInput.keySet().iterator();
		while (itrKey.hasNext()) {

			String sKey = (String) itrKey.next();
			String sValue = (String) mapInput.get(sKey);
			org.jdom.Element elReturn = new org.jdom.Element(sKey);
			elReturn.addContent(sValue);
			elParent.addContent(elReturn);
		}
		return elParent;
	}

}
