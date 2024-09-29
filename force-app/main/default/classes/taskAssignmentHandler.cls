public class taskAssignmentHandler {
    public static List<User> randomizeUser(List<User> usrLst){
        Integer currentIndex = listOfUsers.size();
        User tempUser;
        Integer randomUserIndex;
        //List<User> randomUserList = new List<User>();
        while (currentIndex != 0) {
            Integer randomUserIndex = Math.floor(Math.random() * currentIndex).intValue();
            currentIndex -= 1;
            //randomUserList.add(listOfUsers[randomUserIndex]);
            tempUser = usrLst[currentIndex];
            usrLst[currentIndex] = usrLst[randomUserIndex];
            usrLst[randomUserIndex] = tempUser;
        }
        return usrLst;
    }
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
    public static void lowNormalPriorityAssign(List<Task> tsk){
        Set<Id> tskId = new Set<Id>();
        Set<Id> accId = new Set<Id>();
        if(!tsk.isEmpty()){
            for (Task t : tsk) {
                if((t.Priority != 'High') && (t.WhatId != NULL)){
                    tskId.add(t.Id);
                    accId.add(t.WhatId);
                }
            }
            if(!(tskId.isEmpty() && accId.isEmpty())){
                List<User> accOwners = [SELECT Id, ManagerId FROM User WHERE (ManagerId IN (SELECT OwnerId FROM Account WHERE Id = :accId) AND Manager.isActive = TRUE)];
                Map<Id, Id> accOwnerId2usrId = new Map<Id, Id>();
                if (!accOwners.isEmpty()) {
                    List<User> randomizedUserLst = randomizeUser(accOwners);
                    //Boolean condition = randomizedUserLst.isEmpty() ? false : true;
                    for (User u : randomizedUserLst) {
                        if (!accOwnerId2usrId.keySet().contains(u.ManagerId)) {
                            accOwnerId2usrId.put(u.ManagerId, u.Id);
                        }
                    }
                    if (!accOwnerId2usrId.isEmpty()) {
                        for (Task t : tsk) {
                            t.OwnerId = accOwnerId2usrId.get(t.OwnerId);
                        }
                    }   
                }
            }
        }        
    }
}