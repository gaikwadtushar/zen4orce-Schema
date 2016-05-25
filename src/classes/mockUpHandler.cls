public class mockUpHandler {
    public String selectedObj{get;set;}
    public List<SelectOption> objects{get;set;}
    Public List<String> selectedFields{get;set;}
    public List<SObject> records{get;set;}
    public map<String,schema.SObjectType> gd=schema.getGlobalDescribe();
    List<String>  objList= new list<String>();
    public mockUpHandler()
    {
        selectedFields=new List<String>();
       	selectedFields.add('DeveloperName');
        selectedFields.add('Mandatory_Fields__c');
        String query='select DeveloperName,Mandatory_Fields__c from Meta__mdt';
        records=Database.query(query);
        
        objList.addAll(gd.keySet());
        Schema.DescribeSObjectResult[] results= Schema.DescribeSObjects(objList);
        objects=new List<SelectOption>();
		objects.add(new selectOption('Select','Select'));
        for(Schema.DescribeSObjectResult res:results) 
        {
            if(res.isCreateable() && res.isUpdateable())
            objects.add(new selectOption(res.getName(),res.getLabel()));
        }
    }
    public static void myMethod()
    {
        List<SObject> queryResults = Database.query('select DeveloperName,Mandatory_Fields__c from Meta__mdt');
		List<String> queryFields=new List<String>(); 
        map<String,schema.SObjectType> gd=schema.getGlobalDescribe();
		Schema.SObjectType so = gd.get('Meta__mdt');
        Schema.DescribeSObjectResult r = so.getDescribe();
	    Map<String, Schema.SObjectField> M = r.fields.getMap();
        for(Schema.SObjectField fieldAPI : M.values())  
        {  
        	Schema.DescribeFieldResult dfr =fieldAPI.getDescribe();
            if(dfr.isNameField())
                queryFields.add(fieldAPI.getDescribe().getLocalName());
            if(dfr.isCustom())
            	queryFields.add(fieldAPI.getDescribe().getLocalName());
        } 
		String csvFileString = ''; 
		for(String fieldName : queryFields)
		{
    		csvFileString = csvFileString + ',' + fieldName.replace(',','');
		} 
		csvFileString = csvFileString.replaceFirst(',','') + '\n';
		String fileRow = '';
		String fieldValue = '';
		/*for(SObject obj : queryResults) 
		{
    		fileRow = '';
		    System.debug('===>' + obj); 
	    	for(String fieldName : queryFields)
	    	{
		        fieldValue = '' + obj.get(fieldName);
    		    fieldValue = fieldValue.replace(',','');
        		fileRow = fileRow + ',' + fieldValue;
	    	}
		    fileRow = fileRow.replaceFirst(',','');
    		csvFileString = csvFileString + fileRow + '\n';
	    	
		}*/
		Blob csvBlob = Blob.valueOf(csvFileString);
		/*Attachment AttachmentObj = new Attachment(Body = csvBlob,
                              Name = 'Test-' +System.now().format('yyyy-MMM-dd-hh-mm-ss') + '.csv',
                              parentId = '0012800000dXv5a');
        
		insert AttachmentObj;   */
   	}
}