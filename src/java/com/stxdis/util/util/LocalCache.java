package com.stxdis.util.util;

import java.util.*; 
public class LocalCache{
	
	private Hashtable local_hashtable = new Hashtable();
	
	private static LocalCache shared_object = new LocalCache();
	
	private int limit_chche_entry = 10000;
	
	public Timer timer = new Timer();
	
	boolean isMutexOpen = true;
	
	private LocalCache()
	{
	// Do not use Constructor() because of Singleton instance
	}
	public static LocalCache getInstance()
	{
		return shared_object;
	}
	public void startTimer(int limit_mili_sec)
	{
			timer.schedule(new CleanCacheTimerTask(), limit_mili_sec);
	}
	public void stopTimer()
	{
		timer.cancel();
	}
	public void setLimitEntry(int limit_number)
	{
		limit_chche_entry = limit_number;
	}
	public int getLimitEntry()
	{
		return this.limit_chche_entry;
	}
	public boolean setCache(String key, Object value){
		boolean is_added = false;
		for (;;){
		
			if (isMutexOpen == false){
				if (isExistKey(key) == true){
					is_added = false;
					break;
				}
			}else{
				isMutexOpen = false;
				if (this.countCache() >= limit_chche_entry)
				{
					System.out.println("limit number : "+ this.limit_chche_entry);
					is_added = false;
				}else{
					this.local_hashtable.put(key, value);
					is_added = true;
				}
				isMutexOpen = true;
				break;
			}
		}
		return is_added;
	}
	public Object getCache(String key){
		return this.local_hashtable.get(key);
	}
	public boolean isExistKey(String key){
		return this.local_hashtable.containsKey(key);
	}
	public void clearCache(){
		this.local_hashtable.clear();
	}
	public void delKeyInCache(String key){
		if (this.local_hashtable.containsKey(key) == true){
			this.local_hashtable.remove(key);
		}
	}
	public int countCache(){
		return this.local_hashtable.size();
	}
} 
	
	class CleanCacheTimerTask extends TimerTask{
		public void run()
		{
			LocalCache cache = LocalCache.getInstance();
			cache.clearCache();
			cache.timer.cancel();
		}
	} 