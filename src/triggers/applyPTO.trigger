trigger applyPTO on FeedItem (after insert) {

public List<PTO__c> ptoDetails ;
String ptoFlag;
String body;
Integer index;
Integer dynamicIndex=0;
Integer indexBlankSpace;
String firstName;
String dynamicQuery ;
String fullName;
Boolean existsInFeedItemFlag;

    for(FeedItem fi : Trigger.new){                
        body = fi.body;
        system.debug('-----'+body );
        if(body.contains('@')){
           index = body.indexOf('@',dynamicIndex);
           indexBlankSpace = body.indexOf(' ',index);           
           firstName = body.substring(index+1,indexBlankSpace );
           
           dynamicIndex = indexBlankSpace;
           
           dynamicQuery = 'SELECT name,firstname,lastname,PTO__c,id,email from USER where name LIKE\''+firstName+'%\'';
           List<User> u =  Database.query(dynamicQuery );
           
           system.debug('-----'+u);
           
           for(User usr : u){
           system.debug('-----'+usr);
               fullName = usr.firstname + ' '+usr.lastname;               
               existsInFeedItemFlag = body.contains('@'+fullname);
               system.debug('---existsInFeedItemFlag --'+existsInFeedItemFlag );
               if(body.contains('@'+fullname)){ 
               system.debug('--loop---');              
                   if(usr.PTO__c){  
                   system.debug('--usr.PTO__c---'+usr.email);                      
                       ptoDetails= [select id,Message__c,Out_Of_Office_To__c,Out_Of_Office_From__c from PTO__c where email__c =: usr.email LIMIT 1];                       
                       
                       if (ptoDetails.size() > 0) {
                           Datetime cDT = System.now(); 
                           if(cDT > ptoDetails[0].Out_Of_Office_From__c && cDT  < ptoDetails[0].Out_Of_Office_To__c){                           
                               FeedComment fc = new FeedComment ();
                               fc.FeedItemId = fi.id;
                               fc.CreatedById = usr.id;
                               fc.CommentBody = ptoDetails[0].Message__c;                       
                               insert fc;
                           }
                       
                       
                       }
                                                                         
                   }    
               }
           }
           
           
           
        }
        
        
        
    }

}