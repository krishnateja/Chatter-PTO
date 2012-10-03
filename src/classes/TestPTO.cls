public class TestPTO {
   public static testMethod void testRunAs() {
        
        User u1 = [SELECT Id FROM User WHERE Alias='AUser'];
            System.RunAs(u1){
            
            PTO__c p = new PTO__c();
            p.Email__c = 'kkarnam@salesforce.com';
            p.Message__c = 'test';
            Date orig = Date.today();
            DateTime dtConverted = DateTime.newInstance(orig.year(), orig.month(), orig.day());
            
            p.Out_Of_Office_From__c = dtConverted ;
            p.Out_Of_Office_To__c= dtConverted ;
            insert p;
            
            FeedItem fItem = new FeedItem();
            fItem.body = 'Did you go through the mock-ups @Admin User';
            fItem.parentId = u1.Id;
            Insert fItem;
            
            
            
          }   
   }
}