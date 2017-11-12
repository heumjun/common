
package com.stx.common.library;

import java.io.Reader;
import java.io.StringWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

  /**
 * <p>����: ����Ÿ���̽��� ResultSet  ��ü�� �����ϴ� ���̺귯��</p>
 * <p>Copyright (c) 2004</p>
 *@author ����ȣ
 *@date 2013. 08
 *@version 1.0
 */
public class ListSet {
    private boolean b_bulletin = false;		// �Խ����������� ����
    
    private int block_size = 10;		// �� ������ ����������
    private int page_size = 10;		// ���������� ������ row ����
    private int total_row_count = 0;	// ������ ��ü row ����
    private int total_page_count = 0;	// ������ ��ü ������ ����
//    private int total_block_count = 0;// ������ ��ü ��������
    private int current_page_num = 0;		// ���� ������ ��ȣ
//    private int current_block_num = 0;	// ���� ���� ��ȣ
    private int current_page_last_row_num = 0;	// ���� �������� ������ ���� row ��ȣ
    private int current_row_num = 0;	// ���� ������ row ��ȣ
    
    private PreparedStatement pstmt = null;
    private Statement stmt = null;
    private ResultSet rs = null;
    
    private String sQuery = null;
    
    /** 
    *Connection ��ü���� Statement ��ü�� �����Ѵ�
    *@param  conn  Connection ��ü�� ���ڷ� �޴´�
    */
    public ListSet(Connection conn) throws Exception {
        try {
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        }
        catch (Exception ex) {
            this.close();
            throw new Exception("ListSet.ListSet(conn)\r\n"+ex.getMessage());
        }
    }
    /** 
    *Connection ���κ��� ������ PreparedStatement ��ü�� sql ������ �����Ѵ�
    *@param  p  PreparedStatement ��ü�� ���ڷ� �޴´�
    *@param  sql  ������ ���ڷ� �޴´�
    */
    public ListSet(PreparedStatement p) throws Exception{
        pstmt = p;
        try {
            this.executeQuery();
        }
        catch (Exception ex) {
            throw new Exception("ListSet()"+ex.getMessage());
        }
    }
    
     /** 
    *ResultSet, Statement, PreparedStatement ��ü�� �ݴ´�
    */
    public void close() {
        if ( rs != null) try { rs.close(); } catch (Exception e) {}
        if ( stmt != null) try { stmt.close(); } catch (Exception e) {}
        if ( pstmt != null) try { pstmt.close(); } catch (Exception e) {}
    }
    
    /** 
    *Statement ��ü�� SQL ������ ������ ResultSet ��ü�� �����Ѵ�
    *@param  PreparedStatement ��ü�� �޴´�.
    */
    public void run(PreparedStatement p) throws Exception{
    	pstmt = p;
        b_bulletin = false;
        try {
            rs = pstmt.executeQuery();
        }
        catch (Exception ex) {
            this.close();
            throw new Exception("ListSet.run(\""+pstmt+"\")"+ex.getMessage());
        }
    }
    /** 
     *Statement ��ü�� SQL ������ ������ ResultSet ��ü�� �����Ѵ�
     *@param  sql  ������ ���ڷ� �޴´�
     */
     public void run(String sql) throws Exception{
         sQuery = sql;
         b_bulletin = false;
         try {
             rs = stmt.executeQuery(sQuery);
         }
         catch (Exception ex) {
             this.close();
             throw new Exception("ListSet.run(\""+sQuery+"\")"+ex.getMessage());
         }
     }
    /** 
    *PreparedStatement ��ü�� SQL ������ ������ ResultSet ��ü�� �����Ѵ�
    *@param  sql  ������ ���ڷ� �޴´�
    */
    public void executeQuery() throws Exception{
        b_bulletin = false;
        try {
            rs = pstmt.executeQuery();
        }
        catch (Exception ex) {
            this.close();
            throw new Exception("ListSet.executeQuery()"+ex.getMessage());
        }
    }
    
