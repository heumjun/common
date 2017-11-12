package com.stx.common.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import com.stx.common.interfaces.DBConnect;
import com.stx.common.library.DataBox;
import com.stx.common.library.ListSet;

public class TBCCommonValidation implements TBCCommonDataBaseInterface
{
	/**
	 * 상위 구조의 Mother Code를 받아온다.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_block
	 * @param p_stage
	 * @param p_str
	 * @return MotherCode
	 * @throws Exception
	 */
	public String getMotherCode(String p_project, String p_dwgno, String p_block, String p_stage, String p_str) throws Exception {
		
		//다른 프로젝트에 같은 Circuit이 있는지 판단.
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		String v_mother_code = "";
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        { 
    		query.append("SELECT MOTHER_CODE \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
    		if(!p_stage.equals("")){
    			query.append("   AND STAGE_NO = '"+p_stage+"' \n");
    		}else{
    			query.append("   AND STAGE_NO IS NULL \n");
    		}
    		if(!p_str.equals("")){
    			query.append("   AND STR_FLAG = '"+p_str+"' \n");
    		}else{
    			//query.append("   AND STR_FLAG IS NULL \n");
    		}
//    		System.out.println(query);
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	v_mother_code = ls.getString(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return v_mother_code;
	}
	/**
	 * 상위 구조의 Mother Code를 받아온다.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_block
	 * @param p_stage
	 * @param p_str
	 * @return MotherCode
	 * @throws Exception
	 */
	public ArrayList getMotherCodeList(String p_project, String p_dwgno, String p_block, String p_stage, String p_str) throws Exception {
		
		//다른 프로젝트에 같은 Circuit이 있는지 판단.
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		ArrayList ar_mother_code = new ArrayList();
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        { 
    		query.append("SELECT MOTHER_CODE \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
    		if(!p_stage.equals("")){
    			query.append("   AND STAGE_NO = '"+p_stage+"' \n");
    		}else{
    			query.append("   AND STAGE_NO IS NULL \n");
    		}
    		if(!p_str.equals("")){
    			query.append("   AND STR_FLAG = '"+p_str+"' \n");
    		}else{
    			//query.append("   AND STR_FLAG IS NULL \n");
    		}
//    		System.out.println(query);
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            while ( ls.next() ){
            	ar_mother_code.add(ls.getString(1));
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return ar_mother_code;
	}
	
	/**
	 * 상위 구조의 Job Code를 받아온다.
	 * @param p_mother_code
	 * @return MotherCode
	 * @throws Exception
	 */
	 
	public String getJobCode(String p_mother_code) throws Exception {
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		String v_mother_code = "";
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        { 
    		query.append("SELECT JOB_CD \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE MOTHER_CODE = '"+p_mother_code+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	v_mother_code = ls.getString(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return v_mother_code;
	}
	/**
	 * 상위 구조의 Block Code를 받아온다.
	 * @param p_job_code
	 * @return BlockCode
	 * @throws Exception
	 */
	 
	public String getBlockCode(String p_job_code) throws Exception {
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		String v_mother_code = "";
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        { 
    		query.append("SELECT STAC.BLOCK_DIV_CD \n");
    		query.append("  FROM STX_DIS_JOB_CONFIRM      STJC \n");
    		query.append("      ,STX_DIS_ACTIVITY_CONFIRM STAC \n");
    		query.append(" WHERE (CASE WHEN STJC.JOB_CD2 IS NOT NULL THEN STJC.JOB_CD2 ELSE STJC.JOB_CD1 END)  = '"+p_job_code+"' \n");
    		query.append("   AND STAC.ACTIVITY_CD                                                              = STJC.ACTIVITY_CD \n");           


			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	v_mother_code = ls.getString(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return v_mother_code;
	}
	/**
	 * 상위구조의 BLOCK 이 존재하는지 판단.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_block
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsBlock(String p_project, String p_dwgno, String p_block) throws Exception {
		
		//상위정보에 Block이 있는지 없는지 판단.
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS ISCNT \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * 상위구조의 STR 이 존재하는지 판단.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_block
	 * @param p_str
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsStr(String p_project, String p_dwgno, String p_block ,String p_str) throws Exception {
		
//		상위정보에 Str이 있는지 없는지 판단.
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS ISCNT \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
    		query.append("   AND STR_FLAG = '"+p_str+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * 상위구조의 Stage가 존재하는지 판단.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_block
	 * @param p_stage
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsStage(String p_project, String p_dwgno, String p_block, String p_stage) throws Exception {
		
		//상위정보에 Str이 있는지 없는지 판단.
	
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {	
    		query.append("SELECT COUNT(*) AS ISCNT \n");
    		query.append("  FROM STX_DIS_PENDING A \n");
    		query.append(" WHERE PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND BLOCK_NO = '"+p_block+"' \n");
    		query.append("   AND STAGE_NO = '"+p_stage+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }
            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * Support No 중복을 체크한다.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_mother_code
	 * @param p_block_no
	 * @return MotherCode
	 * @throws Exception
	 */
	 
	public int isSupportNo(String p_project, String p_mother_code, String p_dwgno, String p_block_no) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		int rtn = 0;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		//기존 Block by 의 SUPNO를 구해 - 새로 변경할 Block by의 SUPNO를 비교/  
    		
    		query.append("SELECT COUNT(*) \n");
    		query.append("  FROM STX_DIS_SSC_HEAD A \n");
    		query.append(" INNER JOIN STX_DIS_ITEM B ON A.ITEM_CODE = B.ITEM_CODE \n");
    		query.append(" WHERE A.PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND A.DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND A.ITEM_TYPE_CD = 'SU' \n");
    		query.append("   AND A.MOTHER_CODE = '"+p_mother_code+"' \n");
    		query.append("   AND A.BLOCK_NO = '"+p_block_no+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	rtn = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Support No 중복을 체크한다.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_mother_code
	 * @param p_block_no
	 * @return MotherCode
	 * @throws Exception
	 */
	 
	public int isSeatNo(String p_project, String p_mother_code, String p_dwgno, String p_block_no, String p_seat_no) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		int rtn = 0;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		//기존 Block by 의 Seat를  구해 - 새로 변경할 Block by의 Seat를 비교/  
    		
    		query.append("SELECT COUNT(*) \n");
    		query.append("  FROM STX_DIS_SSC_HEAD A \n");
    		query.append(" INNER JOIN STX_DIS_ITEM B ON A.ITEM_CODE = B.ITEM_CODE \n");
    		query.append(" WHERE A.PROJECT_NO = '"+p_project+"' \n");
    		query.append("   AND A.DWG_NO = '"+p_dwgno+"' \n");
    		query.append("   AND A.ITEM_TYPE_CD = 'SE' \n");
    		query.append("   AND A.MOTHER_CODE = '"+p_mother_code+"' \n");
    		query.append("   AND A.BLOCK_NO = '"+p_block_no+"' \n");
    		query.append("   AND B.ATTR1 = '"+p_seat_no+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	rtn = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Peding Stage No 중복을 체크한다.
	 * @param p_project
	 * @param p_dwgno
	 * @param p_mother_code
	 * @param p_block_no
	 * @return MotherCode
	 * @throws Exception
	 */
	 
	public int isPendingWork(String p_job_code, String p_dwg_no, String p_stage_no) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		int rtn = 0;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS CNT \n");
    		query.append("  FROM STX_DIS_PENDING_WORK \n");
    		query.append(" WHERE JOB_CD = '"+p_job_code+"' \n");
    		query.append("   AND DWG_NO = '"+p_dwg_no+"' \n");
    		query.append("   AND STAGE_NO = '"+p_stage_no+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	rtn = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * ItemCode가 동일 부모 밑에 있는지 판단
	 * @param p_mother_code
	 * @param p_item_code
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsItemCode(String p_mother_code, String p_item_code) throws Exception {
		
//		상위정보에 Str이 있는지 없는지 판단.
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS ISCNT \n");
    		query.append("  FROM STX_DIS_SSC_HEAD A \n");
    		query.append(" WHERE MOTHER_CODE = '"+p_mother_code+"' \n");
    		query.append("   AND ITEM_CODE = '"+p_item_code+"' \n");
    		query.append("   AND NOT (STATE_FLAG = 'D' AND ECO_NO IS NOT NULL) \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = false;
                }else{
               	 	rtn = true;
                }
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * ItemCode와 Key No 가 동일 부모 밑에 있는지 판단
	 * @param p_mother_code
	 * @param p_item_code
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsItemCodeAndKey(String p_mother_code, String p_item_code, String p_key_no) throws Exception {
		
//		상위정보에 Str이 있는지 없는지 판단.
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS ISCNT \n");
    		query.append("  FROM STX_DIS_SSC_HEAD A \n");
    		query.append(" WHERE MOTHER_CODE = '"+p_mother_code+"' \n");
    		query.append("   AND ITEM_CODE = '"+p_item_code+"' \n");
    		query.append("   AND KEY_NO = '"+p_key_no+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = false;
                }else{
               	 	rtn = true;
                }
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * Catalog별 AttrBute Name을 받아온다.
	 * @param p_catalog
	 * @param p_attr_name
	 * @return Attr_code
	 * @throws Exception
	 */
	 
	public int getCatalogAttrCode(String p_catalog, String p_attr_name) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		int attrCode = 0;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT CASE \n");
    		query.append("         WHEN SUBSTR(A.ATTRIBUTE_CODE, 0, 1) = 0 THEN REPLACE(A.ATTRIBUTE_CODE, 0) \n");
    		query.append("         ELSE A.ATTRIBUTE_CODE \n");
    		query.append("       END ATTRBUTE_CODE \n");
    		query.append("  FROM STX_STD_SD_CATALOG_ATTRIBUTE@"+ERP_DB+" A \n");
    		query.append(" WHERE A.ATTRIBUTE_TYPE = 'ITEM' \n");
    		query.append("   AND A.CATALOG_CODE = '"+p_catalog+"' \n");
    		if(p_attr_name.equals("MATERIAL")){
    			query.append("   AND (A.ATTRIBUTE_NAME = '"+p_attr_name+"' OR A.ATTRIBUTE_NAME = '"+p_attr_name+"1' OR A.ATTRIBUTE_NAME = '"+p_attr_name+"2') \n");
    		}else{
    			query.append("   AND A.ATTRIBUTE_NAME = '"+p_attr_name+"' \n");
    		}
    		query.append("ORDER BY A.ATTRIBUTE_NAME ASC \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	attrCode = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return attrCode;
	}
	
	/**
	 * Catalog 관리의 Tray_EA가 N이면 : True : Tray 미체크
	 * @param p_catalog
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsTrayEaType(String p_catalog) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = true;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS CNT \n");
    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
    		query.append("   AND SCV.VALUE_CODE  = '05' \n");
    		query.append("   AND SCV.VALUE_NAME  = 'N' \n");
    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
    		query.append("   AND CATALOG_CODE = '"+p_catalog+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Category 관리의 Valve가 Y이면 : True 
	 * @param p_catalog
	 * @return boolean
	 * @throws Exception
	 */
	public String getIsValveType(String p_catalog) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		String rtn = "";
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT VALUE_NAME \n");
    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
    		query.append("   AND SCV.VALUE_CODE  = '06' \n");
    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
    		query.append("   AND CATALOG_CODE = '"+p_catalog+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	rtn = ls.getString(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Category 관리의 L-Valve Y이면 
	 * @param p_catalog
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getIsLValveType(String p_catalog) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = false;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT COUNT(*) AS CNT \n");
    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
    		query.append("   AND SCV.VALUE_CODE  = '08' \n");
    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
    		query.append("   AND SCV.VALUE_NAME  = 'Y' \n");
    		query.append("   AND CATALOG_CODE = '"+p_catalog+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	if(ls.getInt(1) > 0){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }
            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Category 관리의 Paint Code가 Y일 경우 로직 수행.
	 * @param p_catalog
	 * @return boolean
	 * @throws Exception
	 */
	public String getIsPaintCodeType(String p_catalog) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		String rtn = "";
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT VALUE_NAME \n");
    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
    		query.append("   AND SCV.VALUE_CODE  = '07' \n");
    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
    		query.append("   AND CATALOG_CODE = '"+p_catalog+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	rtn = ls.getString(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * Category 관리의 Paint ATTR 번호 받아옴.
	 * @param p_catalog
	 * @return boolean
	 * @throws Exception
	 */
	public int getPaintAttrNo(String p_catalog) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		int rtn = 0;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		
    		query.append("SELECT VALUE_NAME \n");
    		query.append("  FROM STX_STD_SD_CATALOG_VALUE@"+ERP_DB+" SCV \n");
    		query.append(" WHERE SCV.VALUE_TYPE  = 'CATALOG_DESIGN' \n");
    		query.append("   AND SCV.VALUE_CODE  = '09' \n");
    		query.append("   AND SCV.ENABLE_FLAG = 'Y' \n");
    		query.append("   AND CATALOG_CODE = '"+p_catalog+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
            if ( ls.next() ){
            	rtn = ls.getInt(1);
            }
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	
	/**
	 * Raw 정보 Return
	 * @param p_item_code
	 * @return boolean
	 * @throws Exception
	 */
	public ArrayList getRawItemInfo(String p_item_code) throws Exception {
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox 			dbox 		= null;
    	ArrayList			list 		= new ArrayList();
    	try 
        { 
    		query.append("SELECT  STI.ITEM_CODE \n");
    		query.append("      , STI.ATTR1 \n");
    		query.append("      , STI.ATTR2 \n");
    		query.append("      , STI.ATTR3 \n");
    		query.append("      , STI.ATTR4 \n");
    		query.append("      , STI.ATTR5 \n");
    		query.append("      , STI.ATTR6 \n");
    		query.append("      , STI.ATTR7 \n");
    		query.append("      , STI.ATTR8 \n");
    		query.append("      , STI.ATTR9 \n");
    		query.append("      , STI.ATTR10 \n");
    		query.append("      , STI.ATTR11 \n");
    		query.append("      , STI.ATTR12 \n");
    		query.append("      , STI.ATTR13 \n");
    		query.append("      , STI.ATTR14 \n");
    		query.append("      , STI.ATTR15 \n");
    		query.append("      , STI.ITEM_WEIGHT \n");
    		query.append("  FROM STX_DIS_RAWLEVEL STR \n");
    		query.append("  INNER JOIN STX_DIS_ITEM STI ON STR.ITEM_CODE = STI.ITEM_CODE \n");
    		query.append(" WHERE MOTHER_CODE = '"+p_item_code+"' \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            while( ls.next() ){ 
            	dbox = ls.getDataBox();
            	list.add(dbox);
            }
            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return list;
	}
	
	/**
	 * Pending 상위 정보 변경 
	 * @param p_mother_code
	 * @return boolean
	 * @throws Exception
	 */
	public boolean getUppChangeFlag(String p_mother_code, String p_item_code) throws Exception {
		
		Connection plmConn     = null;
		plmConn = DBConnect.getDBConnection("PLM");
		
		boolean rtn = false;
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	
    	try 
        {
    		query.append("SELECT STP.USC_CHG_FLAG \n");
    		query.append("  FROM STX_DIS_PENDING STP \n");
    		query.append(" INNER JOIN STX_DIS_SSC_HEAD STSH ON STP.MOTHER_CODE = STSH.MOTHER_CODE \n");
    		query.append(" WHERE STP.MOTHER_CODE = ? \n");
    		query.append("   AND STSH.ITEM_CODE = ? \n");
    		query.append("   AND (STP.USC_CHG_DATE > STSH.UPP_CONFIRM_DATE OR STSH.UPP_CONFIRM_DATE IS NULL) \n");
    		
			pstmt = plmConn.prepareStatement(query.toString());
			pstmt.setString(1, p_mother_code);
			pstmt.setString(2, p_item_code);
			
            ls = new ListSet(plmConn);
		    ls.run(pstmt);
		    
            if ( ls.next() ){
            	if(ls.getString(1).equals("Y")){
           		 	rtn = true;
                }else{
               	 	rtn = false;
                }
            }
            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
            if ( plmConn != null ) { try { plmConn.close(); } catch ( Exception e ) { } }
        }
        return rtn;
	}
	/**
	 * Item 정보 출력
	 * @param p_item_code
	 * @return boolean
	 * @throws Exception
	 */
	public ArrayList getTempItemInfo(Connection conn, String p_item_code) throws Exception {
		
		ListSet             ls      	= null;
        PreparedStatement 	pstmt 		= null;
    	StringBuffer		query   	= new StringBuffer();
    	DataBox 			dbox 		= null;
    	ArrayList			list 		= new ArrayList();
    	try 
        { 
    		query.append("SELECT  STI.ITEM_CODE \n");
    		query.append("      , STI.ATTR1 \n");
    		query.append("      , STI.ATTR2 \n");
    		query.append("      , STI.ATTR3 \n");
    		query.append("      , STI.ATTR4 \n");
    		query.append("      , STI.ATTR5 \n");
    		query.append("      , STI.ATTR6 \n");
    		query.append("      , STI.ATTR7 \n");
    		query.append("      , STI.ATTR8 \n");
    		query.append("      , STI.ATTR9 \n");
    		query.append("      , STI.ATTR10 \n");
    		query.append("      , STI.ATTR11 \n");
    		query.append("      , STI.ATTR12 \n");
    		query.append("      , STI.ATTR13 \n");
    		query.append("      , STI.ATTR14 \n");
    		query.append("      , STI.ATTR15 \n");
    		query.append("      , STI.ITEM_WEIGHT \n");
    		query.append("  FROM STX_DIS_ITEM STI\n");
    		query.append(" WHERE ITEM_CODE = '"+p_item_code+"' \n");
    		
			pstmt = conn.prepareStatement(query.toString());
			
            ls = new ListSet(conn);
		    ls.run(pstmt);
		    
            while( ls.next() ){ 
            	dbox = ls.getDataBox();
            	list.add(dbox);
            }
            
        }
        catch ( Exception ex ) 
        { 
        	ex.printStackTrace();
        }
        finally 
        { 
            if ( ls != null ) { try { ls.close(); } catch ( Exception e ) { } }
            if ( pstmt != null ) { try { pstmt.close(); } catch ( Exception e ) { } }
        }
        return list;
	}
}
