package com.stx.tbc.dao.factory;

import java.util.ArrayList;
import com.stx.common.library.RequestBox;
import com.stx.common.util.TBCCommonDataBaseInterface;

public interface Idao extends TBCCommonDataBaseInterface 
{
	public ArrayList selectDB(String qryExp,RequestBox rBox)throws Exception;
	
	public boolean insertDB(String qryExp,RequestBox rBox)throws Exception;
	
	public boolean deleteDB(String qryExp,RequestBox rBox)throws Exception;
	
	public boolean updateDB(String qryExp,RequestBox rBox)throws Exception;
}
