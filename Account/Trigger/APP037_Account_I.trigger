trigger APP037_Account_I on Account (after insert, after undelete) 
{
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

        js.writeEndObject();
    }
    js.writeEndArray();

    if (counter > 0)
    {
        APP037_SendToHttp.Send('Account', 'Insert', js.getAsString());
    }
}