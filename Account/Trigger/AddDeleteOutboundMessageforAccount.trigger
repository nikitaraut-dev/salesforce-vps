Trigger AddDeleteOutboundMessageforAccount on Account (after delete)
{
     List<Deleted_Record_Scheduler__c> sub=new List<Deleted_Record_Scheduler__c>();
     for(Account v : Trigger.old)
     {
                   Deleted_Record_Scheduler__c s=new Deleted_Record_Scheduler__c();
                   s.Deleted_Record_Name__c=v.Name;
                   s.Deleted_Record_ID__c=v.ID;
                   s.Parent_Record_ID__c='N/A';
                   s.Object_of_Deleted_Record__c='Account';
                   s.Status__c='Scheduled';
                   //add other fields of subject here and add volunteer values in that.
                 
                   sub.add(s);
            if(sub.size()>0)
            insert sub;
     }
}