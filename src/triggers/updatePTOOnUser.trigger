trigger updatePTOOnUser on PTO__c (after insert, after update) {

    for( PTO__c  p : Trigger.new){
        
        User u = [select id,email from User where email = : p.email__c limit 1];
            
        u.PTO__c = true;    
        u.email = p.email__c;
        update u;
        
    }

}