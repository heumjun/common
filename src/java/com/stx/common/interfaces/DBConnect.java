/**
 * <pre>
 * 프로젝트명 : STX 기술로 프로젝트 PLM 구축
 * 시스템명 : Interface
 * 버젼 : 1.0
 * 작성자 : 한규석
 * 작성일자 : 2005/04/13
 * </pre>
 * 기능 : ERP Interface Class
 * @version 1.0
 */

package com.stx.common.interfaces;

import java.io.IOException;
//import com.matrixone.framework.util.*;
//import matrix.db.*;
//import matrix.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import stxship.dis.common.util.DisMessageUtil;

//import oracle.jdbc.driver.*;

public class DBConnect {

	private static Connection getDBConnection(String nmDriver, String nmUrl, String nmUser, String nmPassword)
			throws Exception {
		Connection connection = null;
		try {
			// Load the JDBC driver
			Class.forName(nmDriver);

			// Create a connection to the database
			connection = DriverManager.getConnection(nmUrl, nmUser, nmPassword);
		} catch (ClassNotFoundException e) {
			throw new Exception("!!!!!!!! Could not find the database driver");
		} catch (SQLException e) {
			throw new Exception("!!!!!!!! Could not connect to the database");
		}

		return connection;
	}

	public static void disableAutoCommit(Connection conn) throws Exception {
		try {
			conn.setAutoCommit(false);
		} catch (SQLException e) {
			throw e;
		}
	}

	public static void enableAutoCommit(Connection conn) throws Exception {
		try {
			conn.setAutoCommit(true);
		} catch (SQLException e) {
			throw e;
		}
	}

	public static void closeConnection(Connection conn) throws Exception {
		try {
			if (conn != null && !conn.isClosed()) {
				conn.close();
			}
		} catch (SQLException e) {
			throw e;
		}
	}

	/////////////////
	public static void commitJDBCTransaction(Connection conn) throws Exception {
		try {
			conn.commit();
		} catch (SQLException e) {
			throw e;
		}
	} // end commitJDBCTransaction()

	////////////////////
	public static void rollbackJDBCTransaction(Connection conn) throws Exception {
		try {
			conn.rollback();
		} catch (SQLException e) {
			throw e;
		}
	}

	/*private static Properties getJDBCPropFile() throws IOException, ClassNotFoundException {
		// 프로퍼티 객체 생성
		Properties prop = new Properties();
		try {
			// 읽을 property 파일 절대 경로..
			String propFile = "C:/DIS_PROPERTIES/jdbc_connect.properties";

			// 프로퍼티 파일 스트림에 담기
			FileInputStream fis = new FileInputStream(propFile);
			// 프로퍼티 파일 로딩
			prop.load(new java.io.BufferedInputStream(fis));
			fis.close();

		} catch (Exception ee) {
			ee.printStackTrace();
			System.out.println("ERROR :: DBConnect - getJDBCPropFile");
		}
		return prop;
	}*/

	public static Connection getDBConnection(String sSystem) throws IOException, Exception {
		String nmDriver, nmUrl, nmUser, nmPassword;
		Connection retCon;

		//Properties p = null;

		//p = getJDBCPropFile();
		// p.list( System.out );
		nmDriver = DisMessageUtil.getMessage(sSystem + ".driver");
		nmUrl = DisMessageUtil.getMessage(sSystem + ".url");
		nmUser = DisMessageUtil.getMessage(sSystem + ".user");
		nmPassword = DisMessageUtil.getMessage(sSystem + ".password");

		/*
		 * nmDriver = p.getProperty( sSystem + ".driver" ); nmUrl =
		 * p.getProperty( sSystem + ".url" ); nmUser = p.getProperty( sSystem +
		 * ".user" ); nmPassword = p.getProperty( sSystem + ".password" );
		 */

		// System.out.println("nmDriver===>"+nmDriver+"<br>");
		// System.out.println("nmUrl===>"+nmUrl+"<br>");
		// System.out.println("nmUser===>"+nmUser+"<br>");
		// System.out.println("nmPassword===>"+nmPassword+"<br>");

		retCon = getDBConnection(nmDriver, nmUrl, nmUser, nmPassword);
		// disable autocommit
		disableAutoCommit(retCon);
		return retCon;
	}
}