    /** 
    *Ŀ���� ���� row �� �̵���Ų��
    *@return  b  ���� row �� �̵��Ҽ��ִ��� ���θ� ��ȯ�Ѵ�
    */	
    public boolean next() throws Exception {
        boolean b = false;
        
        try {
            current_row_num ++;
            
            if ( b_bulletin ) {
                b = (rs.next() && (current_row_num <= current_page_last_row_num) );
            }
            else {
                b = rs.next();
            }
        }
        catch (Exception ex) {
            this.close();
            throw new Exception("ListSet.next()\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return b;
    }

    /** 
    *���� ó�� row �� �̵��Ѵ�
    */	
    public void moveFirst() throws Exception{
        try{
            rs.beforeFirst();            
            current_row_num = 0;
        }
        catch (Exception ex){
            this.close();
            throw new Exception("ListSet.moveFirst()\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
    }
			
    /** 
    *������ ������ ������ �����Ѵ�
    */	
    private void prepareBulletinQuery() throws Exception {
        try {
        	
        // �������� ��ü���� ���
        	
    		rs.last();	
            total_row_count = rs.getRow();
            rs.beforeFirst();
            
            System.out.println(total_row_count);
            
            
            if (page_size == 0) {
                total_page_count = 1;
            }else {
                total_page_count = (total_row_count + page_size -1) / page_size; // ��ü������ ���� ���
            }
            
//            total_block_count = (total_page_count + block_size -1)/ block_size;	// ��ü ��������
            
//            current_block_num = (current_page_num + block_size -1) / block_size;	// ���� ������ȣ
            
            if (page_size == 0) {
                current_page_last_row_num  = total_row_count;
            }else {
                current_page_last_row_num = current_page_num * page_size ;  // ���� ���������� ��µ� ������ �������� �Ϸù�ȣ
            }
            
            if( current_page_num > 1 ) {
                int n_skip_size = ( current_page_num - 1) * page_size ;
            
                rs.absolute(n_skip_size);
                current_row_num = n_skip_size;
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            this.close();
            throw new Exception("ListSet.prepareBulletinQuery()\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
    }
        
    /** 
    *ResultSetMetaData ��ü�� ��ȯ�Ѵ�
    *@return  md  ResultSetMetaData ��ü�� ��ȯ�Ѵ�
    */
    public ResultSetMetaData getMetaData() throws Exception {
        ResultSetMetaData md = null;
        try {
            md = rs.getMetaData();
        }
        catch (Exception ex) {
            this.close();
            throw new Exception("ListSet.getMetaData()\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return md;
    }
    
    /** 
    *Select SQL ���� �÷����� ���� �����͸� Hashtable �� DataBox �� ��� �����Ѵ�.
    *@return  dbox  DataBox ��ü�� ��ȯ�Ѵ�
    */
    public DataBox getDataBox() throws Exception {
        DataBox dbox = null;
        int columnCount = 0;
        try {
            dbox = new DataBox("responsebox");
            
            ResultSetMetaData meta = this.getMetaData();
            columnCount = meta.getColumnCount();
            for(int i = 1; i <= columnCount; i ++) {
                String columnName = meta.getColumnName(i).toLowerCase();
                String columnType = meta.getColumnTypeName(i).toLowerCase();
                
                Object data = this.getData(columnType, columnName, meta, i);
                
                dbox.put("d_" + columnName, data);
            }
        }
        catch (Exception ex) {ex.printStackTrace();
            throw new Exception("ListSet.getDataBox()\r\n\"" + ex.getMessage());
        }
        return dbox;
    }
    public Map getDataMap() throws Exception {
        Map result = new HashMap();
        int columnCount = 0;
        try {
            
            ResultSetMetaData meta = this.getMetaData();
            columnCount = meta.getColumnCount();
            for(int i = 1; i <= columnCount; i ++) {
                String columnName = meta.getColumnName(i).toLowerCase();
                String columnType = meta.getColumnTypeName(i).toLowerCase();
                
                Object data = this.getData(columnType, columnName, meta, i);
                
                result.put(columnName, data);
            }
        }
        catch (Exception ex) {ex.printStackTrace();
            throw new Exception("ListSet.getDataMap()\r\n\"" + ex.getMessage());
        }
        return result;
    }
    public String getDataString() throws Exception {
        String result = "";
        int columnCount = 0;
        try {
            
            ResultSetMetaData meta = this.getMetaData();
            columnCount = meta.getColumnCount();
            for(int i = 1; i <= columnCount; i ++) {
                String columnName = meta.getColumnName(i).toLowerCase();
                String columnType = meta.getColumnTypeName(i).toLowerCase();
                
                Object data = this.getData(columnType, columnName, meta, i);
                result = (String)data;
                //result.put(columnName, data);
            }
        }
        catch (Exception ex) {ex.printStackTrace();
            throw new Exception("ListSet.getDataString()\r\n\"" + ex.getMessage());
        }
        return result;
    }
    
   
    public Object getData(String type, String name, ResultSetMetaData meta, int columnCount) throws Exception {
        Object o = null;
        try {
            if(type.equals("varchar2")) {
                o = (Object)this.getString(name);
            }
            else if(type.equals("varchar")) {
                o = (Object)this.getString(name);
            }
            else if(type.equals("char")) {
                o = (Object)this.getString(name);
            }
			else if(type.equals("nvarchar")) {
                o = (Object)this.getString(name);
            }
            else if(type.equals("nchar")) {
                o = (Object)this.getString(name);
            }
            else if(type.equals("number")) {
              if(meta.getScale(columnCount) == 0 && meta.getPrecision(columnCount) == 0){  //�÷��� �������� �ʰ� ���� ���϶�
              	DecimalFormat df = new DecimalFormat("#.#######"); 
              	if(String.valueOf(df.format(this.getDouble(name))).indexOf(".") > -1 ) {
                  o = new Double(this.getDouble(name));
                }
                else {
                  o = new Integer(this.getInt(name));
                }
              }else{
                if(meta.getScale(columnCount) != 0 ) {
                    o = new Double(this.getDouble(name));
                }
                else {
                    o = new Integer(this.getInt(name));
                }
              }
            }
            else if(type.equals("numeric")) {
                if(meta.getScale(columnCount) == 0 && meta.getPrecision(columnCount) == 0){  //�÷��� �������� �ʰ� ���� ���϶�
                	DecimalFormat df = new DecimalFormat("#.#######"); 
                	if(String.valueOf(df.format(this.getDouble(name))).indexOf(".") > -1 ) {
                    o = new Double(this.getDouble(name));
                  }
                  else {
                    o = new Integer(this.getInt(name));
                  }
                }else{
                  if(meta.getScale(columnCount) > 0 ) {
                      o = new Double(this.getDouble(name));
                  }
                  else {
                      o = new Integer(this.getInt(name));
                  }
                }
              }
            else if(type.equals("text")) {
                o = (Object)this.getString(name);       
            }
			else if(type.equals("ntext")) {
                o = (Object)this.getString(name);       
            }
			else if(type.equals("int")) {
                o = new Integer(this.getInt(name));       
            }else{
            	o = (Object)this.getString(name);
            }
        }
        catch (Exception ex) {ex.printStackTrace();
            throw new Exception("ListSet.getData()\r\n\"" + ex.getMessage());
        }
        return o;
    }
    
    public String getStringData(String type, String name, ResultSetMetaData meta, int columnCount) throws Exception {
        String str = "";
        try {
            if(type.equals("varchar2")) {
                str = this.getString(name);
            }
            else if(type.equals("varchar")) {
                str =this.getString(name);
            }
            else if(type.equals("char")) {
                str = this.getString(name);
            }
			else if(type.equals("nvarchar")) {
                str =this.getString(name);
            }
            else if(type.equals("nchar")) {
                str = this.getString(name);
            }
            else if(type.equals("number")) {
                if(meta.getScale(columnCount) > 0) {
                    str = (new Float(this.getFloat(name))).toString();
                }
                else {
                  
                    str = (new Integer(this.getInt(name))).toString();
                  
                }
            }
            else if(type.equals("numeric")) {
                if(meta.getScale(columnCount) > 0) {
                    str = (new Float(this.getFloat(name))).toString();
                }
                else {
                  
                    str = (new Integer(this.getInt(name))).toString();
                  
                }
            }
            else if(type.equals("text")) {
                str = this.getString(name);       
            }
			else if(type.equals("ntext")) {
                str = this.getString(name);       
            }
			else if(type.equals("int")) {
                str = (new Integer(this.getInt(name))).toString();
            }else{
            	str = this.getString(name);
            }
        }
        catch (Exception ex) {ex.printStackTrace();
            throw new Exception("ListSet.getStringData()\r\n\"" + ex.getMessage());
        }
        return str;
    }
    
     /** 
    *������������ȣ�� �����Ѵ�.
    *@param  number ���� ��������ȣ
    */
    public void setCurrentPage(int number) throws Exception {
        b_bulletin = true;
        if(number == 0) number = 1;     //      ������������ȣ�� 0 �ϼ������Ƿ� 1 �� �����Ѵ�
        current_page_num = number;
        
        this.prepareBulletinQuery();
    }
    
    /** 
    *������ page ���� �����Ѵ�
    *@param  cnt ������ page ��
    */
    public void setBlockSize(int cnt) {
        block_size = cnt;
    }
    
    /** 
     *������ page ���� �����Ѵ�
     *@param  cnt ������ page ��
     */
     public int getBlockSize() {
         return block_size;
     }
    
    /** 
    *�������� row ������ �����Ѵ�
    *@param  cnt �������� row ��
    */
    public void setPageSize(int cnt) {       // ������ ����� 0 �̸� ��ȭ�鿡 ���θ� ����Ѵ�.
        page_size = cnt;
    }
    
    /** 
    *��ü row ���� ��ȯ�Ѵ�
    *@return  total_row_count ��ü row ���� ��ȯ�Ѵ�
    */
    public int getRowNum() {
        return current_row_num;
    }
    
    /** 
    *��ü row ���� ��ȯ�Ѵ�
    *@return  total_row_count ��ü row ���� ��ȯ�Ѵ�
    */
    public int getTotalCount() {
        return total_row_count;
    }
    
     /** 
    *��ü ������ ���� ��ȯ�Ѵ�
    *@return  total_page_count ��ü ������ ���� ��ȯ�Ѵ�
    */
    public int getTotalPage() {
        return total_page_count;
    }
	
    /** 
    *���� ������ ��ȣ�� ��ȯ�Ѵ�
    *@return  current_page_num ���� ������ ��ȣ�� ��ȯ�Ѵ�
    */
    public int getCurrentPage() {
        return current_page_num;
    }
    
    /** 
    *ResultSet ��ü���� String�� data �� ��´�
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */	
    public String getString(String column) throws Exception{
        String data = "";
        try {
            data = StringManager.trim(rs.getString(column));
        }
        catch (Exception ex){
            throw new Exception("ListSet.getString(\""+column+"\")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return this.chkNull(data);
    }
    
     /** 
    *ResultSet ��ü���� int�� data �� ��´�
    *@param  n  SQL������ ȣ��� �÷������� ���ڷ� �޴´�
    *@return  �÷������� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public String getString(int n) throws Exception{
        String data = "";
        try {
            data = StringManager.trim(rs.getString(n));
        }
        catch (Exception ex){
            throw new Exception("ListSet.getString("+n+")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return this.chkNull(data);
    }
    
     /** 
    *ResultSet ��ü���� int�� data �� ��´�
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public int getInt(String column) throws Exception{
        int data = 0;        
        try{
            data = rs.getInt(column);
        }
        catch (Exception ex){
            throw new Exception("ListSet.getInt(\""+column+"\")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� int�� data �� ��´�
    *@param  n  SQL������ ȣ��� �÷������� ���ڷ� �޴´�
    *@return  �÷������� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */	
    public int getInt(int n) throws Exception{
        int data = 0;       
        try{
            data = rs.getInt(n);
        }
        catch (Exception ex){
            throw new Exception("ListSet.getInt("+n+")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� float�� data �� ��´�
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public float getFloat(String column) throws Exception {
        float data = (float)0.0;
    
        try {
            data = rs.getFloat(column);
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getFloat(\""+column+"\")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        } 
        return data;
    }
    
     /** 
    *ResultSet ��ü���� float�� data �� ��´�
    *@param  n  SQL������ ȣ��� �÷������� ���ڷ� �޴´�
    *@return  �÷������� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public float getFloat(int n) throws Exception {
        float data = (float)0.0;
        
        try {
            data = rs.getFloat(n);
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getFloat("+n+")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }        
        return data;
    }
    
     /** 
    *ResultSet ��ü���� double�� data �� ��´�
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public double getDouble(String column) throws Exception {
        double data = 0.0;
        
        try {
            data = rs.getDouble(column);
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getDouble(\""+column+"\")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� double�� data �� ��´�
    *@param  n  SQL������ ȣ��� �÷������� ���ڷ� �޴´�
    *@return  �÷������� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public double getDouble(int n) throws Exception {
        double data = 0.0;
        
        try {
            data = rs.getDouble(n);
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getDouble("+n+")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� long�� data �� ��´�
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public long getLong(String column) throws Exception{
        long data = 0;
        
        try{
            data = rs.getLong(column);
        }
        catch (Exception ex){
            throw new Exception("ListSet.getLong(\""+column+"\")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� long�� data �� ��´�
    *@param  n  SQL������ ȣ��� �÷������� ���ڷ� �޴´�
    *@return  �÷������� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public long getLong(int n) throws Exception {
        long data = 0;
        
        try {
            data = rs.getLong(n);
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getLong("+n+")\r\n\""+sQuery+"\"\r\n"+ex.getMessage());
        }
        return data;
    }
    
     /** 
    *ResultSet ��ü���� clob�� data �� ��´�.(Oracle 9i or Weblogic �� ���)
    *@param  column  String�� �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
    public String getCharacterStream(String column) throws Exception{
        Reader reader = null;
        StringWriter swriter = new StringWriter();
        String data = "";
        int ch = 0;
        int isNull = 0;
        
        try {
            reader = rs.getCharacterStream(column);
            if (reader != null) {
                while( (ch = reader.read()) != -1 ){
                    swriter.write(ch);
                }
                data = swriter.toString();
            }
            else {
                isNull = 1;
            }
        }
        catch (Exception ex){
            throw new Exception("ListSet.getCharacterStream(\""+column+"\")"+ex.getMessage());
        }
        finally{
            if (reader != null) { try { reader.close(); } catch(Exception e) {} }
            if (swriter != null) { try { swriter.close(); } catch(Exception e1) {} }
        }
        if (isNull == 1) return "";
        else return this.chkNull(data);
    }
    	    
    /** 
    *Statement ��ü�� Oracle�� blob�� Field�� ������ ����Ѵ�.(Only Oracle 8i)
    *@param  column  �÷����� ���ڷ� �޴´�
    *@return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
	/*
    public String getOracleBLOB(String column) throws Exception {
        BLOB blob = null;
        InputStream input = null;
        BufferedInputStream bis = null;
        byte [] buf = null;                 // Blob buffer  
        String data = ""; 
        try {                                           
            blob = ((OracleResultSet)rs).getBLOB(column);
            buf = new byte[blob.getChunkSize()];  
            
            input = blob.getBinaryStream();
            bis = new BufferedInputStream(input);

            int length = 0;

            bis.read(buf);
            
            input.close();  
            bis.close();  
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getBlob"+ex.getMessage());
        }
        return data;
    }	
    */

    /** 
    * Statement ��ü�� Oracle�� clob�� Field�� ������ ����Ѵ�.(Only Oracle 8i)
    @param  column  �÷����� ���ڷ� �޴´�
    @return  �÷����� �ش�Ǵ� data �� ��ȯ�Ѵ�
    */
	/*
    public String getOracleCLOB(String column) throws Exception {
        CLOB clob = null;
        Reader rd = null;
        char [] cbuf = null;                 // Clob buffer  
        String data = ""; 
        StringBuffer sb = null;
        try {                                           
            clob = ((OracleResultSet)rs).getCLOB(column);  
            cbuf = new char[clob.getChunkSize()];  

            rd = clob.getCharacterStream();  
            
            int readcnt;
            sb = new StringBuffer();
            while ((readcnt = rd.read(cbuf)) != -1) {
                sb.append(cbuf, 0, readcnt);
            }
            rd.close();     
        }
        catch (Exception ex) {
            throw new Exception("ListSet.getClob"+ex.getMessage());
        }
        return sb.toString();
    }
	*/
    
        
    public String chkNull(String sql) {
        if ( sql == null ) 
            return "";
        else
            return sql;
    }
    
}