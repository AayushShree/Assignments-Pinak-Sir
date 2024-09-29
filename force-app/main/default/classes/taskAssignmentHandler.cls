public class taskAssignmentHandler {
    public static void highPriorityAssign(List<Task> tsk){
        Set<Id> tskId = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        if(!tsk.isEmpty()){
            for(Task t: tsk){
                if((t.Priority == 'High')&&(t.WhatId!=NULL)){
                	tskId.add(t.Id);
                    accId.add(t.WhatId);
                }
            }
            if((!tskId.isEmpty())&&(!accId.isEmpty())){
            	List<User> tskOwner = [Select Id, ManagerId 
                                       from User 
                                       Where Id IN (Select OwnerId From Account Where Id = :accId) 
                                       AND ManagerId != NULL];
            	Map<Id,Id> uId2ManId = new Map<Id, Id>();
            	if(!tskOwner.isEmpty()){
                	for(User u: tskOwner){
                		uId2ManId.put(u.Id, u.ManagerId);
	            	}
    	           	for(Task t : tsk){                    
        	           	t.OwnerId = uId2ManId.get(t.OwnerId);
    	    	    }
	            }
            }
        }
    }
    //public static void lowNormalPriorityAssign(List<Task> tsk){
        
    }
//}