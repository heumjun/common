package com.stx.common.util;

import java.util.*;
public class FrameworkUtil {
	
    public static ArrayList split(String s, String s1)
    {
        if(s == null)
            return new ArrayList(0);
        if(s1 == null)
            s1 = "~";
        StringTokenizer stringtokenizer = new StringTokenizer(s, s1, true);
        ArrayList stringlist = new ArrayList(stringtokenizer.countTokens());
        String s2;
        String s3;
                for(s3 = null; stringtokenizer.hasMoreTokens(); s3 = s2)
        {
            s2 = stringtokenizer.nextToken();
            if(s1.equals(s2))
            {
                if(s1.equals(s3))
                    stringlist.add(new String());
            } else
            {
                stringlist.add(s2);
            }
        }

        if(s1.equals(s3))
            stringlist.add(new String());
        return stringlist;
    }	

}
