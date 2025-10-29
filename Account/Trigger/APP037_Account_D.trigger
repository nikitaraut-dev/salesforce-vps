trigger APP037_Account_D on Account (after delete) 
{
    Integer counter = 0;
    JSONGenerator js = JSON.createGenerator(true);
    
    js.writeStartArray();
    for(Account afterAccount : Trigger.old)
    {
        js.writeStartObject();
        VPS_JsonString.Add(js, 'Id', afterAccount.Id);
        js.writeEndObject();
        counter++;
    
    }
    js.writeEndArray();

    if (counter > 0)
    {
        APP037_SendToHttp.Send('Account','Delete', js.getAsString());
    }
}