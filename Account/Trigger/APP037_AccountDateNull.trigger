trigger APP037_AccountDateNull on Account (before update) {
    
    date nullDate = date.newInstance(1900,1,1);
    
for(Account a : Trigger.New) {
        if (a.Expired__c == nullDate) {
            a.Expired__c = null;
        }        
    }
}