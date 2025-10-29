trigger Assignzeroifnull on Account ( after update, after insert) {
     set<id> setid = new set<id>();
         if(Trigger.isupdate||Trigger.isinsert)
          {
           for(account acc:trigger.new)
            {
               setid.add(acc.id);          
                 
              } 
               
             
           }

         }