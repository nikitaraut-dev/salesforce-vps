Trigger APP037_Account_U on Account (after update)
{

    String uid = UserInfo.getUserId();
    Boolean overrideTrigger = Boolean.valueOf([select Override_Apex_Triggers__c from User where Id = :uid].Override_Apex_Triggers__c);

    if (overrideTrigger == true)
    {
        System.debug('[APP037_Account_U] Trigger skipped - Override selected in User record!');
    } 
    else
    {
        System.debug('[APP037_Account_U] Begin Trigger...');
        JSONGenerator js = JSON.createGenerator(true);
        Integer counter = 0;

        js.writeStartArray();
        for(Account afterAccount : Trigger.new)
        {
            counter++;
            js.writeStartObject();
            Map<String,Object> m = afterAccount.getPopulatedFieldsAsMap();

            Map<String,Object> m2 = new Map<String,Object>();
            for(String key : m.keySet()) 
            {
                Object value1 = m.get(key);
                m2.put(key.toLowerCase(), value1);
            }

            Schema.DescribeSObjectResult objDescribe = afterAccount.getSObjectType().getDescribe();
            Map<String,Object> accMap = objDescribe.fields.getMap();

            for(String key : accMap.keySet()) 
            {
                VPS_JsonString.Add(js, key, m2.get(key.toLowerCase()));
            }

            if (!String.isBlank(afterAccount.Customer_Discount_Class__c)) 
            {
                String customerDiscountClass = [select Name from Discount__c where Id = :afterAccount.Customer_Discount_Class__c].Name;
                VPS_JsonString.Add(js, 'CustomerPriceGroup', customerDiscountClass);
            }

            js.writeEndObject();
        }
        js.writeEndArray();

        if (counter > 0)
        {
            APP037_SendToHttp.Send('Account', 'Update', js.getAsString());
        }
        System.debug('[APP037_Account_U] End Trigger.');
    }
}