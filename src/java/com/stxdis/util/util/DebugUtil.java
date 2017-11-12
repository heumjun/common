/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.stxdis.util.util;

import java.io.PrintStream;

public class DebugUtil
{

    private DebugUtil()
    {
    }

    public static void debug(String s)
    {
        if(_debug)
            System.out.println(s);
    }

    public static void debug(String s, String s1)
    {
        if(_debug)
        {
            System.out.print(s);
            System.out.println(s1);
        }
    }

    public static void debug(String s, String s1, String s2)
    {
        if(_debug)
        {
            System.out.print(s);
            System.out.print(s1);
            System.out.println(s2);
        }
    }

    public static void setDebug(boolean flag)
    {
        _debug = flag;
    }

    protected static boolean _debug = false;

}


/*
	DECOMPILATION REPORT

	Decompiled from: C:\workspace\old_plm\ematrix\WEB-INF\lib\domain.jar
	Total time: 150 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/